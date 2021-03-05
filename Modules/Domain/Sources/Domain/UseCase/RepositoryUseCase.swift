import Foundation
import RxSwift

public protocol RepositoryUseCase {
    func repository(apiUrl: String) -> Observable<Repository>
    func readme(owner: String, repo: String) -> Observable<ReadMe>
}
