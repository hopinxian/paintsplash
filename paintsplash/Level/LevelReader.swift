//
//  LevelReader.swift
//  paintsplash
//
//  Created by admin on 12/4/21.
//

import Foundation

/**
 `LevelReader` reads in level information from a csv file.
 */
class LevelReader {
    /// File path where the level is stored
    let filePath: String

    init(filePath: String) {
        self.filePath = filePath
    }

    /// Returns a level that is read from the file path and initialized with the given arguments
    func readLevel(canvasManager: CanvasRequestManager, gameInfo: GameInfo) -> Level {
        let level = Level(canvasManager: canvasManager, gameInfo: gameInfo)

        guard let levelURL = Bundle.main.url(forResource: filePath,
                                             withExtension: "csv"),
            let levelDescription = try? String(contentsOf: levelURL) else {
                fatalError("unable to find level file")
        }

        var levelStringList = levelDescription.components(separatedBy: "\n")

        // process level configuration
        _ = levelStringList.removeFirst() // removes header for level configuration
        let header = levelStringList.removeFirst()
        parseHeader(header, level)

        // process level commands
        _ = levelStringList.removeFirst() // removes header for commands
        for commandString in levelStringList {
            if commandString.isEmpty {
                break
            }
            let cmd = parseStringToCommand(commandString)
            level.addCommand(cmd)
        }
        return level
    }

    private func parseHeader(_ header: String, _ level: Level) {
        var arg = header.components(separatedBy: ",")
        arg = arg.map { Parser.trimWhitespace($0) }

        level.repeatLimit = parseLimit(arg[0])
        level.bufferBetweenLoop = parseLoopBuffer(arg[1]) ?? level.bufferBetweenLoop
        Level.enemyCapacity = parseCapacity(arg[2]) ?? Level.enemyCapacity
        Level.dropCapacity = parseCapacity(arg[3]) ?? Level.dropCapacity
    }

    private func parseStringToCommand(_ commandString: String) -> SpawnCommand {
        var arguments = commandString.components(separatedBy: ",")
        arguments = arguments.map { Parser.trimWhitespace($0) }

        let command: SpawnCommand
        switch arguments[0].lowercased() {
        case "slime":
            command = parseEnemyCommand(arguments)
        case "slimespawner":
            command = parseEnemySpawnerCommand(arguments)
        case "request":
            command = parseCanvasRequestCommand(arguments)
        case "ammodrop":
            command = parseAmmoDropCommand(arguments)
        default:
            fatalError("unknown command: \(commandString)")
        }
        return command
    }

    private func parseEnemyCommand(_ arg: [String]) -> EnemyCommand {
        let command = EnemyCommand()
        command.location = parseLocation([arg[3], arg[4]])
        command.color = parseColor(arg[2])
        command.time = parseTime(arg[1])
        return command
    }

    private func parseEnemySpawnerCommand(_ arg: [String]) -> EnemySpawnerCommand {
        let command = EnemySpawnerCommand()
        command.location = parseLocation([arg[3], arg[4]])
        command.color = parseColor(arg[2])
        command.time = parseTime(arg[1])
        return command
    }

    private func parseCanvasRequestCommand(_ arg: [String]) -> CanvasRequestCommand {
        let command = CanvasRequestCommand()
        command.colors = parseCanvasColors(arg[2])
        command.time = parseTime(arg[1])
        return command
    }

    private func parseAmmoDropCommand(_ arg: [String]) -> AmmoDropCommand {
        let command = AmmoDropCommand()
        command.location = parseLocation([arg[3], arg[4]])
        command.color = parseColor(arg[2])
        command.time = parseTime(arg[1])
        return command
    }

    private func parseLocation(_ arg: [String]) -> Vector2D? {
        if arg[0].isEmpty && arg[1].isEmpty {
            return nil
        }
        if let location = Parser.parseVector2D(arg) {
            return location
        }
        fatalError("Location not given in proper format")
    }

    private func parseColor(_ arg: String) -> PaintColor? {
        if arg.isEmpty {
            return nil
        }
        if let color = PaintColor(rawValue: arg.lowercased()) {
            return color
        }
        fatalError("invalid color is given")
    }

    private func parseCanvasColors(_ arg: String) -> Set<PaintColor>? {
        if arg.isEmpty {
            return nil
        }

        let colorString = arg.components(separatedBy: " ")
        let colorsArray = colorString.map { Parser.trimWhitespace($0) }
                                     .compactMap { parseColor($0) }
        let colorSet = Set<PaintColor>(colorsArray)
        return colorSet
    }

    private func parseTime(_ arg: String) -> Double {
        if let time = Double(arg),
           time >= 0 {
            return time
        }
        fatalError("invalid time is given")
    }

    private func parseLimit(_ arg: String) -> Int? {
        if arg.isEmpty {
            return nil
        }
        if let limit = Parser.parsePositiveInt(arg) {
            return limit
        }
        fatalError("Limit should be positive int or empty")
    }

    private func parseLoopBuffer(_ arg: String) -> Double? {
        if arg.isEmpty {
            return nil
        }
        if let buffer = Double(arg),
           buffer >= 0 {
            return buffer
        }
        fatalError("buffer is not non negative")
    }

    private func parseCapacity(_ arg: String) -> Int? {
        if arg.isEmpty {
            return nil
        }
        if let capacity = Parser.parsePositiveInt(arg) {
            return capacity
        }
        fatalError("Capacity should be positive int")
    }
}
