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

    private var mapping: [ColorMakeup: PaintColor]

    /// Constructs a mixer containing default mixing rules for paint color.
    init() {
        mapping = [:]
        setDefaultMixRules()
    }
    
    /// Sets the rules of the color mixer to the default set of rules.
    private func setDefaultMixRules() {
        mapping = [:]
        for color in PaintColor.allCases {
            mapping[color.makeup] = color
        }
        for color in PaintColor.lightColors {
            var makeup = color.makeup + ColorMakeup.white
            makeup.simplify()
            mapping[makeup] = PaintColor.white
        }
    }
    
    /// Mixes the given colors and returns the new color.
    /// Returns nothing if no valid color is produced from the mix.
    func mix(colors: [PaintColor]) -> PaintColor? {
        guard !colors.isEmpty else {
            return nil
        }
        
        var makeup = colors[0].makeup
        for i in 1..<colors.count {
            makeup += colors[i].makeup
        }
        makeup.simplify()
        
        return mapping[makeup]
    }
}
