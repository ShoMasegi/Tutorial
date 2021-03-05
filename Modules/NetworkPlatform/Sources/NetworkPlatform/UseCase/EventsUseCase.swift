import Domain
import Moya
import RxSwift

public final class EventsUseCase: Domain.EventsUseCase {
    private let network: Networking

    public init(network: Networking) {
        self.network = network
    }

    public func events(page: Int) -> Observable<[Domain.Event]> {
        return network.request(.event(page: page))
            .filterAPIError()
            .map(to: [Domain.Event].self)
    }
}
