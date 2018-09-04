import Moya
import Alamofire

public enum API {
    case event(page: Int)
    case userEvent(username: String)
}

extension API: TargetType {
    private struct Environment {
        static var urlString: String {
            return "https://api.github.com/"
        }
    }

    public var baseURL: URL {
        guard let url = URL(string: Environment.urlString) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }

    public var fullUrl: String {
        return baseURL.absoluteString + path
    }

    public var path: String {
        switch self {
        case .event:
            return "events"
        case .userEvent(let username):
            return "users/\(username)/events/public"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .event, .userEvent:
            return .get
        }
    }

    public var sampleData: Data {
        fatalError("sampleData has not been implemented")
    }

    public var task: Moya.Task {
        switch self {
        case .event(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        default: return .requestPlain
        }
    }

    public var headers: [String: String]? {
        return [:]
    }

}
