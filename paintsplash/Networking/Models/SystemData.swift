//
//  SystemData.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

import Foundation

struct SystemData: Codable {
    let date: Date
    let lastProcessedInput: InputId
    let entityData: EntityData
    let renderSystemData: RenderSystemData?
    let animationSystemData: AnimationSystemData?
    let colorSystemData: ColorSystemData?
}
