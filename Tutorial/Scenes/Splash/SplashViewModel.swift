import Foundation
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
        .subscribe(onNext: { response in
            onSuccess(response.data)
        }, onError: { error in
            if let apiError = error as? APIError {
                onError(apiError.message)
            } else {
                onError(error.localizedDescription)
            }
        })
        .disposed(by: bag)
    }
}
