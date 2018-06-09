//
//  Font.swift
//  {project}
//
//  Created by Botond Magyarosi on 18/07/16.
//  Copyright © 2016 Halcyon Mobile. All rights reserved.
//

import UIKit

enum FontSize: CGFloat {
    /// 11
    case extraSmall     = 11
    /// 14
    case mediumSmall    = 14
    /// 16
    case medium         = 16
    /// 24
    case large          = 24
    /// 36
    case largeTitles    = 36
    /// 20
    case navBar         = 20
}

private struct FontFamily {

    enum OpenSans: String, FontConvertible {
        case light            = "OpenSans-Light"
        case medium          = "Calibre-Medium"
        case bold             = "Calibre-Semibold"
    }
}

struct Font {

    static func light(size: FontSize) -> UIFont {
        return FontFamily.OpenSans.light.font(size: size)
    }

    static func medium(size: FontSize) -> UIFont {
        return FontFamily.OpenSans.medium.font(size: size)
    }

    static func bold(size: FontSize) -> UIFont {
        return FontFamily.OpenSans.bold.font(size: size)
    }
}

protocol FontConvertible {
    func font(size: FontSize) -> UIFont!
}

extension FontConvertible where Self: RawRepresentable, Self.RawValue == String {

    func font(size: FontSize) -> UIFont! {
        return UIFont(name: self.rawValue, size: size.rawValue)
    }
}
