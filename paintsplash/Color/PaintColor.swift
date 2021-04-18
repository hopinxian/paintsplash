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
enum PaintColor: String, CaseIterable, Codable {
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

    /// An array of base colors
    static let baseColors = [red, blue, yellow, white]

    /// An array of secondary colors
    static let secondaryColors = [purple, orange, green]

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

    /// Returns the result of mixing self with all the given colors.
    /// Returns nothing if there is no valid color from the mixture.
    func mix(with colors: [PaintColor]) -> PaintColor? {
        var mix = colors
        mix.append(self)
        return PaintColor.mixer.mix(colors: mix)
    }

    func contains(color other: PaintColor) -> Bool {
        self.makeup.contains(other.makeup)
    }

    /// Returns an array of colors which this color contains.
    func getSubColors() -> [PaintColor] {
        PaintColor.allCases.filter { self.contains(color: $0) }
    }
}
