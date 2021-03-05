import Domain
import Foundation

final class ReadMe {
    let name: String
    let size: Double
    let downloadUrl: URL

    init(with readme: Domain.ReadMe) {
        name = readme.name
        size = readme.size
        downloadUrl = readme.downloadUrl
    }
}
