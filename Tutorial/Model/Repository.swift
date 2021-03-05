import Domain
import Foundation

final class Repository {
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

    init(with repo: Domain.Repository) {
        id = repo.id
        name = repo.name
        fullName = repo.fullName
        if let owner = repo.owner {
            self.owner = User(with: owner)
        } else {
            owner = nil
        }
        url = repo.url
        forksCount = repo.forksCount
        openIssuesCount = repo.openIssuesCount
        watchersCount = repo.watchersCount
        stargazersCount = repo.stargazersCount
        language = repo.language
        updatedAt = repo.updatedAt
        `private` = repo.private
        description = repo.description
    }
}
