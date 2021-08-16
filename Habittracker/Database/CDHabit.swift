import Foundation
import CoreData

@objc(CDHabit)
class CDHabit: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var weekdays: [Int64]
    @NSManaged var hour: Int64
    @NSManaged var minute: Int64
    @NSManaged var actions: Set<CDHabitAction>
}

extension CDHabit {
    convenience init(
        habit: Habit,
        context: NSManagedObjectContext
    ) {
        self.init(context: context)
        
        self.id = habit.id
        self.title = habit.title
        self.weekdays = habit.reminder.weekdays.map {
            Int64($0.rawValue)
        }
        self.hour = Int64(habit.reminder.time.hour)
        self.minute = Int64(habit.reminder.time.minute)
        self.actions = []
    }

    var habit: Habit {
        Habit(
            id: id,
            title: title,
            reminder: .init(
                weekdays: Set(
                    weekdays.compactMap {
                        Habit.Weekday(rawValue: Int($0))
                    }
                ),
                time: .init(
                    hour: Int(hour),
                    minute: Int(minute)
                )
            ),
            completedDates: actions.map { $0.date }
        )
    }
}
