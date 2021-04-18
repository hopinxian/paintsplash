//
//  AmmoDropCommand.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 25/3/21.
//

/**
 A command that spawns a paint ammo drop of the given location and color.
 If location or color is not given, they are randomized when spawned.
 */
class AmmoDropCommand: SpawnCommand {
    var location: Vector2D?
    var color: PaintColor?

    override func spawnIntoLevel(gameInfo: GameInfo) {
        if gameInfo.numberOfDrops >= Level.dropCapacity {
            return
        }

        let eventLocation = getLocation(location: location,
                                        gameInfo: gameInfo,
                                        size: Constants.AMMO_DROP_SIZE)
        let eventColor = getAmmoDropColor(color: color, gameInfo: gameInfo)

        let ammoDrop = PaintAmmoDrop(color: eventColor, position: eventLocation)
        ammoDrop.spawn()
    }

    func getAmmoDropColor(color: PaintColor?, gameInfo: GameInfo) -> PaintColor {
        if let color = color {
            return color
        }

        // calculates a color that is needed by the player based on the colors
        // needed for canvas requests and colors of the enemies.
        // Colors are needed more are more likely to be chosen.
        let colors = prepareNeededColors(gameInfo)

        let length = colors.count
        if length != 0 {
            let randomColor = colors[SpawnCommand.rng.nextInt(0..<length)]
            return randomColor
        }
        // returns any random color if there is none that is needed
        return super.getColor(color: nil, gameInfo: gameInfo)
    }

    private func prepareNeededColors(_ gameInfo: GameInfo) -> [PaintColor] {
        let requiredColorDict = gameInfo.existingEnemyColors
            .merging(gameInfo.requiredCanvasColors, uniquingKeysWith: { $0 + $1 })
            .merging(gameInfo.existingDropColors, uniquingKeysWith: { $0 - $1 })
        var colors = [PaintColor]()
        for (key, value) in requiredColorDict where value > 0 {
            for _ in 0..<value {
                colors.append(key)
            }
        }
        return colors
    }
}
