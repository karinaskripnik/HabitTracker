import UIKit
import UserNotifications

protocol HabitNotificationServiceType {
    func scheduleNotifications(for habit: Habit)
    func cancelNotifications(for habit: Habit)
}

protocol LocalNotificationServiceType {
    func requestAuthorization()
}

final class HabitNotificationService: NSObject {
    private lazy var notificationCenter: UNUserNotificationCenter = {
        let nc = UNUserNotificationCenter.current()
        nc.delegate = self
        return nc
    }()
}

// MARK: - LocalNotificationServiceType

extension HabitNotificationService: LocalNotificationServiceType {
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.badge, .sound, .alert]) { granted, error in
        }
    }
}

// MARK: - HabitNotificationServiceType

extension HabitNotificationService: HabitNotificationServiceType {
    func scheduleNotifications(for habit: Habit) {
        for weekday in habit.reminder.weekdays {
            let content = UNMutableNotificationContent()
            content.title = habit.title
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = habit.reminder.time.hour
            dateComponents.minute = habit.reminder.time.minute
            dateComponents.weekday = weekday.rawValue

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true
            )

            let identifier = [habit.id.uuidString, "\(weekday.rawValue)"]
                .joined(separator: .notificationIDSeparator)

            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )

            notificationCenter.add(request) { error in
                print(error?.localizedDescription ?? "")
            }
        }
    }

    func cancelNotifications(for habit: Habit) {
        var identifiers: [String] = []

        for weekday in habit.reminder.weekdays {
            let identifier = [habit.id.uuidString, "\(weekday.rawValue)"]
                .joined(separator: .notificationIDSeparator)
            identifiers.append(identifier)
        }

        notificationCenter.removePendingNotificationRequests(
            withIdentifiers: identifiers
        )
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension HabitNotificationService: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let vc = UIApplication.shared.windows.first!.rootViewController as! UITabBarController
        vc.selectedIndex = 0
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}

private extension String {
    static let notificationIDSeparator = "!"
}
