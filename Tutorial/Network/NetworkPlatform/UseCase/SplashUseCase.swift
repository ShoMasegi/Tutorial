import Foundation
import Moya
import RxSwift

public final class SplashUseCase {

    private let network: Networking

    public init(network: Networking) {
        self.network = network
    }

    func events(page: Int) -> Observable<Response<[Event]>> {
        return network.request(.event(page: page))
                .filterAPIError()
                .map(to: [Event].self)
    }

}
