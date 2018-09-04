import Foundation
import RxCocoa
import RxSwift

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { _ in
            Driver.empty()
        }
    }
}
