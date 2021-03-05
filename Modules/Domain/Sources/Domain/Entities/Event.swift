import Foundation

public struct Event: Decodable {
    public let id: String
    public let type: String
    public let actor: User
    public let repo: Repository
}
