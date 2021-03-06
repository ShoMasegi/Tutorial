import Domain
import UIKit
import NetworkPlatform

final class Application {
    static let shared = Application()
    let rootViewController: RootViewController = RootViewController()
    
    private init() {}
    
    func setup(in window: UIWindow) {
        rootViewController.current = SplashViewController()
        window.rootViewController = self.rootViewController
        window.makeKeyAndVisible()
    }

    func defaultUseCaseProvider() -> Domain.UseCaseProvider {
        return DefaultUseCaseProvider(networkUseCaseProvider: defaultNetworkUseCaseProvider())
    }

    private func defaultNetworkUseCaseProvider() -> Domain.NetworkUseCaseProvider {
        let networking = Networking.newDefaultNetworking(responseFilterClosure: { statusCode in
            switch statusCode {
            case 400:
                let lockViewController = LockViewController(type: .badRequest)
                self.rootViewController.animateFadeTransition(to: lockViewController)
                return false
            case 403:
                let lockViewController = LockViewController(type: .forbidden)
                self.rootViewController.animateFadeTransition(to: lockViewController)
                return false
            case 404:
                let lockViewController = LockViewController(type: .notFound)
                self.rootViewController.animateFadeTransition(to: lockViewController)
                return false
            case 422: return false
            default: return true
            }
        })
        return NetworkPlatform.UseCaseProvider(networking: networking)
    }
}
