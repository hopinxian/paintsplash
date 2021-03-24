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

    var active: Bool = true

    // Requirements should be defined on the system level

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

class BoundedTransformComponent: TransformComponent {
    override var position: Vector2D {
        willSet {
            print("willset")
            if !bounds.inset(by: size / 2).contains(newValue) {
                position = bounds.inset(by: size / 2).clamp(point: newValue)
            }
        }
    }

    var bounds: Rect

    init(position: Vector2D, rotation: Double, size: Vector2D, bounds: Rect) {
        self.bounds = bounds
        super.init(position: position, rotation: rotation, size: size)
    }
}

class RenderComponent: Component {
    var renderType: RenderType
    var zPosition: Int

    init(renderType: RenderType, zPosition: Int) {
        self.renderType = renderType
        self.zPosition = zPosition
    }
}

class AnimationComponent: Component {
    var currentAnimation: Animation?
    var animationToPlay: Animation?
    var animationIsPlaying: Bool = false

    func animate(animation: Animation, interupt: Bool) {
        animate(animation: animation, interupt: interupt, callBack: nil)
    }

    func animate(animation: Animation, interupt: Bool, callBack: (() -> Void)?) {
        if !animationIsPlaying || interupt {
            animationToPlay = CallbackAnimation(
                name: animation.name,
                animationDuration: animation.animationDuration,
                animation: animation,
                completionCallback: { [weak self] in
                    self?.animationIsPlaying = false
                    callBack?()
                }
            )
        }
    }
}

class CollisionComponent: Component {
    var colliderShape: ColliderShape
    var tags: Tags

    init(colliderShape: ColliderShape, tags: [Tag]) {
        self.colliderShape = colliderShape
        self.tags = Tags(Set(tags))
    }
}

class HealthComponent: Component {
    var currentHealth: Int {
        didSet {
            if currentHealth > maxHealth {
                currentHealth = maxHealth
            }

            if currentHealth < 0 {
                currentHealth = 0
            }
        }
    }

    var maxHealth: Int

    init(currentHealth: Int, maxHealth: Int) {
        self.currentHealth = currentHealth
        self.maxHealth = maxHealth
    }
}

class MoveableComponent: Component {
    var direction: Vector2D
    var acceleration: Vector2D
    var speed: Double

    init(direction: Vector2D, acceleration: Vector2D = Vector2D.zero, speed: Double) {
        self.direction = direction
        self.acceleration = acceleration
        self.speed = speed
    }
}

class MultiWeaponComponent: Component {
    var activeWeapon: Weapon?
    var availableWeapons: [Weapon]

    init(weapons: [Weapon]) {
        self.activeWeapon = weapons[0]
        self.availableWeapons = weapons
    }
}

class AIComponent: Component {
    var currentState: AIState
    var isStateLocked: Bool = false

    init(defaultState: AIState) {
        self.currentState = defaultState
    }

    func getCurrentBehaviour(aiEntity: AIEntity) -> AIBehaviour {
        currentState.getBehaviour(aiEntity: aiEntity)
    }

    func getNextState(aiEntity: AIEntity) -> AIState? {
        currentState.getStateTransition(aiEntity: aiEntity)
    }
}

class ColorComponent: Component {
    var color: PaintColor

    init(color: PaintColor) {
        self.color = color
    }
}
