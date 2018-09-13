import Foundation

struct User: Decodable {
    let id: Int64
    let login: String
    let displayLogin: String?
    let url: URL
    let avatarUrl: URL
}
