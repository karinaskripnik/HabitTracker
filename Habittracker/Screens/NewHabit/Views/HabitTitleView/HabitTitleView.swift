import UIKit

@IBDesignable
final class HabitTitleView: UIView, NibLoadable {

    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var searchButton: UIButton!

    var didTapTemplatesButton: (() -> Void)?
    
    var titleText: String? {
        get { titleTextField.text }
        set { titleTextField.text = newValue }
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

    @IBAction private func didEndTitleTextFieldEditing(_ sender: UITextField) {
    }
    
    @IBAction private func didTapsSearchButton(_ sender: UIButton) {
        didTapTemplatesButton?()
    }
}

