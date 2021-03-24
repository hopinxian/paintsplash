//
//  Vector2D.swift
//  paintsplash
//
//  Created by Farrell Nah on 8/3/21.
//
//  swiftlint:disable identifier_name
//  swiftlint:disable shorthand_operator

import Foundation

struct Vector2D {
    let x: Double
    let y: Double

    var magnitude: Double {
        Vector2D.distanceBetween(self, Vector2D.zero)
    }

    var unitVector: Vector2D {
        self / magnitude
    }

    static let zero = Vector2D(0, 0)
    static let right = Vector2D(1, 0)
    static let left = Vector2D(-1, 0)
    static let up = Vector2D(0, 1)
    static let down = Vector2D(0, -1)

    init(_ x: Int, _ y: Int) {
        self.x = Double(x)
        self.y = Double(y)
    }

    init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }

    static func + (_ vectorA: Vector2D, _ vectorB: Vector2D) -> Vector2D {
        Vector2D(vectorA.x + vectorB.x, vectorA.y + vectorB.y)
    }

    static func += (left: inout Vector2D, right: Vector2D) {
        left = left + right
    }

    static func - (_ vectorA: Vector2D, _ vectorB: Vector2D) -> Vector2D {
        Vector2D(vectorA.x - vectorB.x, vectorA.y - vectorB.y)
    }

    static func -= (left: inout Vector2D, right: Vector2D) {
        left = left - right
    }

    static prefix func - (_ vector: Vector2D) -> Vector2D {
        Vector2D(-vector.x, -vector.y)
    }

    static func * (_ vector: Vector2D, _ amount: Double) -> Vector2D {
        Vector2D(vector.x * amount, vector.y * amount)
    }

    static func *= (left: inout Vector2D, right: Double) {
        left = left * right
    }

    static func / (_ vector: Vector2D, _ amount: Double) -> Vector2D {
        Vector2D(vector.x / amount, vector.y / amount)
    }

    static func /= (left: inout Vector2D, right: Double) {
        left = left / right
    }

    static func += (left: inout Vector2D, right: Double) {
        left = left / right
    }

    static func magnitude(of vector: Vector2D) -> Double {
        Vector2D.distanceBetween(vector, Vector2D.zero)
    }

    static func distanceBetween(_ vectorA: Vector2D, _ vectorB: Vector2D) -> Double {
        let xDistance = abs(vectorA.x - vectorB.x)
        let yDistance = abs(vectorA.y - vectorB.y)
        return Double(sqrt(Double((xDistance * xDistance) + (yDistance * yDistance))))
    }

    static func sqDistanceBetween(_ vectorA: Vector2D, _ vectorB: Vector2D) -> Double {
        let xDistance = abs(vectorA.x - vectorB.x)
        let yDistance = abs(vectorA.y - vectorB.y)
        return (xDistance * xDistance) + (yDistance * yDistance)
    }

    static func normalize(_ vector: Vector2D) -> Vector2D {
        let magnitude = distanceBetween(vector, Vector2D.zero)
        if magnitude == 0 {
            return Vector2D.zero
        }
        return vector / magnitude
    }

    static func reflect(_ vector: Vector2D, along normal: Vector2D) -> Vector2D {
        let normVector = normalize(vector)
        let normNormal = normalize(normal)
        return normVector - (normNormal * 2.0 * dot(normVector, normNormal))
    }

    /// Calculates the acute angle in radians between vector1 and vector2 using the cosine rule.
    static func angleBetween(_ vector1: Vector2D, _ vector2: Vector2D) -> Double {
        let a = magnitude(of: vector1)
        let b = magnitude(of: vector2)
        let c = magnitude(of: (vector2 - vector1))
        let cosine = (a * a + b * b - c * c) / (2 * a * b)
        return acos(cosine)
    }

    static func angleOf(_ vector: Vector2D) -> Double {
        guard vector.y != 0 else {
            return Double.pi / 2
        }

        return atan(vector.x / vector.y)
    }

    static func dot(_ vector1: Vector2D, _ vector2: Vector2D) -> Double {
        vector1.x * vector2.x + vector1.y * vector2.y
    }

    static func tripleProduct(_ vector1: Vector2D, _ vector2: Vector2D, _ vector3: Vector2D) -> Vector2D {
        (vector2 * dot(vector3, vector1)) - (vector1 * dot(vector3, vector2))

    }

    static func rotatePoint(_ target: Vector2D, around origin: Vector2D, byRadians: Double) -> Vector2D {
        let dx = target.x - origin.x
        let dy = target.y - origin.y

        let distance = sqrt(dx * dx + dy * dy)
        let newAngle = atan2(dy, dx) + byRadians

        let x = origin.x + distance * cos(newAngle)
        let y = origin.y + distance * sin(newAngle)

        return Vector2D(x, y)
    }

    static func clamped(vector: Vector2D, minX: Double?, maxX: Double?,
                        minY: Double?, maxY: Double?) -> Vector2D {
        var newX = vector.x
        var newY = vector.y

        newX = min(maxX ?? newX, newX)
        newX = max(minX ?? newX, newX)
        newY = min(maxY ?? newY, newY)
        newY = max(minY ?? newY, newY)

        return Vector2D(newX, newY)
    }
}

extension Vector2D: Hashable {
    static func == (lhs: Vector2D, rhs: Vector2D) -> Bool {
        fabs(lhs.x - rhs.x) < 0.000_000_1 && fabs(lhs.y - rhs.y) < 0.000_000_1
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension Vector2D: CustomStringConvertible {
    var description: String {
        "(\(x), \(y))"
    }
}
