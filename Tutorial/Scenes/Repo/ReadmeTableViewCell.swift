import UIKit
import SnapKit
import Down
import WebKit

protocol ReadMeTableViewCellDelegate: class {
    func didFinishLoad(_ readMeTableViewCell: ReadMeTableViewCell)
}

final class ReadMeTableViewCell: UITableViewCell, Reusable {

    weak var delegate: ReadMeTableViewCellDelegate?

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
        downView.navigationDelegate = self
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

extension ReadMeTableViewCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState") { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] (height, error) in
                    guard let self = self,
                          let height = height as? CGFloat else {
                        return
                    }
                    self.downView.snp.updateConstraints {
                        $0.height.equalTo(height)
                    }
                    self.delegate?.didFinishLoad(self)
                }
            }
        }
    }
}
