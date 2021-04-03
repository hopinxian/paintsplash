//
//  ColorSystemData.swift
//  paintsplash
//
//  Created by Farrell Nah on 3/4/21.
//

struct ColorSystemData: Codable {
    var colorables = [EntityID: EncodableColorable]()

    init(from colorables: [EntityID: Colorable]) {
        colorables.forEach({ entity, colorable in
            self.colorables[entity] = EncodableColorable(entityID: entity, color: colorable.color)
        })
    }
}
