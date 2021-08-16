import Foundation
import UIKit

final class TodayCell: UITableViewCell, NibLoadable {
    
    @IBOutlet private var doneButton: UIButton!
    @IBOutlet private var habbitTitle: UILabel!
    @IBOutlet private var timeTitle: UILabel!

    static let reuseIdentifier = String(describing: self)

    var habbit: Habit? {
        didSet {
            updateContent()
        }
    }

    var didToggleHabit: (() -> Void)?

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
        
        habbit = nil
        didToggleHabit = nil
    }

    private func commonInit() {
        initFromNib()
    }

    @IBAction private func didTapDoneButton(_ sender: UIButton) {
        didToggleHabit?()
    }

    private func updateContent() {
        timeTitle.text = habbit?.reminder.time.formatted
        habbitTitle.text = habbit?.title
        doneButton.isSelected = habbit?.isDoneToday ?? false
    }
}

