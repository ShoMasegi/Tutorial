import Foundation
import RxCocoa
import RxSwift

class ActivityIndicator: SharedSequenceConvertibleType {
    typealias E = Bool
    typealias Strategy = DriverSharingStrategy

    private let _lock = NSRecursiveLock()
    private let _variable = Variable(false)
    private let _loading: SharedSequence<Strategy, E>

    init() {
        _loading = _variable.asDriver()
                .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return source.asObservable()
        .do(onNext: { _ in
            self.sendStopLoading()
        }, onError: { _ in
            self.sendStopLoading()
        }, onCompleted: {
            self.sendStopLoading()
        }, onSubscribe: subscribed)
    }

    private func subscribed() {
        _lock.lock()
        _variable.value = true
        _lock.unlock()
    }

    private func sendStopLoading() {
        _lock.lock()
        _variable.value = false
        _lock.unlock()
    }

    func asSharedSequence() -> SharedSequence<Strategy, Bool> {
        return _loading
    }
}

extension ObservableConvertibleType {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<E> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
