//
//  PaintColor+UIColor.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 17/3/21.
//


import UIKit

extension PaintColor {
    var uiColor: UIColor {
        switch self {
        case .red:
            return UIColor.red.darker()
        case .blue:
            return UIColor.blue.darker()
        case .purple:
            return UIColor.purple.darker()
        case .green:
            return UIColor.green.darker()
        case .orange:
            return UIColor.orange.darker()
        case .yellow:
            return UIColor.yellow.darker()
        case .white:
            return UIColor.white
        case .lightred:
            return UIColor.red.lighter()
        case .lightblue:
            return UIColor.blue.lighter()
        case .lightpurple:
            return UIColor.purple.lighter()
        case .lightgreen:
            return UIColor.green.lighter()
        case .lightorange:
            return UIColor.orange.lighter()
        case .lightyellow:
            return UIColor.yellow.lighter()
        }
    }
}

extension UIColor {
    private func adjustColor(_ value: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        red = max(0, min(1, (1 + value) * red))
        blue = max(0, min(1, (1 + value) * blue))
        green = max(0, min(1, (1 + value) * green))

        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func lighter(by value: CGFloat = 0.3) -> UIColor {
        return adjustColor(value)
    }
    
    func darker(by value: CGFloat = 0.3) -> UIColor {
        return adjustColor(-value)
    }
}
