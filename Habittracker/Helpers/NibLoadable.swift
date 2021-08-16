import UIKit

protocol NibLoadable: UIView {
    func initFromNib()

    var contentRootView: UIView { get }
}

extension NibLoadable {
    var contentRootView: UIView { self }

    func initFromNib() {
        let type = Swift.type(of: self)
        let bundle = Bundle(for: type)
        let nib = UINib(nibName: String(describing: type), bundle: bundle)
        let content = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        contentRootView.embed(content)
    }
}

extension NibLoadable where Self: UITableViewCell {
    var contentRootView: UIView { contentView }
}
