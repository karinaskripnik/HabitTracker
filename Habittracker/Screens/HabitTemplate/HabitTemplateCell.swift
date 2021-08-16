import Foundation
import UIKit

final class HabitTemplateCell: UITableViewCell {
    static let reuseIdentifier = String(describing: self)

    var template: HabitTemplate? {
        didSet {
            textLabel?.text = template?.title
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        template = nil
    }

    private func commonInit() {
        backgroundColor = .backgroundLight
    }
}
