# Godot 4 Reference

Engine-specific patterns, coding standards, and best practices for Godot 4 (GDScript).

---

## Version Awareness

| Field | Value |
|-------|-------|
| **Stable Versions** | 4.3 (well-documented) through 4.6 (latest) |
| **LLM Knowledge Cutoff** | ~May 2025 (covers up to ~Godot 4.3) |
| **Risk for 4.4+** | MEDIUM to HIGH -- verify APIs for 4.4, 4.5, 4.6 changes |

### Post-Cutoff Key Changes

| Version | Key Changes |
|---------|------------|
| 4.4 | Jolt physics option, FileAccess return type changes, shader texture type changes |
| 4.5 | AccessKit accessibility, variadic args, @abstract annotation, shader baker, SMAA |
| 4.6 | Jolt default physics, glow rework, D3D12 default on Windows, IK restoration |

When working with Godot 4.4+, always verify API usage against official docs: https://docs.godotengine.org/en/stable/

---

## GDScript Coding Standards

### Static Typing (Mandatory)

Always use static typing for all variables, parameters, and return types:

```gdscript
# GOOD: Fully typed
var health: int = 100
var move_speed: float = 200.0
var player_name: String = ""
var inventory: Array[Item] = []

func take_damage(amount: int) -> void:
    health -= amount

func get_health_percentage() -> float:
    return float(health) / float(max_health)

# BAD: Untyped
var health = 100
func take_damage(amount):
    health -= amount
```

### Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Classes | PascalCase | `PlayerController` |
| Variables/functions | snake_case | `move_speed`, `take_damage()` |
| Signals | snake_case past tense | `health_changed`, `item_collected` |
| Files | snake_case matching class | `player_controller.gd` |
| Scenes | PascalCase matching root node | `PlayerController.tscn` |
| Constants | UPPER_SNAKE_CASE | `MAX_HEALTH`, `GRAVITY` |
| Enums | PascalCase (type), UPPER_SNAKE_CASE (values) | `enum State { IDLE, RUNNING, JUMPING }` |
| Private members | Prefix with `_` | `var _internal_state: int` |

### Signal-Based Decoupling

Use signals for communication between unrelated systems. Never have systems directly reference each other when signals can be used:

```gdscript
# GOOD: Signal-based communication
signal health_changed(new_health: int, max_health: int)
signal died

func take_damage(amount: int) -> void:
    _health = maxi(_health - amount, 0)
    health_changed.emit(_health, _max_health)
    if _health <= 0:
        died.emit()

# BAD: Direct coupling
func take_damage(amount: int) -> void:
    _health -= amount
    get_node("/root/Main/UI/HealthBar").update_health(_health)
    if _health <= 0:
        get_node("/root/Main/GameManager").on_player_died()
```

### @onready Pattern

Use `@onready` for node references instead of `_ready()` assignments:

```gdscript
# GOOD
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

# BAD
var sprite: Sprite2D

func _ready() -> void:
    sprite = $Sprite2D
```

### @export for Designer-Tunable Values

```gdscript
@export var move_speed: float = 200.0
@export var jump_force: float = -400.0
@export_range(0.0, 1.0) var friction: float = 0.8
@export_group("Combat")
@export var max_health: int = 100
@export var attack_damage: int = 10
@export var attack_cooldown: float = 0.5
```

---

## Node/Scene Architecture Patterns

### Composition Over Inheritance

Build complex entities by composing scenes, not deep inheritance hierarchies:

```
Player.tscn
  CharacterBody2D (root)
    Sprite2D
    CollisionShape2D
    HealthComponent.tscn      # Reusable
    HitboxComponent.tscn      # Reusable
    HurtboxComponent.tscn     # Reusable
    StateMachine.tscn          # Reusable
    AnimationPlayer
```

### Component Pattern

Create reusable components as separate scenes:

```gdscript
# health_component.gd
class_name HealthComponent
extends Node

signal health_changed(new_health: int, max_health: int)
signal died

@export var max_health: int = 100
var _health: int

func _ready() -> void:
    _health = max_health

func take_damage(amount: int) -> void:
    _health = maxi(_health - amount, 0)
    health_changed.emit(_health, max_health)
    if _health <= 0:
        died.emit()

func heal(amount: int) -> void:
    _health = mini(_health + amount, max_health)
    health_changed.emit(_health, max_health)
```

### Scene Tree Organization

```
Root (Node2D or Node3D)
  World
    TileMap / GridMap
    Entities
      Player
      Enemies
      NPCs
    Pickups
    Projectiles
  UI (CanvasLayer)
    HUD
    Menus
    Dialogs
  Managers (Node)
    GameManager
    AudioManager
    SaveManager
```

---

## Resource UIDs and Data-Driven Design

### Use Resources for Data

```gdscript
# weapon_data.gd
class_name WeaponData
extends Resource

@export var weapon_name: String = ""
@export var damage: int = 10
@export var attack_speed: float = 1.0
@export var range_distance: float = 50.0
@export var sprite: Texture2D
```

Create `.tres` files in the editor for each weapon variant. Reference by UID for stability:

