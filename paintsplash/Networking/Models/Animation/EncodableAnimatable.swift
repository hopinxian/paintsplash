//
//  EncodableAnimatable.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

struct EncodableAnimatable: Codable {
    let entityID: EntityID
    let animationComponent: AnimationComponent
}
