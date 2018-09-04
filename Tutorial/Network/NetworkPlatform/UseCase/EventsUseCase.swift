import Foundation
import Moya
import RxSwift

public final class EventsUseCase {
    private let network: Networking

    public init(network: Networking) {
        self.network = network
    }

    func events(page: Int) -> Observable<Response<[Event]>> {
        return network.request(.event(page: page))
                .filterSuccessfulStatusCodes()
                .map(to: [Event].self)
    }
}
