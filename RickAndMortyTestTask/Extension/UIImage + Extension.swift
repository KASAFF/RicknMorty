//
//  UIImage + Extension.swift
//  RickAndMortyTestTask
//
//  Created by Aleksey Kosov on 17.08.2023.
//

import UIKit
import SwiftUI

extension UIImage {
    static var placeholder: UIImage? { return UIImage(named: "placeholderImage") }
}

enum CustomImage {
    static var placeholder: Image? { return Image("placeholderImage") }
}
