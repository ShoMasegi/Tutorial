import SVProgressHUD
import UIKit

class LoadingMask: NSObject {
    class func show() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
    }

    class func dismiss() {
        SVProgressHUD.dismiss()
    }
}
