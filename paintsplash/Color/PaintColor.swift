//
//  PaintColor.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

/**
 `PaintColor` represents all possible paint colors.
 Paint colors can be decomposed into a composition of base colors.
 Paint colors are different if and only if their composition of
 base colors are different.
 */
enum PaintColor: String, CaseIterable, GameColor {
    case red
    case blue
    case yellow
    case green
    case purple
    case orange
    case lightred
    case lightblue
    case lightyellow
    case lightgreen
    case lightpurple
    case lightorange
    case white

    private static let mixer = ColorMixer()

    static let lightColors = [lightred, lightblue, lightgreen, lightyellow, lightpurple, lightorange]

    /// Decomposes the paint colors into a composition of base colors.
    /// Returns a dictionary that maps every base color to a quantity of it that is within the paint color.
    var baseColors: [BaseColor: Int] {
        switch self {
        case .red:
            return [BaseColor.red: 1]
        case .blue:
            return [BaseColor.blue: 1]
        case .yellow:
            return [BaseColor.yellow: 1]
        case .white:
            return [BaseColor.white: 1]
        case .green:
            return [BaseColor.blue: 1, BaseColor.yellow: 1]
        case .purple:
            return [BaseColor.blue: 1, BaseColor.red: 1]
        case .orange:
            return [BaseColor.red: 1, BaseColor.yellow: 1]
        case .lightred:
            return [BaseColor.white: 1, BaseColor.red: 1]
        case .lightblue:
            return [BaseColor.white: 1, BaseColor.blue: 1]
        case .lightyellow:
            return [BaseColor.white: 1, BaseColor.yellow: 1]
        case .lightgreen:
            return [BaseColor.white: 1, BaseColor.yellow: 1, BaseColor.blue: 1]
        case .lightpurple:
            return [BaseColor.white: 1, BaseColor.blue: 1, BaseColor.red: 1]
        case .lightorange:
            return [BaseColor.white: 1, BaseColor.red: 1, BaseColor.yellow: 1]
        }
    }

    func mix(with colors: [PaintColor]) -> PaintColor? {
        var mix = colors
        mix.append(self)
        return PaintColor.mixer.mix(colors: mix)
    }

    func contains(color other: PaintColor) -> Bool {
        let selfBase = self.baseColors
        let otherBase = other.baseColors.mapValues { -$0 }
        let difference = selfBase.merging(otherBase) {
            this, other in this + other
        }

        let isContain = difference.values.allSatisfy { $0 >= 0 }
        return isContain
    }

    func getSubColors() -> [PaintColor] {
        let subColors = PaintColor.allCases.filter { self.contains(color: $0) }
        return subColors
    }
}
