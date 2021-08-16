import Foundation
import UIKit

class ResultViewController: UIViewController {

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(ResultCell.self, forCellReuseIdentifier: ResultCell.reuseIdentifier)
            tableView.tableFooterView = UIView()
        }
    }

    private var allHabits: [Habit] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var habitService: HabitStorageServiceType = HabitService.shared

    override func viewWillAppear(_ animated: Bool ) {
        super.viewWillAppear(animated)

        loadAllHabits()
    }

    private func loadAllHabits() {
        habitService.getAllHabits { [weak self] result in
            DispatchQueue.main.async {switch result {
            case .success(let habits):
                self?.allHabits = habits
            case .failure(let error):
                self?.showAlert(title: "Error", description: error.localizedDescription)            }
            }
        }
    }

    @IBAction private func didTapNewHabbitButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let newHabbitVC = storyboard.instantiateViewController(identifier: "NewHabitViewController") as! NewHabitViewController

        newHabbitVC.delegate = self

        let navigation = UINavigationController(rootViewController: newHabbitVC)

        present(navigation, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allHabits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //napisat sozdanie jacheiki
        let cell = tableView.dequeueReusableCell(withIdentifier: ResultCell.reuseIdentifier, for: indexPath) as! ResultCell
        cell.habbit = allHabits[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let habit = allHabits[indexPath.row]

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [weak self] _, _, completion in

            self?.habitService.removeHabit(habit) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.allHabits.remove(at: indexPath.row)
                        completion(true)
                    case .failure(let error):
                        self?.showAlert(
                            title: "Error",
                            description: error.localizedDescription
                        )
                        completion(false)
                    }
                }
            }
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - NewHabitViewControllerDelegate

extension ResultViewController: NewHabitViewControllerDelegate {
    func newHabitViewControllerDidClose(_ viewController: NewHabitViewController) {
        dismiss(animated: true)
        loadAllHabits()
    }
}
