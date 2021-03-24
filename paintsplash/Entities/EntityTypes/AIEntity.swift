////
////  AIEntity.swift
////  paintsplash
////
////  Created by Farrell Nah on 10/3/21.
////
//
//class AIEntity: InteractiveEntity, Movable {
//
//    var velocity: Vector2D
//
//    var acceleration: Vector2D
//
//    var defaultSpeed: Double = 0.0
//
//    var currentBehaviour: AIBehaviour = ApproachPointBehaviour()
//
//    weak var delegate: AIEntityDelegate?
//
//    var state: AIEntityState = .idle {
//        didSet {
//            if oldValue == state {
//                return
//            }
//            // Update animation since state has changed
//            self.delegate?.didEntityUpdateState(aiEntity: self)
//        }
//    }
//
//    init(spriteName: String, initialPosition: Vector2D, initialVelocity: Vector2D, radius: Double, tags: [Tag]) {
//        self.velocity = initialVelocity
//        self.acceleration = Vector2D.zero
//
//        var transform = Transform.standard
//        transform.position = initialPosition
//
//        let diameter = 2 * radius
//        transform.size = Vector2D(diameter, diameter)
//
//        super.init(spriteName: spriteName, colliderShape: .enemy(radius: radius), tags: tags, transform: transform)
//    }
//
//    init(spriteName: String, initialPosition: Vector2D,
//         initialVelocity: Vector2D, width: Double, height: Double, tags: [Tag]) {
//        self.velocity = initialVelocity
//        self.acceleration = Vector2D.zero
//
//        var transform = Transform.standard
//        transform.position = initialPosition
//        transform.size = Vector2D(width, height)
//
//        super.init(spriteName: spriteName, colliderShape: .rectEnemy(width: width, height: height),
//                   tags: tags, transform: transform)
//    }
//
//    func changeBehaviour(to behaviour: AIBehaviour) {
//        self.currentBehaviour = behaviour
//    }
//
//    func updateAI(aiGameInfo: AIGameInfo) {
//        currentBehaviour.updateAI(aiEntity: self, aiGameInfo: aiGameInfo)
//    }
//
//    func getAnimationFromState() -> Animation? {
//        nil
//    }
//}