//
//  SystemData.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

struct SystemData: Codable {
    let entityData: EntityData
    let renderSystemData: RenderSystemData
    let animationSystemData: AnimationSystemData
    let colorSystemData: ColorSystemData
}
