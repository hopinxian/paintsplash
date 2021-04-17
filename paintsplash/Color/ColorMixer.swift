//
//  ColorMixer.swift
//  paintsplash
//
//  Created by Praveen Bala on 8/3/21.
//

/**
 `ColorMixer` mixes a given set of colors to produce a color.
 Colors are mixed according to a stated set of rules that it has.
 Not all color combinations may produce a valid color.
 */
class ColorMixer {

    /// Keeps track of the mappings from a specific color combination to a PaintColor
    private var mapping: [ColorMakeup: PaintColor]

    /// Constructs a mixer containing default mixing rules for paint color.
    init() {
        mapping = [:]
        setDefaultMixRules()
    }

    private func setDefaultMixRules() {
        mapping = [:]
        for color in PaintColor.allCases {
            setMix(from: [color], to: color)
        }
        for color in PaintColor.lightColors {
            setMix(from: [color, PaintColor.white], to: PaintColor.white)
        }
    }

    /// Adds a rule that a specific color makeup will become another color.
    func setMix(from mix: ColorMakeup, to color: PaintColor) {
        var makeup = mix
        makeup.simplify()
        mapping[makeup] = color
    }

    /// Adds a rule that a specific combination of paint colors will become another color.
    func setMix(from colors: [PaintColor], to color: PaintColor) {
        guard !colors.isEmpty else {
            return
        }
        let makeups = colors.map { $0.makeup }
        let makeup = ColorMakeup.combine(makeups)
        setMix(from: makeup, to: color)
    }

    /// Removes a mixing rule from the mixer.
    func invalidate(mix: ColorMakeup) {
        var makeup = mix
        makeup.simplify()
        mapping[makeup] = nil
    }

    /// Removes a mixing rule from the mixer.
    func invalidate(mix: [PaintColor]) {
        guard !mix.isEmpty else {
            return
        }
        let makeups = mix.map { $0.makeup }
        let makeup = ColorMakeup.combine(makeups)
        invalidate(mix: makeup)
    }

    /// Mixes the given colors and returns the new color.
    /// Returns nothing if no valid color is produced from the mix.
    func mix(colors: [PaintColor]) -> PaintColor? {
        guard !colors.isEmpty else {
            return nil
        }
        let makeups = colors.map { $0.makeup }
        var makeup = ColorMakeup.combine(makeups)
        makeup.simplify()
        return mapping[makeup]
    }
}