```gdscript
# Always use UIDs when loading resources
var sword: WeaponData = preload("uid://abc123def456")
```

### Object Pooling

For frequently spawned objects (projectiles, particles, enemies):

```gdscript
class_name ObjectPool
extends Node

@export var scene: PackedScene
@export var pool_size: int = 20

var _pool: Array[Node] = []

func _ready() -> void:
    for i in pool_size:
        var instance: Node = scene.instantiate()
        instance.visible = false
        instance.process_mode = Node.PROCESS_MODE_DISABLED
        add_child(instance)
        _pool.append(instance)

func get_instance() -> Node:
    for obj in _pool:
        if not obj.visible:
            obj.visible = true
            obj.process_mode = Node.PROCESS_MODE_INHERIT
            return obj
    # Pool exhausted -- expand or return null
    return null

func release(instance: Node) -> void:
    instance.visible = false
    instance.process_mode = Node.PROCESS_MODE_DISABLED
```

---

## Common Patterns

### State Machine

```gdscript
# state_machine.gd
class_name StateMachine
extends Node

@export var initial_state: State
var current_state: State

func _ready() -> void:
    for child in get_children():
        if child is State:
            child.state_machine = self
    current_state = initial_state
    current_state.enter()

func _process(delta: float) -> void:
    current_state.update(delta)

func _physics_process(delta: float) -> void:
    current_state.physics_update(delta)

func transition_to(target_state_name: String) -> void:
    var new_state: State = get_node(target_state_name) as State
    if new_state == null:
        return
    current_state.exit()
    current_state = new_state
    current_state.enter()

# state.gd
class_name State
extends Node

var state_machine: StateMachine

func enter() -> void:
    pass

func exit() -> void:
    pass

func update(_delta: float) -> void:
    pass

func physics_update(_delta: float) -> void:
    pass
```

### Animation Tree Integration

Use AnimationTree with state machine mode for character animations:
- Set up AnimationNodeStateMachine in the editor
- Control transitions from code via conditions
- Use blend spaces for movement (idle -> walk -> run)
- Sync animation events with gameplay via method calls or signals

### Input Handling

```gdscript
# Use Input Map actions, not raw key checks
func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("jump"):
        _jump()
    if event.is_action_pressed("attack"):
        _attack()

func _physics_process(delta: float) -> void:
    var input_direction: Vector2 = Input.get_vector(
        "move_left", "move_right", "move_up", "move_down"
    )
    velocity = input_direction * move_speed
    move_and_slide()
```

---

## Performance Best Practices

### Physics Layers

Use collision layers and masks to minimize physics checks:
- Layer 1: Player
- Layer 2: Enemies
- Layer 3: Environment
- Layer 4: Projectiles
- Layer 5: Pickups

Only enable masks for interactions that need to happen (e.g., player projectiles only check enemy layer).

### Visibility Notifiers

Use `VisibleOnScreenNotifier2D/3D` to disable processing for off-screen entities:

```gdscript
@onready var notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
    notifier.screen_entered.connect(_on_screen_entered)
    notifier.screen_exited.connect(_on_screen_exited)

func _on_screen_entered() -> void:
    set_physics_process(true)
    visible = true

func _on_screen_exited() -> void:
    set_physics_process(false)
    visible = false
```

### Instancing Best Practices

- Use `PackedScene.instantiate()` for dynamic spawning
- Preload scenes used frequently: `const BULLET_SCENE: PackedScene = preload("res://scenes/bullet.tscn")`
- Pool frequently spawned objects (see Object Pooling pattern above)
- Use `call_deferred("add_child", instance)` when spawning during physics

### General Performance Rules

- Avoid `get_node()` every frame -- cache references with `@onready`
- Use `_physics_process()` only for physics-related code
- Minimize signal connections/disconnections during gameplay
- Use groups for bulk operations: `get_tree().call_group("enemies", "take_damage", 10)`
- Profile with the built-in Profiler and Monitor panels

---

## Testing in Godot (GUT Framework)

Use the GUT (Godot Unit Test) framework for automated testing:

```gdscript
# test_health_component.gd
extends GutTest

var _health_comp: HealthComponent

func before_each() -> void:
    _health_comp = HealthComponent.new()
    _health_comp.max_health = 100
    add_child(_health_comp)
    _health_comp._ready()

func after_each() -> void:
    _health_comp.queue_free()

func test_initial_health_equals_max() -> void:
    assert_eq(_health_comp._health, 100)

func test_take_damage_reduces_health() -> void:
    _health_comp.take_damage(30)
    assert_eq(_health_comp._health, 70)

func test_health_cannot_go_below_zero() -> void:
    _health_comp.take_damage(150)
    assert_eq(_health_comp._health, 0)

func test_died_signal_emitted_at_zero_health() -> void:
    watch_signals(_health_comp)
    _health_comp.take_damage(100)
    assert_signal_emitted(_health_comp, "died")
```

### Testing Best Practices

- Test gameplay formulas and edge cases
- Test state machine transitions
- Test resource loading
- Use `watch_signals()` to verify signal emissions
- Mock external dependencies when possible
- Run tests before merging (integrate with CI)
