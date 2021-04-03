//
//  AmmoDropCommand.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 25/3/21.
//

class AmmoDropCommand: SpawnCommand {
    var location: Vector2D?
    var color: PaintColor?

    override func spawnIntoLevel(gameInfo: GameInfo) {
        if gameInfo.numberOfDrops >= Level.dropCapacity {
            return
        }

        let eventLocation = getLocation(location: location, gameInfo: gameInfo)
        let eventColor = getAmmoDropColor(color: color, gameInfo: gameInfo)

        let ammoDrop = PaintAmmoDrop(color: eventColor, position: eventLocation)
        ammoDrop.spawn()
    }

    func getAmmoDropColor(color: PaintColor?, gameInfo: GameInfo) -> PaintColor {
        if let color = color {
            return color
        }

        let requiredColorDict = gameInfo.existingEnemyColors
            .merging(gameInfo.requiredCanvasColors, uniquingKeysWith: { $0 + $1 })
            .merging(gameInfo.existingDropColors, uniquingKeysWith: { $0 - $1 })
        var colors = [PaintColor]()
        for (key, value) in requiredColorDict {
            if value > 0 {
                for _ in 0..<value {
                    colors.append(key)
                }
            }
        }
        return colors.shuffled().first ?? PaintColor.allCases.shuffled()[0]
    }
}
