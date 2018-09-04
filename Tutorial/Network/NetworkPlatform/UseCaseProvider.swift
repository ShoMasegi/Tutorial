import Foundation

public final class UseCaseProvider {
    private let networkProvider: Networking

    init(networking: Networking) {
        networkProvider = networking
    }

    init() {
        networkProvider = Networking.newDefaultNetworking()
    }

    func makeSplashUseCase() -> SplashUseCase {
        return SplashUseCase(network: networkProvider)
    }

    func makeEventsUseCase() -> EventsUseCase {
        return  EventsUseCase(network: networkProvider)
    }
}
