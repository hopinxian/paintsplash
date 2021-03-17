//
//  LogicalToDisplayViewAdapter.swift
//  Peggle
//
//  Created by Praveen Bala on 28/2/21.
//

import CoreGraphics

struct LogicalToDisplayViewAdapter {
    var modelSize: Vector2D
    var screenSize: Vector2D

    init(modelSize: Vector2D, screenSize: Vector2D) {
        assert(modelSize.y > 0 && modelSize.x > 0, "Invalid logical dimensions")
        assert(screenSize.y > 0 && screenSize.x > 0, "Invalid desired dimensions")
        self.modelSize = modelSize
        self.screenSize = screenSize
    }

    var modelToScreen: Vector2D {
        let horizontalScaleFactor = screenSize.x / modelSize.x
        let verticalScaleFactor = screenSize.y / modelSize.y
        return Vector2D(horizontalScaleFactor, verticalScaleFactor)
    }

    var screenToModel: Vector2D {
        Vector2D(1 / modelToScreen.x, 1 / modelToScreen.y)
    }

    var sizeScaleToScreen: Double {
        min(modelToScreen.x, modelToScreen.y)
    }

    var sizeScaleToModel: Double {
        min(1 / modelToScreen.x, 1 / modelToScreen.y)
    }

    func modelPointToScreen(_ point: Vector2D) -> CGPoint {
        CGPoint(x: point.x * modelToScreen.x, y: point.y * modelToScreen.y)
    }

    func screenPointToModel(_ point: Vector2D) -> Vector2D {
        Vector2D(point.x * screenToModel.x, point.y * screenToModel.y)
    }

    func getHorizontalScale(width: Double) -> Double {
        width / modelSize.x
    }

    private func determineScale() -> Vector2D {
        let horizontalScaleFactor = screenSize.x / modelSize.x
        let verticalScaleFactor = screenSize.y / modelSize.y
        return Vector2D(horizontalScaleFactor, verticalScaleFactor)
    }
}
