import Domain
import Foundation

final class User {
    let id: Int64
    let login: String
    let displayLogin: String?
    let url: URL
    let avatarUrl: URL

    init(with user: Domain.User) {
        id = user.id
        login = user.login
        displayLogin = user.displayLogin
        url = user.url
        avatarUrl = user.avatarUrl
    }
}
