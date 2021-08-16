import Foundation
import UIKit

protocol NewHabitViewControllerDelegate: AnyObject {
    func newHabitViewControllerDidClose(_ viewController: NewHabitViewController)
}

final class NewHabitViewController: UIViewController {

    @IBOutlet private var habitTitleView: HabitTitleView! {
        didSet {
            habitTitleView.didTapTemplatesButton = { [weak self] in
                self?.showHabitTemplates()
            }
        }
    }
    @IBOutlet private var habitWeekdaysView: HabitWeekdaysView!
    @IBOutlet private var habitTimeView: HabitTimeView!
    @IBOutlet private var createButton: UIButton!

    weak var delegate: NewHabitViewControllerDelegate?

    var habitService: HabitStorageServiceType = HabitService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction private func didTapCloseButton(_ sender: UIBarButtonItem) {
        delegate?.newHabitViewControllerDidClose(self)
    }

    @IBAction private func didTapCreateButton(_ sender: UIButton) {
        let habit = Habit(
            id: .init(),
            title: habitTitleView.titleText ?? "",
            reminder: .init(
                weekdays: habitWeekdaysView.weekdays,
                time: habitTimeView.time
            )
        )

        habitService.save(habit) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.habitTitleView.titleText = ""
                    self?.habitTimeView.time = Habit.Reminder.Time(hour: 09, minute: 00)
                case .failure(let error):
                    self?.showAlert(title: "Error", description: error.localizedDescription)
                }
            }
        }
    }

    private func showHabitTemplates() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigation = storyboard.instantiateViewController(identifier: "HabitTemplatesViewControllerNavigation") as! UINavigationController

        (navigation.viewControllers[0] as! HabitTemplatesViewController).delegate = self

        present(navigation, animated: true)
    }
}

extension NewHabitViewController: HabitTemplatesViewControllerDelegate {
    func habitTemplatesViewControllerDidClose(_ viewController: HabitTemplatesViewController) {
        dismiss(animated: true)
    }

    func habitTemplatesViewController(_ viewController: HabitTemplatesViewController, didSelect template: HabitTemplate) {
        habitTitleView.titleText = template.title
        dismiss(animated: true)
    }
}
