import Domain
import Moya
import RxCocoa
import RxSwift

final class SplashViewModel {
    private let useCase: SplashUseCase
    private let bag = DisposeBag()

    init(useCase: SplashUseCase) {
        self.useCase = useCase
    }

    // ログイン処理とか...
    func getEvens(onSuccess: @escaping ([Event]) -> Void, onError: @escaping (String) -> Void) {
        useCase.events(page: 1)
            .observeOn(MainScheduler.instance)
            .map { events in events.map { event in Event(with: event) } }
            .subscribe(onNext: { events in
                onSuccess(events)
            }, onError: { error in
                onError(error.localizedDescription)
            })
            .disposed(by: bag)
    }
}
