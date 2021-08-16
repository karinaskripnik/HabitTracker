import Foundation
import UIKit

final class TodayViewController: UIViewController {

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.register(TodayCell.self, forCellReuseIdentifier: TodayCell.reuseIdentifier)
            tableView.tableFooterView = UIView()
        }
    }

    private var todayHabits: [Habit] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var habitService: HabitStorageServiceType = HabitService.shared

    override func viewWillAppear(_ animated: Bool ) {
        super.viewWillAppear(animated)

        loadTodayHabits()
    }

    private func loadTodayHabits() {
        habitService.getTodayHabits { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let habits):
                    self?.todayHabits = habits
                case .failure(let error):
                    self?.showAlert(title: "Error", description: error.localizedDescription)
                }
            }
        }
    }

    private func toggleHabit(at indexPath: IndexPath) {
        habitService.toggleHabit(with: todayHabits[indexPath.row].id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let habit):
                    self?.todayHabits[indexPath.row] = habit
                case .failure(let error):
                    self?.showAlert(title: "Error", description: error.localizedDescription)
                }
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

extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todayHabits.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodayCell.reuseIdentifier, for: indexPath) as! TodayCell
        cell.habbit = todayHabits[indexPath.row]
        cell.didToggleHabit = { [weak self] in
            self?.toggleHabit(at: indexPath)
        }
        return cell
    }
}

// MARK: - NewHabitViewControllerDelegate

extension TodayViewController: NewHabitViewControllerDelegate {
    func newHabitViewControllerDidClose(_ viewController: NewHabitViewController) {
        dismiss(animated: true)
        loadTodayHabits()
    }
}
