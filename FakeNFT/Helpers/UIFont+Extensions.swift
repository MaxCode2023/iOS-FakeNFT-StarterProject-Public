import UIKit

extension UIFont {
    enum AppFonts: String {
        case bold = "SFProText-Bold"
        case regular = "SFProText-REGULAR"
    }

    static func appFont(_ style: AppFonts, withSize size: CGFloat) -> UIFont {
        guard let font = UIFont(name: style.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: 12)
        }
        return font
    }
}


