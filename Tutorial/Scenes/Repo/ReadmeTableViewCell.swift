import UIKit
import SnapKit
import Down

final class ReadMeTableViewCell: UITableViewCell, Reusable {

    var readme: ReadMe? = nil {
        didSet {
            guard let readme = self.readme,
                  let string = try? String(contentsOf: readme.downloadUrl, encoding: .utf8) else {
                return
            }
            try? downView.update(markdownString: string)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private lazy var downView: DownView = {
        let url = Bundle(for: type(of: self)).url(forResource: "DownView", withExtension: "bundle")
        let bundle = Bundle(url: url!)
        let downView = try! DownView(
            frame: .zero,
            markdownString: "",
            openLinksInBrowser: false,
            templateBundle: bundle
        )
        downView.scrollView.showsHorizontalScrollIndicator = false
        downView.scrollView.bounces = false
        return downView
    }()

    private func setupSubviews() {
        contentView.addSubview(downView)
        downView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.edges.equalToSuperview()
        }
    }
}
