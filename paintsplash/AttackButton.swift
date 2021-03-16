//
//  AttackButton.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

class AttackButton: GameEntity, Renderable {
    var zPosition: Int

    var renderColor: PaintColor?

    var spriteName: String

    var currentAnimation: Animation?

    var transform: Transform

    private let diameter: Double = 100
    private var tracking = false
    private var radius: Double {
        diameter / 2
    }

    init(position: Vector2D) {
        renderColor = nil
        spriteName = "joystick-background"
        currentAnimation = nil
        transform = Transform.identity
        transform.position = position
        zPosition = 0

        super.init()

        EventSystem.inputEvents.subscribe(listener: onTouch)
    }

    override func spawn(gameManager: GameManager) {
        gameManager.getRenderSystem().addRenderable(self)
        super.spawn(gameManager: gameManager)
    }

    override func update(gameManager: GameManager) {
        gameManager.getRenderSystem().updateRenderable(self)
        super.update(gameManager: gameManager)
    }

    func onTouch(inputEvent: TouchInputEvent) {
        switch inputEvent.inputState {
        case .touchDown(let location):
            onTouchDown(location: location)
        case .touchUp(let location):
            onTouchUp(location: location)
        default:
            break
        }
    }

    func onTouchDown(location: Vector2D) {
        if Vector2D.magnitude(of: location - transform.position) < radius {
            tracking = true
        }
    }

    func onTouchUp(location: Vector2D) {
        guard tracking else {
            return
        }

        tracking = false
        print("SHOOT")
        let event = PlayerActionEvent(playerActionEventType: .attack)
        EventSystem.playerActionEvent.post(event: event)
    }
}
