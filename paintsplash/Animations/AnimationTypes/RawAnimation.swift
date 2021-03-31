//
//  RawAnimation.swift
//  paintsplash
//
//  Created by Farrell Nah on 31/3/21.
//
//import SpriteKit
//
//class RawAnimation: Animation {
//    var action: SKAction
//
//    init(name: String, animationDuration: Double, action: SKAction) {
//        self.action = action
//        super.init(name: name, animationDuration: animationDuration)
//    }
//
//    private enum CodingKeys: String, CodingKey {
//        case action
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.action = try container.decode(SKAction.self, forKey: .action)
//        try super.init(from: container.superDecoder())
//    }
//
//    override func getAction() -> SKAction {
//        action
//    }
//}
