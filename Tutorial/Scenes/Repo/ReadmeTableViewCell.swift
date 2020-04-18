import UIKit
import SnapKit
import MarkdownView
import WebKit

protocol ReadMeTableViewCellDelegate: class {
    func didFinishLoad(_ readMeTableViewCell: ReadMeTableViewCell)
    func touchedLink(_ readMeTableViewCell: ReadMeTableViewCell, link: URL)
}

final class ReadMeTableViewCell: UITableViewCell, Reusable {

    weak var delegate: ReadMeTableViewCellDelegate?

    var readme: ReadMe? = nil {
        didSet {
            guard let readme = self.readme,
                  let markdown = try? String(contentsOf: readme.downloadUrl, encoding: .utf8) else {
                return
            }
            markdownView.load(markdown: markdown)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private lazy var markdownView: MarkdownView = {
        let markdownView = MarkdownView()
        markdownView.isScrollEnabled = false
        markdownView.onRendered = { [weak self] height in
            guard let self = self else { return }
            self.markdownView.snp.makeConstraints {
                $0.height.equalTo(height + 48).priority(.medium)
            }
            self.delegate?.didFinishLoad(self)
        }
        markdownView.onTouchLink = { [weak self] request in
            guard let self = self,
                  let url = request.url,
                  url.scheme == "https" || url.scheme == "http" else { 
                return false
            }
            self.delegate?.touchedLink(self, link: url)
            return false
        }
        return markdownView
    }()

    private func setupSubviews() {
        contentView.addSubview(markdownView)
        markdownView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
