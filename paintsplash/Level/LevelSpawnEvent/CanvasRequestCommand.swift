//
//  CanvasRequestCommand.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 25/3/21.
//

/**
 A command that spawns a canvas request that needs the given colors.
 If colors are not given, they are randomized when spawned.
 */
class CanvasRequestCommand: SpawnCommand {
    var colors: Set<PaintColor>?
    weak var requestManager: CanvasRequestManager?

    override func spawnIntoLevel(gameInfo: GameInfo) {
        let colors = self.colors ?? getRandomRequest()
        requestManager?.addRequest(colors: colors)
    }
}
