import Foundation

struct User: Decodable {
    let id: Int64
    let login: String
    let name: String
    let url: URL
    let avatarUrl: URL

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name = "display_login"
        case url
        case avatarUrl = "avatar_url"
    }
}
