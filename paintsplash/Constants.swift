//
//  Constants.swift
//  paintsplash
//
//  Created by Praveen Bala on 20/3/21.
//  swiftlint:disable identifier_name

struct Constants {
    // Z Positions

    // Background
    static let ZPOSITION_FLOOR: Int = 0
    static let ZPOSITION_WALLS: Int = 1
    static let ZPOSITION_CANVAS = 1

    // Playfield
    static let ZPOSITION_PROJECTILE: Int = 0
    static let ZPOSITION_AMMO_DROP: Int = 0
    static let ZPOSITION_PLAYER: Int = 0
    static let POSITION_PLAYER = Vector2D(-250, 0)

    // UI
    static let ZPOSITION_JOYSTICK = 1
    static let ZPOSITION_AMMO_DISPLAY = 1
    static let ZPOSITION_HEALTH_DISPLAY = 1
    static let ZPOSITION_SCORE = 1
    static let ZPOSITION_REQUEST = 1

    // Movement Bounds
    static let PLAYER_MOVEMENT_BOUNDS = Rect(
        minX: -1_000,
        maxX: 1_000,
        minY: -400,
        maxY: 475
    )
    static let PROJECTILE_MOVEMENT_BOUNDS = Rect(
        minX: -1_000,
        maxX: 1_000,
        minY: -400,
        maxY: 1_000
    )

    // Gameplay
    static let CANVAS_MOVE_SPEED = 70.0
    static let PLAYER_MOVE_SPEED = 700.0
    static let ENEMY_MOVE_SPEED = 70.0
    static let PROJECTILE_MOVE_SPEED = 1_050.0
    static let ENEMY_SPAWNER_INTERVAL = 50.0

    // View Information
    static let ATTACK_BUTTON_SPRITE = "attack-button"
    static let ATTACK_BUTTON_POSITION = Vector2D(800, -600)
    static let ATTACK_BUTTON_SIZE = Vector2D(175, 175)

    static let JOYSTICK_SPRITE = "joystick-background"
    static let JOYSTICK_POSITION = Vector2D(-800, -600)
    static let JOYSTICK_SIZE = Vector2D(200, 200)

    static let TOP_BAR_SPRITE = "topwall"
    static let TOP_BAR_POSITION = Vector2D(0, 600)
    static let TOP_BAR_SIZE = Vector2D(2_000, 400)

    static let BOTTOM_BAR_SPRITE = "bottombar"
    static let BOTTOM_BAR_POSITION = Vector2D(0, -600)
    static let BOTTOM_BAR_SIZE = Vector2D(2_000, 400)

    static let PAINT_GUN_AMMO_DISPLAY_POSITION = Vector2D(600, -600)
    static let PAINT_GUN_AMMO_DISPLAY_SIZE = Vector2D(60, 200)

    static let PAINT_BUCKET_AMMO_DISPLAY_POSITION = Vector2D(500, -600)
    static let PAINT_BUCKET_AMMO_DISPLAY_SIZE = Vector2D(60, 200)

    static let PAINT_AMMO_DISPLAY_SIZE = Vector2D(50, 25)

    static let HEALTH_DISPLAY_POSITION = Vector2D(275, -610)
    static let HEALTH_DISPLAY_SIZE = Vector2D(300, 85)

    static let HEART_DISPLAY_SIZE = Vector2D(75, 75)

    static let MODEL_WORLD_SIZE = Vector2D(2_000, 1_500)

    static let CANVAS_END_MARKER_POSITION = Vector2D(700, 570)
    static let CANVAS_END_MARKER_SIZE = Vector2D(250, 100)

    static let CANVAS_SPAWNER_POSITION = Vector2D(-1_100, 620)
    static let CANVAS_SPAWNER_SIZE = Vector2D(200, 200)

    static let AMMO_DROP_SIZE = Vector2D(75, 75)

    static let ENEMY_SIZE = Vector2D(100, 100)
    static let ENEMY_SPAWNER_SIZE = Vector2D(100, 100)

    static let CANVAS_REQUEST_SIZE = Vector2D(150, 150)

    static let CANVAS_SIZE = Vector2D(50, 50)
}
