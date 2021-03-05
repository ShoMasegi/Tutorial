import Foundation
import RxSwift

public protocol SplashUseCase {
    func events(page: Int) -> Observable<[Event]>
}
