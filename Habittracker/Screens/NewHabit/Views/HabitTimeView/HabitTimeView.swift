import UIKit

@IBDesignable
final class HabitTimeView: UIView, NibLoadable {

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.minuteInterval = 5
        picker.sizeToFit()

        picker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        return picker
    }()

    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var timeTextField: UITextField! {
        didSet {
            timeTextField.inputView = datePicker
        }
    }

    var time: Habit.Reminder.Time {
        get {
            let components = Calendar
                .current
                .dateComponents([.hour, .minute], from: datePicker.date)

            return .init(
                hour: components.hour ?? 0,
                minute: components.minute ?? 0
            )
        }
        set {
            timeTextField.text = newValue.formatted
        }
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
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        datePicker.sizeToFit()
    }

    @objc private func handleDatePicker(_ datePicker: UIDatePicker) {
        timeTextField.text = datePicker.date.formatted
    }
}

private extension Date {
    var formatted: String {
        return DateFormatter.time.string(from: self)
    }
}

extension DateFormatter {
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

extension DateComponentsFormatter {
    static let time: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
}

extension Habit.Reminder.Time {
    var formatted: String? {
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        return DateComponentsFormatter.time.string(from: components)
    }
}
