import Foundation

public typealias UseCaseProvider = NetworkUseCaseProvider

public final class DefaultUseCaseProvider: UseCaseProvider {
    private let networkUseCaseProvider: NetworkUseCaseProvider

    public init(networkUseCaseProvider: NetworkUseCaseProvider) {
        self.networkUseCaseProvider = networkUseCaseProvider
    }

    public func makeSplashUseCase() -> SplashUseCase {
        return networkUseCaseProvider.makeSplashUseCase()
    }

    public func makeEventsUseCase() -> EventsUseCase {
        return networkUseCaseProvider.makeEventsUseCase()
    }

    public func makeRepositoryUseCase() -> RepositoryUseCase {
        return networkUseCaseProvider.makeRepositoryUseCase()
    }
}

public protocol NetworkUseCaseProvider {
    func makeSplashUseCase() -> SplashUseCase
    func makeEventsUseCase() -> EventsUseCase
    func makeRepositoryUseCase() -> RepositoryUseCase
}