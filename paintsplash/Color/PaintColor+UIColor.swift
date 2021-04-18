//
//  PaintColor+UIColor.swift
//  paintsplash
//
//  Created by Ho Pin Xian on 17/3/21.
//

import UIKit

/**
 This extension maps from `PaintColor` to `UIColor`.
 The usage is intended for conversion of PaintColor to a form usable for display.
 */
extension PaintColor {
    var uiColor: UIColor {
        switch self {
        case .red:
            return UIColor(red: 255, green: 51, blue: 51)
        case .blue:
            return UIColor(red: 51, green: 133, blue: 255)
        case .purple:
            return UIColor(red: 136, green: 77, blue: 255)
        case .green:
            return UIColor(red: 92, green: 214, blue: 92)
        case .orange:
            return UIColor(red: 255, green: 148, blue: 77)
        case .yellow:
            return UIColor(red: 255, green: 255, blue: 102)
        case .white:
            return UIColor.white
        case .lightred:
            return UIColor(red: 255, green: 128, blue: 128)
        case .lightblue:
            return UIColor(red: 153, green: 194, blue: 255)
        case .lightpurple:
            return UIColor(red: 204, green: 179, blue: 255)
        case .lightgreen:
            return UIColor(red: 187, green: 255, blue: 153)
        case .lightorange:
            return UIColor(red: 255, green: 191, blue: 128)
        case .lightyellow:
            return UIColor(red: 255, green: 255, blue: 179)
        }
    }
}

extension UIColor {
    /// Initializes a UIColor using rgb color codes.
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        let redPart = CGFloat(red) / 255
        let greenPart = CGFloat(green) / 255
        let bluePart = CGFloat(blue) / 255

        self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)
    }
}
