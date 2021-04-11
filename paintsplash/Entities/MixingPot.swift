//
//  MixingPot.swift
//  paintsplash
//
//  Created by Farrell Nah on 11/4/21.
//

class MixingPot: GameEntity, Renderable, Transformable, Collidable, AmmoDrop, Colorable {
    var renderComponent: RenderComponent
    var transformComponent: TransformComponent
    var collisionComponent: CollisionComponent
    var color: PaintColor {
        get {
            _color ?? .white
        }
        set {
            _color = newValue
        }
    }
    private var _color: PaintColor?

    init(position: Vector2D) {
        self.renderComponent = RenderComponent(renderType: .sprite(spriteName: "WhiteSquare"), zPosition: Constants.ZPOSITION_UI_ELEMENT)

        self.transformComponent = TransformComponent(position: position, rotation: 0, size: Vector2D(100, 100))

        let collisionComponent = MixingPotCollisionComponent(colliderShape: .rectangle(size: transformComponent.size), tags: [])
        self.collisionComponent = collisionComponent

        super.init()

        collisionComponent.mixingPot = self
    }

    func addColor(_ color: PaintColor) {
        if _color == nil {
            _color = color
        } else {
            guard let newColor = _color?.mix(with: [color]) else {
                fatalError("Accepted invalid color")
            }

            _color = newColor
        }
    }

    func canMixWith(_ color: PaintColor) -> Bool {
        _color?.mix(with: [color]) != nil
    }

    func getAmmoObject() -> Ammo {
        guard let color = _color else {
            fatalError("Invalid Mixing Pot State")
        }
        _color = nil
        return PaintAmmo(color: color)
    }
}

class MixingPotCollisionComponent: CollisionComponent {
    weak var mixingPot: MixingPot?

    override func onCollide(with: Collidable) {
        if with.collisionComponent.tags.contains(.playerProjectile) {
            switch with {
            case let projectile as PaintProjectile:
                if mixingPot?.canMixWith(projectile.color) == true {
                    mixingPot?.addColor(projectile.color)
                }
            case let splash as PaintBucketSplash:
                if mixingPot?.canMixWith(splash.color) == true {
                    mixingPot?.addColor(splash.color)
                }
            default:
                fatalError("Player projectile does not conform to PlayerProjectile")
            }
        }
    }
}
