import UIKit
import SnapKit
import Down

class ReadMeTableViewCell: UITableViewCell, Reusable {

    var readme: ReadMe? = nil {
        didSet {
            guard let readme = self.readme else { return }
            if let string = try? String(contentsOf: readme.downloadUrl, encoding: .utf8) {
                try? downView.update(markdownString: string) {}
            }
            downView.snp.updateConstraints {
                $0.height.equalTo(downViewSize)
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private lazy var downView: DownView = {
        let string = "# README.md Does Not Exist"
        let view = try! DownView(frame: .zero, markdownString: string)
        return view
    }()
    private var downViewSize: CGFloat {
        let height = UIScreen.main.bounds.height - 100
        if let readme = self.readme, readme.size > 200 {
            return height
        } else {
            return height / 2
        }
    }

    private func setupSubviews() {
        contentView.addSubview(downView)
        downView.snp.makeConstraints {
            $0.height.equalTo(downViewSize)
            $0.edges.equalToSuperview()
        }
    }
}
