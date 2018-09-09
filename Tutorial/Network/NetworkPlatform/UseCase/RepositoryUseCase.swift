import Foundation
import RxSwift
import Moya

final class RepositoryUseCase {
    private let network: Networking

    public init(network: Networking) {
        self.network = network
    }

    func repository(apiUrl: String) -> Observable<Response<Repository>> {
        return network.request(.custom(url: apiUrl, method: .get))
                .filterSuccessfulStatusCodes()
                .map(to: Repository.self)
    }

    func readme(owner: String, repo: String) -> Observable<Response<ReadMe>> {
        return network.requestNoFilter(.readme(owner: owner, repo: repo))
                .filterSuccessfulStatusCodes()
                .map(to: ReadMe.self)
    }
}
