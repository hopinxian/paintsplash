//
//  CollisionComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class CollisionComponent: Component {
    var colliderShape: ColliderShape
    var tags: Tags

    init(colliderShape: ColliderShape, tags: [Tag]) {
        self.colliderShape = colliderShape
        self.tags = Tags(Set(tags))
    }

    func onCollide(with: Collidable) {
        // do nothing by default
    }
}
