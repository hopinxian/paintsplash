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
enum PaintColor: String, CaseIterable {
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

    /// An array of all light colors
    static let lightColors = [lightred, lightblue, lightgreen, lightyellow, lightpurple, lightorange]

    /// Returns the makeup of the color as a composition of base colors.
    var makeup: ColorMakeup {
        var makeup: ColorMakeup
        switch self {
        case .red:
            makeup = .red
        case .blue:
            makeup = .blue
        case .yellow:
            makeup = .yellow
        case .white:
            makeup = .white
        case .green:
            makeup = .blue + .yellow
        case .purple:
            makeup = .blue + .red
        case .orange:
            makeup = .yellow + .red
        case .lightred:
            makeup = .white + .red
        case .lightblue:
            makeup = .white + .blue
        case .lightyellow:
            makeup = .white + .yellow
        case .lightgreen:
            makeup = PaintColor.green.makeup + .white
        case .lightpurple:
            makeup = PaintColor.purple.makeup + .white
        case .lightorange:
            makeup = PaintColor.orange.makeup + .white
        }
        makeup.simplify()
        return makeup
    }

    /// Returns the result of mixing all the given colors.
    /// Returns nothing if there is no valid color from the mixture.
    func mix(with colors: [PaintColor]) -> PaintColor? {
        var mix = colors
        mix.append(self)
        return PaintColor.mixer.mix(colors: mix)
    }

    /// Returns true if this color contains the given color.
    func contains(color other: PaintColor) -> Bool {
        return self.makeup.contains(other.makeup)
    }

    /// Returns an array of colors which this color contains.
    func getSubColors() -> [PaintColor] {
        let subColors = PaintColor.allCases.filter { self.contains(color: $0) }
        return subColors
    }
}
