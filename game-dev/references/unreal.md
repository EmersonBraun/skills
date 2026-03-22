# Unreal Engine 5 Reference

Engine-specific patterns, coding standards, and best practices for UE5 (C++ and Blueprint).

---

## Version Awareness

| Field | Value |
|-------|-------|
| **Current Version** | UE 5.7 (November 2025) |
| **LLM Knowledge Cutoff** | ~May 2025 (covers up to ~UE 5.3) |
| **Risk for 5.4+** | HIGH -- Megalights, Substrate, PCG production-ready |

### Post-Cutoff Key Changes

| Version | Key Changes |
|---------|------------|
| 5.4 | Motion Design tools, animation improvements, PCG enhancements |
| 5.5 | Megalights (millions of lights), animation authoring, MegaCity demo |
| 5.6 | Performance optimizations, bug fixes |
| 5.7 | PCG production-ready, Substrate production-ready, AI assistant |

### Deprecated Systems

- **Legacy Material System**: Migrate to Substrate for new projects
- **Old PCG API**: Use new production-ready PCG API (5.7+)

Official docs: https://docs.unrealengine.com/5.7/

---

## C++ Coding Standards

### Naming Conventions (Unreal Coding Standard)

| Element | Convention | Example |
|---------|-----------|---------|
| Actor classes | A-prefix PascalCase | `APlayerCharacter` |
| UObject classes | U-prefix PascalCase | `UHealthComponent` |
| Structs | F-prefix PascalCase | `FDamageInfo` |
| Enums | E-prefix PascalCase | `EPlayerState` |
| Interfaces | I-prefix PascalCase (with U-prefix class) | `IInteractable` / `UInteractableInterface` |
| Booleans | b-prefix PascalCase | `bIsAlive`, `bCanJump` |
| Variables | PascalCase | `MoveSpeed`, `CurrentHealth` |
| Functions | PascalCase | `TakeDamage()`, `GetHealthPercent()` |
| Files | Match class without prefix | `PlayerCharacter.h` / `.cpp` |
| Delegates | F-prefix + OnXxx | `FOnHealthChanged` |

### Header Organization

```cpp
// PlayerCharacter.h
#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Character.h"
#include "AbilitySystemInterface.h"
#include "PlayerCharacter.generated.h"

DECLARE_DYNAMIC_MULTICAST_DELEGATE_TwoParams(
    FOnHealthChanged, float, NewHealth, float, MaxHealth);

UCLASS()
class MYGAME_API APlayerCharacter : public ACharacter,
    public IAbilitySystemInterface
{
    GENERATED_BODY()

public:
    APlayerCharacter();

    // Public API
    UFUNCTION(BlueprintCallable, Category = "Combat")
    void TakeDamage(float Amount);

    UPROPERTY(BlueprintAssignable, Category = "Events")
    FOnHealthChanged OnHealthChanged;

protected:
    virtual void BeginPlay() override;
    virtual void Tick(float DeltaTime) override;

    // Components
    UPROPERTY(VisibleAnywhere, BlueprintReadOnly, Category = "Components")
    TObjectPtr<UHealthComponent> HealthComponent;

private:
    // Internal state
    UPROPERTY()
    float InternalCooldown;

    void HandleDeath();
};
```

---

## GAS (Gameplay Ability System)

GAS is the recommended framework for abilities, effects, and attributes in UE5.

### Core Concepts

| Concept | Purpose | Example |
|---------|---------|---------|
| **Ability System Component** | Central hub that owns abilities and attributes | Attached to character |
| **Gameplay Ability** | An action the character can perform | Fireball, Dash, Block |
| **Gameplay Effect** | Modifies attributes (instant, duration, infinite) | Damage, Heal, Buff |
| **Attribute Set** | Container for numeric attributes | Health, Mana, Strength |
| **Gameplay Tags** | Hierarchical labels for state and conditions | `State.Dead`, `Ability.Cooldown` |
| **Gameplay Cue** | Visual/audio feedback for effects | Hit VFX, heal particles |

### Attribute Set Pattern

