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
        spriteName = "joystick-foreground"
        currentAnimation = nil
        transform = Transform.standard
        transform.position = position
        zPosition = 0

        super.init()

        EventSystem.inputEvents.touchDownEvent.subscribe(listener: onTouchDown)
        EventSystem.inputEvents.touchUpEvent.subscribe(listener: onTouchUp)
    }

    override func spawn(gameManager: GameManager) {
        gameManager.getRenderSystem().addRenderable(self)
        super.spawn(gameManager: gameManager)
    }

    override func update(gameManager: GameManager) {
        gameManager.getRenderSystem().updateRenderable(self)
        super.update(gameManager: gameManager)
    }

    func onTouchDown(event: TouchDownEvent) {
        if Vector2D.magnitude(of: event.location - transform.position) < radius {
            tracking = true
        }
    }

    func onTouchUp(event: TouchUpEvent) {
        guard tracking else {
            return
        }

        tracking = false
        print("SHOOT")
        let event = PlayerActionEvent(playerActionEventType: .attack)
        EventSystem.playerActionEvent.post(event: event)
    }
}