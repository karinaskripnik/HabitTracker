import Foundation

struct Habit {
    let id: UUID
    let title: String
    let reminder: Reminder
    let completedDates: [Date]

    var isDoneToday: Bool {
        completedDates.contains { date in
            Calendar.current.isDateInToday(date)
        }
    }

    init(
        id: UUID,
        title: String,
        reminder: Reminder,
        completedDates: [Date] = []
    ) {
        self.id = id
        self.title = title
        self.reminder = reminder
        self.completedDates = completedDates
    }
}

extension Habit {
    struct Reminder {
        let weekdays: Set<Weekday>
        let time: Time
    }
}

extension Habit {
    enum Weekday: Int, Hashable, CaseIterable {
        case sunday = 1
        case monday
        case thuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }
}

extension Habit.Reminder {
    struct Time {
        let hour: Int
        let minute: Int
    }
}
