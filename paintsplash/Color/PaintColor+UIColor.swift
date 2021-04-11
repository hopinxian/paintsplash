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
            return UIColor(rgbColorCodeRed: 255, green: 51, blue: 51, alpha: 1.0)
        case .blue:
            return UIColor(rgbColorCodeRed: 51, green: 133, blue: 255, alpha: 1.0)
        case .purple:
            return UIColor(rgbColorCodeRed: 136, green: 77, blue: 255, alpha: 1.0)
        case .green:
            // 92, 214, 92
            return UIColor(rgbColorCodeRed: 92, green: 214, blue: 92, alpha: 1.0)
        case .orange:
            // (255, 148, 77)
            return UIColor(rgbColorCodeRed: 255, green: 148, blue: 77, alpha: 1.0)
        case .yellow:
            // 255, 255, 128
            return UIColor(rgbColorCodeRed: 255, green: 255, blue: 102, alpha: 1.0)
        case .white:
            return UIColor.white
        case .lightred:
            // 255, 128, 128
            return UIColor(rgbColorCodeRed: 255, green: 128, blue: 128, alpha: 1.0)
        case .lightblue:
            // 153, 194, 255
            return UIColor(rgbColorCodeRed: 153, green: 194, blue: 255, alpha: 1.0)
        case .lightpurple:
            // 204, 179, 255
            return UIColor(rgbColorCodeRed: 204, green: 179, blue: 255, alpha: 1.0)
        case .lightgreen:
            // 187, 255, 153
            return UIColor(rgbColorCodeRed: 187, green: 255, blue: 153, alpha: 1.0)
        case .lightorange:
            // rgb(255, 191, 128)
            return UIColor(rgbColorCodeRed: 255, green: 191, blue: 128, alpha: 1.0)
        case .lightyellow:
            return UIColor(rgbColorCodeRed: 255, green: 255, blue: 179, alpha: 1.0)
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
        adjustColor(value)
    }

    func darker(by value: CGFloat = 0.3) -> UIColor {
        adjustColor(-value)
    }

    convenience init(rgbColorCodeRed red: Int, green: Int, blue: Int, alpha: CGFloat) {
         let redPart: CGFloat = CGFloat(red) / 255
         let greenPart: CGFloat = CGFloat(green) / 255
         let bluePart: CGFloat = CGFloat(blue) / 255

         self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)
    }
    
}
