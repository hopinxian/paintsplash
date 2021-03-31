//
//  BoundedTransformComponent.swift
//  paintsplash
//
//  Created by Farrell Nah on 26/3/21.
//

class BoundedTransformComponent: TransformComponent {
    override var position: Vector2D {
        didSet {
            if !bounds.inset(by: size / 2).contains(position) {
                position = oldValue
            }
        }
    }

    var bounds: Rect

    init(position: Vector2D, rotation: Double, size: Vector2D, bounds: Rect) {
        self.bounds = bounds
        super.init(position: position, rotation: rotation, size: size)
    }

    private enum CodingKeys: String, CodingKey {
        case bounds
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.bounds = try container.decode(Rect.self, forKey: .bounds)
        try super.init(from: container.superDecoder())
    }
}
