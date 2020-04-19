import Domain
import Moya
import RxSwift

public struct Response<T: Decodable> {
    let data: T

    public init(data: T) {
        self.data = data
    }

    public init(response: Moya.Response) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let responseEntity: T = try decoder.decode(T.self, from: response.data)
        self.init(data: responseEntity)
    }
}

public struct ErrorResponse: Decodable {
    let message: String?

    init(message: String?) {
        self.message = message
    }

    init(response: Moya.Response) throws {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let responseEntity: ErrorResponse = try decoder.decode(ErrorResponse.self, from: response.data)
        self.init(message: responseEntity.message)
    }
}

extension ObservableType where Element == Moya.Response {

    public func map<T: Decodable>(to: T.Type) -> Observable<Response<T>> {
        return flatMap { response -> Observable<Response<T>> in
            do {
                let res = try Response<T>.init(response: response)
                return Observable.just(res)
            } catch let error {
                return Observable.error(error)
            }
        }
    }

    public func filterAPIError() -> Observable<Element> {
        return flatMap({ response -> Observable<Element> in
            switch response.statusCode {
            case 200...299:
                return Observable.just(response)
            default:
                do {
                    let res = try ErrorResponse.init(response: response)
                    return Observable.error(APIError.server(statusCode: response.statusCode, message: res.message))
                } catch let error {
                    return Observable.error(error)
                }
            }
        })
    }
}
