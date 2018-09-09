import Moya
import Alamofire

public enum API {
    case event(page: Int)
    case userEvent(username: String)
    case readme(owner: String, repo: String)
    case custom(url: String, method: Moya.Method)
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
        case .readme(let owner, let repo):
            return "repos/\(owner)/\(repo)/readme"
        case .custom(var url, _):
            // TODO: fix this
            if let range = url.range(of: Environment.urlString) {
                url.removeSubrange(range)
                return url
            } else {
                fatalError()
            }
        }
    }

    public var method: Moya.Method {
        switch self {
        case .event, .userEvent, .readme:
            return .get
        case .custom(_, let method):
            return method
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
