//
//  RenderComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 20/3/21.
//

class Component {
    private weak var _entity: GameEntity?
    var entity: GameEntity {
        get {
            guard let nonNullEntity = _entity else {
                fatalError("Component not setup correctly")
            }

            return nonNullEntity
        }

        set {
            _entity = newValue
        }
    }

    private var requiredComponents = [Component]()

    func getRequirements<T: Component>() -> [T.Type] {
        []
    }

    func getRequiredComponent<T: Component>(componentType: T.Type) -> T {
        guard getRequirements().contains(where: { $0 == componentType }) else {
            fatalError("Tried to get a non required component")
        }

        // Force cast is ok here because the component requirement has already been confirmed
        return requiredComponents.compactMap({ $0 as? T }).first!
    }

    func setRequiredComponent(_ requiredComponent: Component) {
        guard getRequirements().contains(where: { $0 == type(of: requiredComponent) }) else {
            fatalError("Tried to set a non required component as required")
        }

        requiredComponents.append(requiredComponent)
    }
}

class TransformComponent: Component {
    var position: Vector2D
    var rotation: Double
    var size: Vector2D

    init(position: Vector2D, rotation: Double, size: Vector2D) {
        self.position = position
        self.rotation = rotation
        self.size = size
    }
}

class RenderComponent: Component {
    var spriteName: String
    var defaultAnimation: Animation?
    var zPosition: Int

    init(spriteName: String, defaultAnimation: Animation? = nil, zPosition: Int) {
        self.spriteName = spriteName
        self.defaultAnimation = defaultAnimation
        self.zPosition = zPosition
    }
}

class AnimationComponent: Component {
    var currentAnimation: Animation?
    var animationToPlay: Animation?


    func animate(animation: Animation, interupt: Bool) {
        if !currentAnimation.active || interupt {
            animationToPlay = animation
        }
    }

    func animate(animation: Animation, interupt: Bool, callBack: (() -> Void)?) {

    }
}

class CollisionComponent: Component {
    var colliderShape: ColliderShape
    var tags: Tags
    var onCollide: (CollisionComponent) -> Void

    init(colliderShape: ColliderShape, tags: [Tag], onCollide: @escaping (CollisionComponent) -> Void) {
        self.colliderShape = colliderShape
        self.tags = Tags(Set(tags))
        self.onCollide = onCollide
    }
//    func onCollide(otherObject: Collidable) {
//
//    }
}

class HealthComponent: Component {
    var currentHealth: Int
    var maxHealth: Int

    init(currentHealth: Int, maxHealth: Int) {
        self.currentHealth = currentHealth
        self.maxHealth = maxHealth
    }

    func heal(amount: Int) {
        currentHealth += amount
        if currentHealth > maxHealth {
            currentHealth = maxHealth
        }
    }

    func takeDamage(amount: Int) {
        currentHealth -= amount
        if currentHealth < 0 {
            currentHealth = 0
        }
    }
}

class MoveableComponent: Component {
    var velocity: Vector2D
    var acceleration: Vector2D
    var defaultSpeed: Double

    init(velocity: Vector2D, acceleration: Vector2D, defaultSpeed: Double) {
        self.velocity = velocity
        self.acceleration = acceleration
        self.defaultSpeed = defaultSpeed
    }

    func move() {

    }
}

class MultiWeaponComponent: Component {
    var activeWeapon: Weapon?
    var availableWeapons: [Weapon]

    init(weapons: [Weapon]) {
        self.activeWeapon = weapons[0]
        self.availableWeapons = weapons
    }

//    var carriedBy: Transformable? { get set }
//    func load(_ ammo: [Ammo]) {
//    func load<T: Weapon>(to weaponType: T.Type, ammo: [Ammo])
//    func shoot(in direction: Vector2D) -> Bool
//    func switchWeapon<T: Weapon>(to weapon: T.Type)
//    func getAmmo() -> [(Weapon, [Ammo])]
//    func canLoad(_ ammo: [Ammo]) -> Bool
}

class AIComponent: Component {
    var behaviour: AIBehaviour
    var state: AIState

    init(behaviour: AIBehaviour) {
        self.behaviour = behaviour
    }
}

class ColorComponent: Component {
    var color: PaintColor

    init(color: PaintColor) {
        self.color = color
    }
}
