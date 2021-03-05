import Domain
import RxSwift
import Moya

public final class RepositoryUseCase: Domain.RepositoryUseCase {
    private let network: Networking

    public init(network: Networking) {
        self.network = network
    }

    public func repository(apiUrl: String) -> Observable<Domain.Repository> {
        return network.request(.custom(url: apiUrl, method: .get))
            .filterAPIError()
            .map(to: Repository.self)
    }

    public func readme(owner: String, repo: String) -> Observable<Domain.ReadMe> {
        return network.requestNoFilter(.readme(owner: owner, repo: repo))
            .filterAPIError()
            .map(to: ReadMe.self)
    }
}