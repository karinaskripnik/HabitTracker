import Foundation
import UIKit

final class ResultCell: UITableViewCell, NibLoadable {

    @IBOutlet private var habbitTitle: UILabel!
    @IBOutlet private var statisticTitle: UILabel!
    
    static let reuseIdentifier = String(describing: self)

    var habbit: Habit? {
        didSet {
            updateContent()
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

    private func commonInit() {
        initFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        habbit = nil
    }

    private func updateContent() {
        guard let habbit = habbit else {
            habbitTitle.text = nil
            statisticTitle.text = nil
            return
        }
        
        habbitTitle.text = habbit.title
        statisticTitle.text = String(habbit.completedDates.count)
    }
}


