#!/bin/bash
# ClawHub batch publisher with progress tracking
# Publishes 5 skills per hour (rate limit: 5 new skills/hour)
# Tracks progress in a state file so you can resume after interruption
#
# Usage:
#   ./scripts/clawhub-publish.sh          # Run from skills/ directory
#   ./scripts/clawhub-publish.sh --reset  # Reset progress and start over

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
STATE_FILE="$SKILLS_DIR/scripts/.clawhub-progress.json"
LOG_FILE="$SKILLS_DIR/scripts/clawhub-publish.log"

# All skills to publish (prefixed with eb-)
ALL_SKILLS=(
  analytics
  brainstorm
  branding
  code-review
  dev-workflow
  devops-deploy
  founder
  grill-me
  idea-validation
  improve-codebase-architecture
  landing-page
  legal-compliance
  marketing
  prd-to-issues
  senior-backend
  senior-frontend
  senior-qa
  seo
  software-architect
  video-creator
  video-editor
  write-a-prd
)

# Reset progress if requested
if [[ "${1:-}" == "--reset" ]]; then
  rm -f "$STATE_FILE"
  echo "Progress reset. Run again without --reset to start publishing."
  exit 0
fi

# Load or initialize progress
if [[ -f "$STATE_FILE" ]]; then
  echo "Resuming from previous progress..."
else
  echo '{"published":[],"failed":[]}' > "$STATE_FILE"
fi

get_published() {
  python3 -c "import json; print('\n'.join(json.load(open('$STATE_FILE'))['published']))" 2>/dev/null || true
}

get_failed() {
  python3 -c "import json; print('\n'.join(json.load(open('$STATE_FILE'))['failed']))" 2>/dev/null || true
}

mark_published() {
  local skill="$1"
  python3 -c "
import json
with open('$STATE_FILE') as f: data = json.load(f)
if '$skill' not in data['published']: data['published'].append('$skill')
if '$skill' in data['failed']: data['failed'].remove('$skill')
with open('$STATE_FILE', 'w') as f: json.dump(data, f, indent=2)
"
}

mark_failed() {
  local skill="$1"
  local reason="$2"
  python3 -c "
import json
with open('$STATE_FILE') as f: data = json.load(f)
if '$skill' not in data['failed']: data['failed'].append('$skill')
with open('$STATE_FILE', 'w') as f: json.dump(data, f, indent=2)
"
}

# Build list of remaining skills
PUBLISHED=$(get_published)
REMAINING=()
for skill in "${ALL_SKILLS[@]}"; do
  if ! echo "$PUBLISHED" | grep -q "^${skill}$"; then
    REMAINING+=("$skill")
  fi
done

TOTAL=${#ALL_SKILLS[@]}
DONE=$(echo "$PUBLISHED" | grep -c . 2>/dev/null || echo 0)

echo "=== ClawHub Publish ==="
echo "Total: $TOTAL | Published: $DONE | Remaining: ${#REMAINING[@]}"
echo ""

if [[ ${#REMAINING[@]} -eq 0 ]]; then
  echo "All skills already published!"
  exit 0
fi

# Publish in batches of 5
BATCH_COUNT=0
for i in "${!REMAINING[@]}"; do
  skill="${REMAINING[$i]}"

  # Every 5 skills, wait 61 minutes (except first batch)
  if [[ $((BATCH_COUNT % 5)) -eq 0 ]] && [[ $BATCH_COUNT -ne 0 ]]; then
    NEXT_TIME=$(date -v+61M "+%H:%M" 2>/dev/null || date -d "+61 minutes" "+%H:%M" 2>/dev/null || echo "~61min")
    echo ""
    echo "[$(date "+%H:%M:%S")] Batch done. Waiting 61 minutes for rate limit reset (resuming ~$NEXT_TIME)..."
    echo "[$(date "+%H:%M:%S")] You can Ctrl+C and resume later — progress is saved."
    echo ""
    sleep 3660
  fi

  echo -n "[$(date "+%H:%M:%S")] Publishing eb-${skill}... "

  OUTPUT=$(clawhub publish "$SKILLS_DIR/${skill}" --slug "eb-${skill}" --version 1.0.0 2>&1) && {
    echo "OK"
    mark_published "$skill"
    echo "[$(date)] OK: eb-${skill}" >> "$LOG_FILE"
  } || {
    if echo "$OUTPUT" | grep -q "Rate limit"; then
      echo "RATE LIMITED — will retry next batch"
      # Don't increment batch count, will retry
      echo "[$(date)] RATE_LIMITED: eb-${skill}" >> "$LOG_FILE"
      sleep 60
      continue
    elif echo "$OUTPUT" | grep -q "too thin"; then
      echo "REJECTED (content too thin)"
      mark_failed "$skill"
      echo "[$(date)] REJECTED: eb-${skill} — content too thin" >> "$LOG_FILE"
    elif echo "$OUTPUT" | grep -q "already taken\|already exists"; then
      echo "ALREADY EXISTS — marking as done"
      mark_published "$skill"
      echo "[$(date)] EXISTS: eb-${skill}" >> "$LOG_FILE"
    else
      echo "FAILED: $(echo "$OUTPUT" | tail -1)"
      mark_failed "$skill"
      echo "[$(date)] FAILED: eb-${skill} — $OUTPUT" >> "$LOG_FILE"
    fi
  }

  BATCH_COUNT=$((BATCH_COUNT + 1))
  sleep 10
done

echo ""
echo "=== Done ==="
DONE_NOW=$(get_published | grep -c . 2>/dev/null || echo 0)
FAILED_NOW=$(get_failed | grep -c . 2>/dev/null || echo 0)
echo "Published: $DONE_NOW/$TOTAL"
[[ $FAILED_NOW -gt 0 ]] && echo "Failed: $FAILED_NOW ($(get_failed | tr '\n' ', '))"
echo "Progress saved in: $STATE_FILE"
echo "Log: $LOG_FILE"
