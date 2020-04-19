import Domain

public final class UseCaseProvider: Domain.NetworkUseCaseProvider {
    private let networkProvider: Networking

    public init(networking: Networking = Networking.newDefaultNetworking()) {
        networkProvider = networking
    }

    public func makeSplashUseCase() -> Domain.SplashUseCase {
        return SplashUseCase(network: networkProvider)
    }

    public func makeEventsUseCase() -> Domain.EventsUseCase {
        return  EventsUseCase(network: networkProvider)
    }

    public func makeRepositoryUseCase() -> Domain.RepositoryUseCase {
        return RepositoryUseCase(network: networkProvider)
    }
}
