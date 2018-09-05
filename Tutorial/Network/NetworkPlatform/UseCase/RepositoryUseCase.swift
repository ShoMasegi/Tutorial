import Foundation
import RxSwift
import Moya

final class RepositoryUseCase {
    private let network: Networking

    public init(network: Networking) {
        self.network = network
    }
}
