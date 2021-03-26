//
//  AmmoDropCommand.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 25/3/21.
//

class AmmoDropCommand: SpawnCommand {
    var location: Vector2D?
    var color: PaintColor?

    override func spawnIntoLevel(gameInfo: AIGameInfo) {
        let eventLocation = getLocation(location: location, gameInfo: gameInfo)
        let eventColor = getColor(color: color, gameInfo: gameInfo)

        let ammoDrop = PaintAmmoDrop(color: eventColor, position: eventLocation)
        ammoDrop.spawn()
    }
}
