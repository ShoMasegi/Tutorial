import UIKit

extension UIScrollView {
    func scrollToTop(animated _: Bool) {
        var offset = CGPoint(x: -contentInset.left, y: -contentInset.top)

        if #available(iOS 11.0, *) {
            offset = CGPoint(x: -self.adjustedContentInset.left, y: -self.adjustedContentInset.top)
        }
        setContentOffset(offset, animated: true)
    }
}
