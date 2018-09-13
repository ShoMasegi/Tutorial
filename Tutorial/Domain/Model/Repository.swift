import Foundation

struct Repository: Decodable {
    let id: Int64
    let name: String
    let fullName: String?
    let owner: User?
    let url: URL
    let forksCount: Int?
    let openIssuesCount: Int?
    let watchersCount: Int?
    let stargazersCount: Int?
    let language: String?
    let updatedAt: Date?
    let `private`: Bool?
    let description: String?
}
