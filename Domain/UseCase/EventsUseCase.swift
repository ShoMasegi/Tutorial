import Foundation
import RxSwift

public protocol EventsUseCase {
    func events(page: Int) -> Observable<[Event]>
}
