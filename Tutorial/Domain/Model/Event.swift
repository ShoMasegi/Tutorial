import Foundation

struct Event: Decodable {
    let id: String
    let type: String
    let actor: User
    let repo: Repository
}
