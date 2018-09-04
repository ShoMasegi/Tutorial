import Foundation

struct Repository: Decodable {
    let id: Int64
    let name: String
    let url: URL

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
    }
}
