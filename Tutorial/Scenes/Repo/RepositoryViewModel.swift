import Foundation
import RxSwift

final class RepositoryViewModel {
    private let useCase: RepositoryUseCase
    private let navigator: MainNavigator
    private let bag = DisposeBag()

    init(useCase: RepositoryUseCase, navigator: MainNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
}
