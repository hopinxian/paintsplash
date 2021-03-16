//
//  Player.swift
//  paintsplash
//
//  Created by Praveen Bala on 17/3/21.
//

class Player: InteractiveEntity, Movable, PlayableCharacter {
    var velocity: Vector2D
    var acceleration: Vector2D
    var defaultSpeed: Double = 1.0

    private var state: PlayerState = .idleLeft

    init(initialPosition: Vector2D, initialVelocity: Vector2D) {
        self.velocity = Vector2D.zero
        self.acceleration = Vector2D.zero

        var transform = Transform.identity
        transform.position = initialPosition

        super.init(spriteName: "", colliderShape: .circle(radius: 50), tags: .player, transform: transform)

        self.currentAnimation = PlayerAnimations.playerBrushIdleLeft

        EventSystem.processedInputEvent.subscribe(listener: onReceiveInput)
    }

    override func update(gameManager: GameManager) {
        move()
        setState()
        super.update(gameManager: gameManager)
    }

    func onReceiveInput(event: ProcessedInputEvent) {
        switch event.processedInputType {
        case .playerMovement(let direction):
            velocity = direction
            let event = PlayerActionEvent(playerActionEventType: .movement(location: position))
            EventSystem.playerActionEvent.post(event: event)
        default:
            break
        }
    }

    func setState() {
        switch (state, velocity) {
        case (.moveLeft, let velocity) where velocity.magnitude == 0:
            self.state = .idleLeft
            currentAnimation = PlayerAnimations.playerBrushIdleLeft
        case (.moveRight, let velocity) where velocity.magnitude == 0:
            self.state = .idleRight
            currentAnimation = PlayerAnimations.playerBrushIdleRight
        case (_, let velocity) where velocity.x < 0:
            self.state = .moveLeft
            currentAnimation = PlayerAnimations.playerBrushWalkLeft
        case (_, let velocity) where velocity.x > 0:
            self.state = .moveRight
            currentAnimation = PlayerAnimations.playerBrushWalkRight
        default:
            break
        }
    }
}
