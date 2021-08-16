import UIKit

@IBDesignable
final class HabitWeekdaysView: UIView, NibLoadable {

    @IBOutlet private var weekDaysLabel: UILabel!
    @IBOutlet private var monButton: UIButton!
    @IBOutlet private var tueButton: UIButton!
    @IBOutlet private var wedButton: UIButton!
    @IBOutlet private var thuButton: UIButton!
    @IBOutlet private var friButton: UIButton!
    @IBOutlet private var satButton: UIButton!
    @IBOutlet private var sunButton: UIButton!

    var weekdays: Set<Habit.Weekday> {
        .init(
            buttons
                .filter { $0.isSelected }
                .compactMap { Habit.Weekday(rawValue: $0.tag) }
        )
    }

    var buttons: [UIButton] {
        [
            sunButton,
            monButton,
            tueButton,
            wedButton,
            thuButton,
            friButton,
            satButton
        ]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        initFromNib()

        zip(Habit.Weekday.allCases, buttons).forEach { (weekday, button) in
            button.tag = weekday.rawValue
        }
    }

    @IBAction private func didTapWeekdayButton(_ sender: UIButton){
        sender.isSelected.toggle()
    }
}
