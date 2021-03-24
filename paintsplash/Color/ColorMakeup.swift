//
//  ColorMakeup.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 16/3/21.
//

struct ColorMakeup: Hashable {
    private(set) var redCount: Int
    private(set) var blueCount: Int
    private(set) var yellowCount: Int
    private(set) var whiteCount: Int

    static let red = ColorMakeup(r: 1, b: 0, y: 0, w: 0)
    static let blue = ColorMakeup(r: 0, b: 1, y: 0, w: 0)
    static let yellow = ColorMakeup(r: 0, b: 0, y: 1, w: 0)
    static let white = ColorMakeup(r: 0, b: 0, y: 0, w: 1)

    private init(r red: Int, b blue: Int, y yellow: Int, w white: Int) {
        redCount = red
        blueCount = blue
        yellowCount = yellow
        whiteCount = white

        assert(checkRepresentation())
    }

    static func + (_ colorA: ColorMakeup, _ colorB: ColorMakeup) -> ColorMakeup {
        ColorMakeup(r: colorA.redCount + colorB.redCount,
                    b: colorA.blueCount + colorB.blueCount,
                    y: colorA.yellowCount + colorB.yellowCount,
                    w: colorA.whiteCount + colorB.whiteCount)
    }

    static func += (left: inout ColorMakeup, right: ColorMakeup) {
        let new = left + right
        left = new
        assert(left.checkRepresentation())
    }

    func contains(_ color: ColorMakeup) -> Bool {
        self.redCount >= color.redCount &&
            self.blueCount >= color.blueCount &&
            self.yellowCount >= color.yellowCount &&
            self.whiteCount >= color.whiteCount
    }

    mutating func simplify() {
        assert(checkRepresentation())

        var values = [redCount, blueCount, yellowCount, whiteCount]
        values = values.filter { $0 != 0 }
        let gcd = Math.getGCD(numbers: values)

        assert(gcd != 0)
        self.redCount /= gcd
        self.blueCount /= gcd
        self.yellowCount /= gcd
        self.whiteCount /= gcd

        assert(checkRepresentation())
    }

    private func checkRepresentation() -> Bool {
        allNonNegative() && notEmpty()
    }

    private func allNonNegative() -> Bool {
        redCount >= 0 &&
            blueCount >= 0 &&
            yellowCount >= 0 &&
            whiteCount >= 0
    }

    private func notEmpty() -> Bool {
        redCount + blueCount + yellowCount + whiteCount > 0
    }
}
