import Foundation
import Moya
import RxSwift
import RxMoya

public final class Provider<Target> where Target: Moya.TargetType {
    private let provider: MoyaProvider<Target>
    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
         session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false
    ) {
        provider = MoyaProvider(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            session: session,
            plugins: plugins,
            trackInflights: trackInflights
        )
    }

    func request(_ target: Target) -> Observable<Moya.Response> {
        return provider.rx.request(target).asObservable()
    }
}

public protocol NetworkingType {
    associatedtype T: TargetType
    var provider: Provider<T> { get }
}

public struct Networking: NetworkingType {
    public typealias T = API
    public let provider: Provider<T>
    let responseFilterClosure: ((Int) -> Bool)?

    init(provider: Provider<T>, responseFilterClosure: ((Int) -> Bool)? = nil) {
        self.provider = provider
        self.responseFilterClosure = responseFilterClosure
    }

}

extension Networking {
    public func request(_ target: API) -> Observable<Moya.Response> {
        return provider.request(target)
            .filter({ response -> Bool in
                self.responseFilterClosure?(response.statusCode) ?? true
            })
    }
    public func requestNoFilter(_ target: API) -> Observable<Moya.Response> {
        return provider.request(target)
    }
}

extension NetworkingType {
    public static func newDefaultNetworking(responseFilterClosure: ((Int) -> Bool)? = nil) -> Networking {
        return Networking(provider: newProvider(plugins), responseFilterClosure: responseFilterClosure)
    }

    static var plugins: [PluginType] {
        return [
            NetworkLoggerPlugin(configuration: Moya.NetworkLoggerPlugin.Configuration(logOptions: .verbose))
        ]
    }

    static func requestClosure() -> MoyaProvider<T>.RequestClosure {
        return { endpoint, closure in
            do {
                var request = try endpoint.urlRequest()
                request.httpShouldHandleCookies = false
                closure(.success(request))
            } catch let error {
                closure(.failure(MoyaError.underlying(error, nil)))
            }
        }
    }
    static func endpointClosure(statusCode: Int, data: Data) -> MoyaProvider<T>.EndpointClosure {
        return { target in
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            let sampleResponse: Endpoint.SampleResponseClosure = {
                return .networkResponse(statusCode, data)
            }
            return Endpoint(url: url, sampleResponseClosure: sampleResponse, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }
    }
}

private func newProvider<T>(_ plugins: [PluginType]) -> Provider<T> {
    return Provider<T>(
        requestClosure:  Networking.requestClosure(),
        stubClosure: MoyaProvider.neverStub,
        plugins: plugins
    )
}
