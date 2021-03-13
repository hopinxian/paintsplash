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

    func getContactBitMask() -> UInt32 {
        return UInt32.max
    }
}

struct Tags {
    let tags: Set<Tag>

    init(tags: Tag...) {
        self.tags = Set(tags)
    }

    init(tags: Set<Tag>) {
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
