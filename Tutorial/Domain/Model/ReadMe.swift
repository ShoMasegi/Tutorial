import Foundation

struct ReadMe: Decodable {
    let downloadUrl: URL

    enum CodingKeys: String, CodingKey {
        case downloadUrl = "download_url"
    }
}
