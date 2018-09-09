import UIKit

public extension UIColor {
    public static var t_grey: UIColor { return UIColor(hex: "212121", alpha: 0.72) }
    public static var t_border: UIColor { return UIColor(hex: "707070", alpha: 0.25) }
}

public extension UIColor {
    public convenience init(hex: String, alpha: CGFloat) {
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    public convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}
