import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        return true
    }

    var applicationIsReturningBackground: Bool = false

    func applicationWillEnterForeground(_ application: UIApplication) {
        applicationIsReturningBackground = true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if applicationIsReturningBackground {
            applicationIsReturningBackground = false

            if let lockViewController = Application.shared.rootViewController.current as? LockViewController {
                lockViewController.appDidBecomeActive()
            } else if let splashViewController = Application.shared.rootViewController.current as? SplashViewController {
                splashViewController.appDidBecomeActive()
            }
        }
    }

    private func setupWindow() {
        window = {
            let window = UIWindow(frame: UIScreen.main.bounds)
            Application.shared.setup(in: window)
            return window
        }()
    }
}

extension AppDelegate {
    
    var rootViewController: RootViewController? {
        return window?.rootViewController as? RootViewController
    }
}
