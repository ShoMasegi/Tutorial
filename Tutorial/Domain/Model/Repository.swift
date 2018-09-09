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
    let isPrivate: Bool?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case owner
        case url
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case watchersCount = "watchers_count"
        case stargazersCount = "stargazers_count"
        case language
        case updatedAt = "updated_at"
        case isPrivate = "private"
        case description
    }
}
