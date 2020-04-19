import Domain
import RxCocoa
import RxSwift
import RxRelay

final class EventsViewModel {
    private let useCase: EventsUseCase
    private let navigator: MainNavigator
    private let bag = DisposeBag()
    init(useCase: EventsUseCase, navigator: MainNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }

    private let elements = BehaviorRelay<[Event]>(value: [])
    private let hasNext = BehaviorRelay<Bool>(value: true)
    private let lastLoadedPage = BehaviorRelay<Int>(value: 1)
}

extension EventsViewModel {
    struct Input {
        let initTrigger: Driver<Void>
        let refreshTrigger: Driver<Void>
        let loadNextPageTrigger: Driver<Void>
        let modelSelected: Driver<Event>
    }

    struct Output {
        let refreshing: Driver<Bool>
        let loading: Driver<Bool>
        let events: Driver<[Event]>
        let isNavigated: Driver<Bool>
        let error: Driver<Error>
    }
}

extension EventsViewModel: ViewModelType {
    func transform(input: Input) -> Output {
        let refreshingActivityIndicator = ActivityIndicator()
        let loadingActivityIndicator = ActivityIndicator()
        let refreshing = refreshingActivityIndicator.asDriver()
        let loading = loadingActivityIndicator.asDriver()
        let errorTracker = ErrorTracker()
        let errors = errorTracker.asDriver()
        let refreshResponse = Driver.merge(input.initTrigger, input.refreshTrigger)
            .withLatestFrom(refreshing)
            .filter { !$0 }
            .do(onNext: { _ in
                self.elements.accept([])
                self.lastLoadedPage.accept(1)
                self.hasNext.accept(true)
            })
            .flatMapLatest { (_) -> Driver<[Event]> in
                return self.request(
                    page: self.lastLoadedPage.value,
                    activityIndicator: refreshingActivityIndicator,
                    errorTracker: errorTracker
                )
            }
        let nextPageResponse = input.loadNextPageTrigger
            .withLatestFrom(loading)
            .filter { !$0 }
            .withLatestFrom(hasNext.asDriver())
            .filter { $0 }
            .withLatestFrom(lastLoadedPage.asDriver())
            .flatMap { lastLoadedPage -> Driver<[Event]> in
                return self.request(page: lastLoadedPage + 1,
                                    activityIndicator: loadingActivityIndicator,
                                    errorTracker: errorTracker)
            }
        let isNavigated = input.modelSelected
            .do(onNext: { model in
                self.navigator.toRepository(repo: model.repo)
            })
            .map { _ in true }
        Driver
            .merge(refreshResponse, nextPageResponse)
            .drive(onNext: {
                self.elements.accept(self.elements.value + $0)
            }).disposed(by: bag)

        return Output(refreshing: refreshing,
                      loading: loading,
                      events: elements.asDriver(),
                      isNavigated: isNavigated,
                      error: errors)
    }

    private func request(
        page: Int,
        activityIndicator: ActivityIndicator,
        errorTracker: ErrorTracker
    ) -> Driver<[Event]> {
        return useCase.events(page: page)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .do(onNext: { _ in
                self.lastLoadedPage.accept(self.lastLoadedPage.value + 1)
            })
            .map { events in events.map { event in Event(with: event) } }
            .catchError({ _ -> Observable<[Event]> in
                self.hasNext.accept(false)
                return Observable.just([])
            })
            .asDriver(onErrorJustReturn: [])
    }
}
