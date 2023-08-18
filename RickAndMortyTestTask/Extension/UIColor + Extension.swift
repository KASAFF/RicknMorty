//
//  UIColor + Extension.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import UIKit
import SwiftUI

extension UIColor {
    static var cellBackgroundColor: UIColor? { return UIColor(named: "blendBlack") }
    static var customBackgroundColor: UIColor? { return UIColor(named: "blackBackground") }
}

enum CustomColor {
    static var customBackgroundColor: Color? { return Color("blackBackground") }
    static var cellBackgroundColor: Color? { return Color("blendBlack") }
    static var textGreen: Color? { return Color("greenTextColor") }
    static var textGray: Color? { return Color("grayTextColor") }
}
