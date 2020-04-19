import Foundation

public struct Repository: Decodable {
    public let id: Int64
    public let name: String
    public let fullName: String?
    public let owner: User?
    public let url: URL
    public let forksCount: Int?
    public let openIssuesCount: Int?
    public let watchersCount: Int?
    public let stargazersCount: Int?
    public let language: String?
    public let updatedAt: Date?
    public let `private`: Bool?
    public let description: String?
}
