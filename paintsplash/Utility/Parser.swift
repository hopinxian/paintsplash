//
//  Parser.swift
//  paintsplash
//
//  Created by admin on 17/4/21.
//

/**
 `Parser` parses values from text strings into data types
 such as doubles and integers of specific formats.
 */
struct Parser {
    static func parsePositiveDouble(_ arg: String) -> Double? {
        if let double = Double(arg),
           double > 0 {
            return double
        }
        return nil
    }

    static func parsePositiveInt(_ arg: String) -> Int? {
        if let integer = Int(arg),
           integer > 0 {
            return integer
        }
        return nil
    }

    static func parseVector2D(_ arg: [String]) -> Vector2D? {
        if let x = Double(arg[0]),
           let y = Double(arg[1]) {
            return Vector2D(x, y)
        }
        return nil
    }

    static func trimWhitespaceNewLine(_ str: String) -> String {
        str.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
