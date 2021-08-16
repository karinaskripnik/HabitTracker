import Foundation
import UIKit

protocol HabitTemplatesViewControllerDelegate: AnyObject {
    func habitTemplatesViewController(_ viewController: HabitTemplatesViewController, didSelect template: HabitTemplate)

    func habitTemplatesViewControllerDidClose(_ viewController: HabitTemplatesViewController)
}

final class HabitTemplatesViewController: UIViewController {
    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(HabitTemplateCell.self, forCellReuseIdentifier: HabitTemplateCell.reuseIdentifier)
        }
    }

    private var templates: [HabitTemplate.Category: [HabitTemplate]] = [:] {
        didSet {
            tableView.reloadData()
        }
    }

    private var sortedCategories: [HabitTemplate.Category] {
        return templates.keys.sorted()
    }

    weak var delegate: HabitTemplatesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        templates = .init(grouping: HabitTemplate.all) { $0.category }
    }

    @IBAction private func didTapCloseButton(_ sender: UIBarButtonItem) {
        delegate?.habitTemplatesViewControllerDidClose(self)
    }

    private func template(at indexPath: IndexPath) -> HabitTemplate? {
        templates[sortedCategories[indexPath.section]]?[indexPath.row]
    }
}

extension HabitTemplatesViewController: UITableViewDataSource {
    func numberOfSections(in: UITableView) -> Int {
        return templates.keys.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sortedCategories[section].rawValue
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates[sortedCategories[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitTemplateCell.reuseIdentifier, for: indexPath) as! HabitTemplateCell
        cell.template = template(at: indexPath)
        return cell
    }
}

extension HabitTemplatesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let template = template(at: indexPath) else {
            return
        }
        delegate?.habitTemplatesViewController(self, didSelect: template)
    }
}
