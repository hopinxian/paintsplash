//
//  Tag.swift
//  paintsplash
//
//  Created by Farrell Nah on 12/3/21.
//

enum Tag: Int {
    case player
    case enemy
    case playerProjectile
    case canvas
    case ammoDrop
    case wall
}

struct Tags {
    let tags: Set<Tag>

    init() {
        self.tags = Set<Tag>()
    }

    init(_ tags: Tag...) {
        self.tags = Set(tags)
    }

    init(_ tags: Set<Tag>) {
        self.tags = tags
    }

    func getBitMask() -> UInt32 {
        var bitmask: UInt32 = 0
        for tag in tags {
            bitmask += 1 << tag.rawValue
        }

        return bitmask
    }

    func contains(_ tag: Tag) -> Bool {
        tags.contains(tag)
    }
}
