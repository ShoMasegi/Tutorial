import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNavigationBar()
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

    private func setupNavigationBar() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .t_grey
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
}

extension AppDelegate {
    
    var rootViewController: RootViewController? {
        return window?.rootViewController as? RootViewController
    }
}
