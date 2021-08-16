import Foundation
import UIKit

final class HabitService {
    let storageService: HabitStorageServiceType
    let notificationService: LocalNotificationServiceType & HabitNotificationServiceType

    static let shared = HabitService()
    private init() {
        self.storageService = HabitStorageService()
        self.notificationService = HabitNotificationService()
    }
}

// MARK: - HabitStorageServiceType

extension HabitService: HabitStorageServiceType {
    func removeHabit(
        _ habit: Habit,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        storageService.removeHabit(habit) { result in
            if case .success = result {
                self.notificationService.cancelNotifications(for: habit)
            }
            completion(result)
        }
    }

    func toggleHabit(with id: UUID, completion: @escaping (Result<Habit, Error>) -> Void) {
        storageService.toggleHabit(with: id, completion: completion)
    }

    func getTodayHabits(completion: @escaping (Result<[Habit], Error>) -> Void) {
        storageService.getTodayHabits(completion: completion)
    }

    func getAllHabits(completion: @escaping (Result<[Habit], Error>) -> Void) {
        storageService.getAllHabits(completion: completion)
    }
    
    func save(
        _ habit: Habit,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        storageService.save(habit) { result in
            if case .success = result {
                self.notificationService.scheduleNotifications(for: habit)
            }
            completion(result)
        }
    }
}
