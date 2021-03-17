//
//  AIEntity.swift
//  paintsplash
//
//  Created by Farrell Nah on 10/3/21.
//

class AIEntity: InteractiveEntity, Movable {

    var velocity: Vector2D

    var acceleration: Vector2D

    var defaultSpeed: Double = 0.0

    var currentBehaviour: AIBehaviour = ApproachPointBehaviour()

    weak var delegate: AIEntityDelegate?

    var state: AIEntityState = .idle {
        didSet {
            if oldValue == state {
                return
            }
            // Update animation since state has changed
            self.delegate?.didEntityUpdateState(aiEntity: self)
        }
    }

    init(initialPosition: Vector2D, initialVelocity: Vector2D, radius: Double, spriteName: String) {
        self.velocity = initialVelocity
        self.acceleration = Vector2D.zero

        var transform = Transform.identity
        transform.position = initialPosition

        super.init(spriteName: spriteName, colliderShape: .enemy(radius: radius), tags: .enemy, transform: transform)
    }

    func changeBehaviour(to behaviour: AIBehaviour) {
        self.currentBehaviour = behaviour
    }

    func updateAI(aiGameInfo: AIGameInfo) {
        currentBehaviour.updateAI(aiEntity: self, aiGameInfo: aiGameInfo)
    }

    func getAnimationFromState() -> Animation {
        switch self.state {
        case .idle:
            return SlimeAnimations.slimeIdleGray
        case .moveLeft:
            return SlimeAnimations.slimeMoveLeftGray
        case .moveRight:
            return SlimeAnimations.slimeMoveRightGray
        case .hit:
            return SlimeAnimations.slimeHitGray
        case .afterHit:
            return SlimeAnimations.slimeHitGray
        case .die:
            return SlimeAnimations.slimeDieGray
        default:
            return SlimeAnimations.slimeIdleGray
        }
    }
}