```cpp
UCLASS()
class UMyAttributeSet : public UAttributeSet
{
    GENERATED_BODY()

public:
    UPROPERTY(BlueprintReadOnly, ReplicatedUsing = OnRep_Health)
    FGameplayAttributeData Health;
    ATTRIBUTE_ACCESSORS(UMyAttributeSet, Health)

    UPROPERTY(BlueprintReadOnly, ReplicatedUsing = OnRep_MaxHealth)
    FGameplayAttributeData MaxHealth;
    ATTRIBUTE_ACCESSORS(UMyAttributeSet, MaxHealth)

    virtual void PreAttributeChange(
        const FGameplayAttribute& Attribute, float& NewValue) override;
    virtual void PostGameplayEffectExecute(
        const FGameplayEffectModCallbackData& Data) override;
};
```

### GAS Best Practices

- Use Gameplay Tags extensively for state management (not booleans)
- Create Gameplay Effects in Blueprints (data-driven, designer-friendly)
- Implement Gameplay Abilities in C++ for complex logic, Blueprint for simple ones
- Use `WaitTargetData` tasks for targeting
- Always handle prediction for multiplayer
- Use Gameplay Cues for all VFX/SFX (decoupled from gameplay logic)

---

## Blueprint/C++ Boundary Discipline

### The Rule

Blueprint for data, iteration, and prototyping. C++ for performance, systems, and logic.

| Use Blueprint For | Use C++ For |
|-------------------|-------------|
| Configuring data (enemy stats, level layouts) | Core gameplay systems (movement, combat) |
| UI layout and binding | Performance-critical code (AI, physics queries) |
| Quick prototyping and iteration | Complex algorithms and math |
| Animation state machines | Networking and replication |
| Level scripting and triggers | Base classes and interfaces |
| Gameplay Effect configurations | Subsystems and managers |

### Exposing C++ to Blueprint

```cpp
// Make a function callable from Blueprint
UFUNCTION(BlueprintCallable, Category = "Combat")
void TakeDamage(float Amount);

// Make a function overridable in Blueprint
UFUNCTION(BlueprintNativeEvent, Category = "Combat")
void OnDeath();
void OnDeath_Implementation();

// Make a property visible and editable in Blueprint
UPROPERTY(EditAnywhere, BlueprintReadWrite, Category = "Stats")
float MoveSpeed = 600.f;
```

### Anti-Patterns

- Do NOT implement complex loops or math in Blueprint (performance)
- Do NOT hardcode values in C++ that designers need to tune (use UPROPERTY)
- Do NOT mix replication logic with gameplay logic
- Do NOT use Cast<> in Blueprint on every tick (cache references)

---

## Replication and Netcode

### Replication Basics

```cpp
// Replicated property
UPROPERTY(ReplicatedUsing = OnRep_Health)
float Health;

UFUNCTION()
void OnRep_Health();

virtual void GetLifetimeReplicatedProps(
    TArray<FLifetimeProperty>& OutLifetimeProps) const override
{
    Super::GetLifetimeReplicatedProps(OutLifetimeProps);
    DOREPLIFETIME_CONDITION(AMyCharacter, Health, COND_OwnerOnly);
}
```

### RPC Patterns

```cpp
// Server RPC (client calls, server executes)
UFUNCTION(Server, Reliable)
void ServerRequestAttack(FVector TargetLocation);

// Client RPC (server calls, client executes)
UFUNCTION(Client, Reliable)
void ClientPlayHitEffect(FVector HitLocation);

// Multicast RPC (server calls, all clients execute)
UFUNCTION(NetMulticast, Unreliable)
void MulticastPlaySound(USoundBase* Sound);
```

### Netcode Best Practices

- Server is authoritative for all gameplay state
- Use `COND_OwnerOnly` to reduce bandwidth for player-specific data
- Use unreliable RPCs for cosmetic effects (VFX, SFX)
- Use reliable RPCs only when data MUST arrive (damage, death, state changes)
- Implement client-side prediction for responsive movement
- Use relevancy and net dormancy to reduce server load

---

## UMG/CommonUI Patterns

### Widget Hierarchy

```
HUD (UCommonActivatableWidget)
  HealthBar (UCommonUserWidget)
  AbilityBar (UCommonUserWidget)
  Minimap (UCommonUserWidget)

MenuStack (UCommonActivatableWidgetContainerBase)
  MainMenu (UCommonActivatableWidget)
  SettingsMenu (UCommonActivatableWidget)
  PauseMenu (UCommonActivatableWidget)
```

### CommonUI Benefits

- Input routing (gamepad, keyboard, mouse) handled automatically
- Widget activation/deactivation stack management
- Platform-specific input icons
- Focus management for accessibility

### Data Binding Pattern

- Create a ViewModel (UObject) that owns the data
- Widget binds to ViewModel properties
- ViewModel updates trigger widget refresh
- Separation of UI presentation from game logic

