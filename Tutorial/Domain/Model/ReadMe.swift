import Foundation

struct ReadMe: Decodable {
    let name: String
    let size: Double
    let downloadUrl: URL

    enum CodingKeys: String, CodingKey {
        case name
        case size
        case downloadUrl = "download_url"
    }
}
