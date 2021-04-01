//
//  MovementBounds.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//

struct Rect: Codable {
    var minX: Double
    var maxX: Double
    var minY: Double
    var maxY: Double

    init(minX: Double = -Double.greatestFiniteMagnitude,
         maxX: Double = Double.greatestFiniteMagnitude,
         minY: Double = -Double.greatestFiniteMagnitude,
         maxY: Double = Double.greatestFiniteMagnitude) {

        self.minX = minX
        self.maxX = maxX
        self.minY = minY
        self.maxY = maxY
    }

    func contains(_ point: Vector2D) -> Bool {
        point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY
    }

    func inset(by inset: Vector2D) -> Rect {
        Rect(minX: self.minX + inset.x, maxX: self.maxX - inset.x, minY: self.minY + inset.y, maxY: self.maxY - inset.y)
    }

    func clamp(point: Vector2D) -> Vector2D {
        var clampedX = point.x
        var clampedY = point.y

        if point.x > maxX {
            clampedX = maxX
        } else if point.x < minX {
            clampedX = minX
        }

        if point.y > maxY {
            clampedY = maxY
        } else if point.y < minY {
            clampedY = minY
        }

        return Vector2D(clampedX, clampedY)
    }
}