---

## Enhanced Input System

```cpp
// Input Action (created as asset in editor)
UPROPERTY(EditAnywhere, Category = "Input")
TObjectPtr<UInputAction> MoveAction;

UPROPERTY(EditAnywhere, Category = "Input")
TObjectPtr<UInputAction> JumpAction;

UPROPERTY(EditAnywhere, Category = "Input")
TObjectPtr<UInputMappingContext> DefaultMappingContext;

void AMyCharacter::SetupPlayerInputComponent(
    UInputComponent* PlayerInputComponent)
{
    auto* EIC = CastChecked<UEnhancedInputComponent>(PlayerInputComponent);
    EIC->BindAction(MoveAction, ETriggerEvent::Triggered, this,
        &AMyCharacter::OnMove);
    EIC->BindAction(JumpAction, ETriggerEvent::Started, this,
        &AMyCharacter::OnJump);
}

void AMyCharacter::OnMove(const FInputActionValue& Value)
{
    FVector2D MoveInput = Value.Get<FVector2D>();
    // Apply movement
}
```

---

## Data-Driven Design

### DataAssets

```cpp
UCLASS()
class UWeaponDataAsset : public UPrimaryDataAsset
{
    GENERATED_BODY()

public:
    UPROPERTY(EditDefaultsOnly, Category = "Weapon")
    FName WeaponName;

    UPROPERTY(EditDefaultsOnly, Category = "Stats")
    float BaseDamage = 10.f;

    UPROPERTY(EditDefaultsOnly, Category = "Stats")
    float AttackRate = 1.f;

    UPROPERTY(EditDefaultsOnly, Category = "VFX")
    TObjectPtr<UNiagaraSystem> HitEffect;
};
```

### DataTables

Use DataTables for tabular data (loot tables, enemy configurations, level data):
- Define a row struct in C++
- Create and populate DataTable in editor (or import from CSV)
- Query at runtime with `FindRow<>()`

---

## Common Patterns

### Subsystems

Use Subsystems for singleton-like managers that follow UE lifecycle:

```cpp
UCLASS()
class UInventorySubsystem : public UGameInstanceSubsystem
{
    GENERATED_BODY()

public:
    virtual void Initialize(FSubsystemCollectionBase& Collection) override;

    UFUNCTION(BlueprintCallable)
    void AddItem(FName ItemId, int32 Count);
};

// Access from anywhere
UInventorySubsystem* Inventory =
    GetGameInstance()->GetSubsystem<UInventorySubsystem>();
```

### Game Features and Modular Gameplay

Use Game Feature plugins for modular content:
- Each gameplay feature (combat, crafting, vehicles) is a separate plugin
- Features can be loaded/unloaded at runtime
- Clean dependency management
- Supports modding and DLC

---

## Testing in UE5

### Automation Testing Framework

```cpp
IMPLEMENT_SIMPLE_AUTOMATION_TEST(
    FHealthTest,
    "Game.Combat.Health.TakeDamage",
    EAutomationTestFlags::EditorContext |
    EAutomationTestFlags::ProductFilter)

bool FHealthTest::RunTest(const FString& Parameters)
{
    // Arrange
    UHealthComponent* Health = NewObject<UHealthComponent>();
    Health->Initialize(100.f);

    // Act
    Health->TakeDamage(30.f);

    // Assert
    TestEqual("Health reduced", Health->GetCurrentHealth(), 70.f);

    return true;
}
```

### Functional Tests

```cpp
IMPLEMENT_SIMPLE_AUTOMATION_TEST(
    FHealthCannotGoBelowZero,
    "Game.Combat.Health.FloorAtZero",
    EAutomationTestFlags::EditorContext |
    EAutomationTestFlags::ProductFilter)

bool FHealthCannotGoBelowZero::RunTest(const FString& Parameters)
{
    UHealthComponent* Health = NewObject<UHealthComponent>();
    Health->Initialize(50.f);
    Health->TakeDamage(100.f);
    TestEqual("Health floors at zero", Health->GetCurrentHealth(), 0.f);
    return true;
}
```

### Testing Best Practices

- Use `EAutomationTestFlags::ProductFilter` for tests that must pass before shipping
- Test GAS abilities with mock Ability System Components
- Test replication with `FAutomationTestWorld` and simulated net drivers
- Keep tests fast (no long waits, mock external dependencies)
- Run automation tests in CI as part of build verification
