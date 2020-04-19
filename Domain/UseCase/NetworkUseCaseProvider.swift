import Foundation

public protocol NetworkUseCaseProvider {
    func makeSplashUseCase() -> SplashUseCase
    func makeEventsUseCase() -> EventsUseCase
    func makeRepositoryUseCase() -> RepositoryUseCase
}
