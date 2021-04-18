//
//  Color.swift
//  paintsplash
//
//  Created by Farrell Nah on 14/4/21.
//
import UIKit

enum FontColor: String, Codable {
    case black
    case white

    func asUIColor() -> UIColor {
        switch self {
        case .black:
            return UIColor.black
        case .white:
            return UIColor.white
        }
    }
}
