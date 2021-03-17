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
            return UIColor.red
        case .blue:
            return UIColor.blue
        case .purple:
            return UIColor.purple
        case .green:
            return UIColor.green
        case .orange:
            return UIColor.orange
        case .yellow:
            return UIColor.yellow
        case .white:
            return UIColor.white
        default:
            print("Some colors dont have corresponding UI Color")
            return UIColor.brown
        }
    }
}
