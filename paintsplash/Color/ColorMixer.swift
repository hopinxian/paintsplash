//
//  ColorMixer.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

/**
 `ColorMixer` represents a mixer that mixes colors to produce a color.
 ColorMixer mixes colors according to a stated set of rules that it has.
 */
class ColorMixer {

    private var mapping: [[BaseColor: Int]:PaintColor]

    /// Constructs a mixer containing default mixing rules for paint color.
    init() {
        mapping = [:]
        setDefaultMixRules()
    }
    
    /// Sets the rules of the color mixer to the default set of rules.
    private func setDefaultMixRules() {
        mapping = [:]
        for color in PaintColor.allCases {
            mapping[color.baseColors] = color
        }
        for color in PaintColor.lightColors {
            var base = color.baseColors
            base[BaseColor.white, default: 0] += 1
            mapping[base] = PaintColor.white
        }
    }
    
    /// Mixes the given colors and returns the new color.
    /// Returns nothing if no valid color is produced from the mix.
    func mix(colors: [PaintColor]) -> PaintColor? {
        var base: [BaseColor: Int] = [:]
        for color in colors {
            base.merge(color.baseColors) {
                current, other in current + other
            }
        }

        // Reduce the values of the dictionary to lowest possible
        let values = [Int](base.values)
        let gcd = Math.getGCD(numbers: values)
        base = base.mapValues{ $0 / gcd }
        
        return mapping[base]
    }
}
