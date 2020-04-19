import Domain
import RxSwift
import Moya

public final class RepositoryUseCase {
    private let network: Networking

    public init(network: Networking) {
        self.network = network
    }

    public func repository(apiUrl: String) -> Observable<Response<Domain.Repository>> {
        return network.request(.custom(url: apiUrl, method: .get))
            .filterAPIError()
            .map(to: Repository.self)
    }

    public func readme(owner: String, repo: String) -> Observable<Response<Domain.ReadMe>> {
        return network.requestNoFilter(.readme(owner: owner, repo: repo))
            .filterAPIError()
            .map(to: ReadMe.self)
    }
}
