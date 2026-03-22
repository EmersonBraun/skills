# Unity Reference

Engine-specific patterns, coding standards, and best practices for Unity (C#).

---

## Version Awareness

| Field | Value |
|-------|-------|
| **Current LTS** | Unity 6.3 LTS (December 2025) |
| **LLM Knowledge Cutoff** | ~May 2025 (covers up to ~Unity 2022 LTS) |
| **Risk for Unity 6+** | HIGH -- major rebrand, API changes, DOTS production-ready |

### Post-Cutoff Key Changes

| Version | Key Changes |
|---------|------------|
| Unity 6.0 | Rebrand from "2023", Entities 1.3, new rendering features, DOTS improvements |
| Unity 6.1 | Bug fixes, stability improvements |
| Unity 6.2 | Performance optimizations, new Input System improvements |
| Unity 6.3 LTS | First LTS since 6.0, production-ready DOTS, enhanced graphics |

### Deprecated Systems

- **Legacy Input Manager**: Use new Input System package
- **Legacy Particle System**: Use Visual Effect Graph for new projects
- **UGUI**: Still supported, but UI Toolkit recommended for new projects
- **Old ECS (GameObjectEntity)**: Replaced by modern DOTS/Entities
- **Resources.Load**: Use Addressables for production

Official docs: https://docs.unity3d.com/6000.0/Documentation/Manual/index.html

---

## C# Coding Standards

### Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Classes | PascalCase | `PlayerController` |
| Public fields/properties | PascalCase | `MoveSpeed`, `MaxHealth` |
| Private fields | _camelCase | `_moveSpeed`, `_currentHealth` |
| Methods | PascalCase | `TakeDamage()`, `GetHealthPercent()` |
| Files | PascalCase matching class | `PlayerController.cs` |
| Constants | PascalCase or UPPER_SNAKE_CASE | `MaxPlayerCount` |
| Interfaces | I-prefixed PascalCase | `IDamageable`, `IInteractable` |
| Enums | PascalCase | `enum PlayerState { Idle, Running, Jumping }` |
| Events | PascalCase with On prefix | `OnHealthChanged`, `OnDied` |

### Code Organization

```csharp
public class PlayerController : MonoBehaviour
{
    // 1. Constants
    private const float GRAVITY = -9.81f;

    // 2. Serialized fields (designer-tunable)
    [Header("Movement")]
    [SerializeField] private float _moveSpeed = 5f;
    [SerializeField] private float _jumpForce = 10f;

    [Header("Combat")]
    [SerializeField] private int _maxHealth = 100;

    // 3. Public properties
    public int CurrentHealth => _currentHealth;
    public bool IsAlive => _currentHealth > 0;

    // 4. Events
    public event System.Action<int, int> OnHealthChanged;
    public event System.Action OnDied;

    // 5. Private fields
    private int _currentHealth;
    private Rigidbody _rb;

    // 6. Unity lifecycle (in execution order)
    private void Awake()
    {
        _rb = GetComponent<Rigidbody>();
    }

    private void Start()
    {
        _currentHealth = _maxHealth;
    }

    private void Update()
    {
        HandleInput();
    }

    private void FixedUpdate()
    {
        HandleMovement();
    }

    // 7. Public methods
    public void TakeDamage(int amount)
    {
        _currentHealth = Mathf.Max(_currentHealth - amount, 0);
        OnHealthChanged?.Invoke(_currentHealth, _maxHealth);
        if (_currentHealth <= 0)
        {
            OnDied?.Invoke();
        }
    }

    // 8. Private methods
    private void HandleInput() { /* ... */ }
    private void HandleMovement() { /* ... */ }
}
```

---

## ScriptableObject Data Separation

Separate data from behavior. Use ScriptableObjects for all game data:

```csharp
[CreateAssetMenu(fileName = "NewWeapon", menuName = "Game/Weapon Data")]
public class WeaponData : ScriptableObject
{
    [Header("Identity")]
    public string WeaponName;
    public Sprite Icon;

    [Header("Combat Stats")]
    public int BaseDamage = 10;
    public float AttackSpeed = 1f;
    public float Range = 2f;

    [Header("Effects")]
    public GameObject HitEffect;
    public AudioClip HitSound;
}

// Usage in MonoBehaviour
public class Weapon : MonoBehaviour
{
    [SerializeField] private WeaponData _data;

    public void Attack(IDamageable target)
    {
        target.TakeDamage(_data.BaseDamage);
    }
}
```

**Benefits**: Designers edit data in the Inspector without touching code. Multiple weapon instances share the same ScriptableObject. Changes propagate instantly.

---

## New Input System

Use the new Input System package (not the legacy `Input.GetKey` API):

```csharp
using UnityEngine.InputSystem;

public class PlayerInput : MonoBehaviour
{
    private PlayerInputActions _inputActions;

    private void Awake()
    {
        _inputActions = new PlayerInputActions();
    }

    private void OnEnable()
    {
        _inputActions.Gameplay.Enable();
        _inputActions.Gameplay.Jump.performed += OnJump;
        _inputActions.Gameplay.Attack.performed += OnAttack;
    }

    private void OnDisable()
    {
        _inputActions.Gameplay.Jump.performed -= OnJump;
        _inputActions.Gameplay.Attack.performed -= OnAttack;
        _inputActions.Gameplay.Disable();
    }

    private void Update()
    {
        Vector2 moveInput = _inputActions.Gameplay.Move.ReadValue<Vector2>();
        // Use moveInput for movement
    }

    private void OnJump(InputAction.CallbackContext context)
    {
        // Handle jump
    }

    private void OnAttack(InputAction.CallbackContext context)
    {
        // Handle attack
    }
}
```

---

## Addressables Over Resources.Load

Never use `Resources.Load()` in production. Use Addressables for async asset loading:

```csharp
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement.AsyncOperations;

public class AssetLoader : MonoBehaviour
{
    [SerializeField] private AssetReference _prefabReference;

    private AsyncOperationHandle<GameObject> _handle;

    public async void LoadAndInstantiate()
    {
        _handle = Addressables.InstantiateAsync(_prefabReference);
        await _handle.Task;

        if (_handle.Status == AsyncOperationStatus.Succeeded)
        {
            // Instance is ready
            GameObject instance = _handle.Result;
        }
    }

    private void OnDestroy()
    {
        if (_handle.IsValid())
        {
            Addressables.Release(_handle);
        }
    }
}
```

**Benefits**: Async loading prevents frame hitches, memory management is explicit, supports remote asset bundles and CDN delivery.

---

## NonAlloc Physics APIs

Always use NonAlloc versions of physics queries to avoid garbage collection:

```csharp
// BAD: Allocates garbage every call
Collider[] hits = Physics.OverlapSphere(position, radius);

// GOOD: Reuse buffer, no allocation
private readonly Collider[] _hitBuffer = new Collider[32];

private void DetectEnemies()
{
    int hitCount = Physics.OverlapSphereNonAlloc(
        transform.position,
        _detectionRadius,
        _hitBuffer,
        _enemyLayerMask
    );

    for (int i = 0; i < hitCount; i++)
    {
        // Process _hitBuffer[i]
    }
}

// Also use NonAlloc for raycasts
private readonly RaycastHit[] _rayBuffer = new RaycastHit[16];

private void Raycast()
{
    int hits = Physics.RaycastNonAlloc(
        transform.position,
        transform.forward,
        _rayBuffer,
        _maxDistance,
        _layerMask
    );
}
```

---

## SRP (Scriptable Render Pipeline) Patterns

### URP (Universal Render Pipeline)

- Default for most projects (mobile, VR, mid-range PC)
- Use URP-compatible shaders (Lit, Unlit, Simple Lit)
- Configure rendering features via URP Asset
- Post-processing via Volume framework

### HDRP (High Definition Render Pipeline)

- For high-end visuals (PC, console)
- Physically-based lighting and materials
- Ray tracing support
- More complex setup but higher visual ceiling

### General SRP Rules

- Never use Legacy/Built-in shaders in SRP projects
- Use Shader Graph for custom shaders (visual shader editor)
- Configure quality settings per platform
- Use LOD Groups for 3D object optimization

---

## ECS/DOTS (When Applicable)

Use DOTS/ECS for performance-critical systems with thousands of entities (simulation, particle-like systems, large-scale AI). For most gameplay code, MonoBehaviour is fine.

```csharp
// Component (data only)
public struct Health : IComponentData
{
    public int Value;
    public int Max;
}

// System (logic only)
[BurstCompile]
public partial struct DamageSystem : ISystem
{
    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        foreach (var (health, entity) in
            SystemAPI.Query<RefRW<Health>>().WithEntityAccess())
        {
            // Process health
        }
    }
}
```

**When to use DOTS**: 10,000+ entities, simulation-heavy, CPU-bound. **When NOT to use DOTS**: UI, menus, narrative, small entity counts, rapid prototyping.

---

## Common Patterns

### Object Pooling

```csharp
public class ObjectPool<T> where T : MonoBehaviour
{
    private readonly T _prefab;
    private readonly Transform _parent;
    private readonly Queue<T> _pool = new Queue<T>();

    public ObjectPool(T prefab, int initialSize, Transform parent = null)
    {
        _prefab = prefab;
        _parent = parent;

        for (int i = 0; i < initialSize; i++)
        {
            T obj = Object.Instantiate(_prefab, _parent);
            obj.gameObject.SetActive(false);
            _pool.Enqueue(obj);
        }
    }

    public T Get()
    {
        T obj = _pool.Count > 0
            ? _pool.Dequeue()
            : Object.Instantiate(_prefab, _parent);
        obj.gameObject.SetActive(true);
        return obj;
    }

    public void Release(T obj)
    {
        obj.gameObject.SetActive(false);
        _pool.Enqueue(obj);
    }
}
```

### Event System (Decoupled Communication)

```csharp
// Static event bus for global game events
public static class GameEvents
{
    public static event System.Action<int, int> OnPlayerHealthChanged;
    public static event System.Action OnPlayerDied;
    public static event System.Action<int> OnScoreChanged;

    public static void PlayerHealthChanged(int current, int max)
        => OnPlayerHealthChanged?.Invoke(current, max);

    public static void PlayerDied()
        => OnPlayerDied?.Invoke();

    public static void ScoreChanged(int newScore)
        => OnScoreChanged?.Invoke(newScore);
}
```

### State Machine

```csharp
public interface IState
{
    void Enter();
    void Update(float deltaTime);
    void FixedUpdate(float deltaTime);
    void Exit();
}

public class StateMachine
{
    private IState _currentState;

    public void TransitionTo(IState newState)
    {
        _currentState?.Exit();
        _currentState = newState;
        _currentState.Enter();
    }

    public void Update(float deltaTime) => _currentState?.Update(deltaTime);
    public void FixedUpdate(float deltaTime) => _currentState?.FixedUpdate(deltaTime);
}
```

---

## Testing (Unity Test Framework)

Use Unity Test Framework (based on NUnit) for Edit Mode and Play Mode tests:

```csharp
using NUnit.Framework;

[TestFixture]
public class HealthTests
{
    [Test]
    public void TakeDamage_ReducesHealth()
    {
        var health = new HealthData { Current = 100, Max = 100 };
        health.Current -= 30;
        Assert.AreEqual(70, health.Current);
    }

    [Test]
    public void Health_CannotGoBelowZero()
    {
        var health = new HealthData { Current = 50, Max = 100 };
        health.Current = Mathf.Max(health.Current - 100, 0);
        Assert.AreEqual(0, health.Current);
    }

    [Test]
    public void DamageFormula_ClampsModifiers()
    {
        float result = DamageCalculator.Calculate(
            baseDamage: 10,
            modifierSum: -2.0f  // Should clamp to -0.9
        );
        Assert.Greater(result, 0f);
    }
}
```

### Play Mode Tests

```csharp
using System.Collections;
using NUnit.Framework;
using UnityEngine.TestTools;

public class PlayerPlayModeTests
{
    [UnityTest]
    public IEnumerator Player_TakesDamage_HealthBarUpdates()
    {
        // Setup scene
        var player = new GameObject().AddComponent<PlayerHealth>();
        player.Initialize(100);

        yield return null; // Wait one frame

        player.TakeDamage(25);

        yield return null;

        Assert.AreEqual(75, player.CurrentHealth);
    }
}
```

### Testing Best Practices

- Separate pure logic from MonoBehaviour for testability
- Use dependency injection (constructor or method injection) over singletons
- Test formulas, state transitions, and edge cases in Edit Mode tests
- Test integration and gameplay flow in Play Mode tests
- Run tests in CI before merge
