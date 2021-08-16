import Foundation
import CoreData

@objc(CDHabitAction)
class CDHabitAction: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var date: Date
    @NSManaged var habit: CDHabit
}

extension CDHabitAction {
    convenience init(
        id: UUID,
        date: Date,
        habit: CDHabit,
        context: NSManagedObjectContext
    ) {
        self.init(context: context)

        self.id = id
        self.date = date
        self.habit = habit
    }
}
