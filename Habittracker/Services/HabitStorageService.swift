import CoreData

protocol HabitStorageServiceType {
    func save(_ habit: Habit, completion: @escaping (Result<Void, Error>) -> Void)

    func getAllHabits(completion: @escaping (Result<[Habit], Error>) -> Void)

    func getTodayHabits(completion: @escaping (Result<[Habit], Error>) -> Void)

    func toggleHabit(with id: UUID, completion: @escaping (Result<Habit, Error>) -> Void)

    func removeHabit( _ habit: Habit, completion: @escaping (Result<Void, Error>) -> Void)
}

final class HabitStorageService: HabitStorageServiceType {
    private var allHabits: [Habit] = []

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var context = persistentContainer.newBackgroundContext()

    func getAllHabits(completion: @escaping (Result<[Habit], Error>) -> Void) {
        //0.switch to context thread
        context.perform {
            //1.create fetch request
            let request = NSFetchRequest<CDHabit>(entityName: "CDHabit")
            request.sortDescriptors = [
                .init(key: "id", ascending: true)
            ]
            do {
                //2.perform fetch request
                let results = try self.context.fetch(request)
                //3.convert dbhabit -> habit
                let allHabits = results.map { $0.habit }
                //4.call completion [habit]
                completion(.success(allHabits))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func getTodayHabits(completion: @escaping (Result<[Habit], Error>) -> Void) {
        guard
            let weekday = Calendar
                .current
                .dateComponents([.weekday], from: Date())
                .weekday,
            let currentWeekday = Habit.Weekday(rawValue: weekday)
        else {
            completion(.failure(HabitStorageError.unexpected(description: "Weekday does not exist")))
            return
        }
        getAllHabits { result in
            if case .success(let allHabits) = result {
                let todayHabits = allHabits.filter { habit in
                    habit.reminder.weekdays.contains(currentWeekday)
                }
                completion(.success(todayHabits))
            }
            else {
                completion(result)
            }
        }
    }

    func save(_ habit: Habit, completion: @escaping (Result<Void, Error>) -> Void) {
        //0. switch to context thread
        context.perform {
            do {
                //1.create CDHabit
                let cdHabit = CDHabit(habit: habit, context: self.context)
                //2.save context
                self.context.insert(cdHabit)
                try self.context.save()
                //3.call completion
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func toggleHabit(
        with id: UUID,
        completion: @escaping (Result<Habit, Error>) -> Void
    ) {
        getHabit(id: id) { result in
            switch result {
            case .success(let cdHabit):
                // 1. update habit
                if let todayAction = cdHabit.actions.first(
                    where: { Calendar.current.isDateInToday($0.date) }
                ) {
                    self.context.delete(todayAction)
                } else {
                    let todayAction = CDHabitAction(
                        id: .init(),
                        date: Date(),
                        habit: cdHabit,
                        context: self.context
                    )
                    self.context.insert(todayAction)
                }
                
                do {
                    // 2. save context
                    try self.context.save()
                    // 3. call completion
                    completion(.success(cdHabit.habit))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func removeHabit(
        _ habit: Habit,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        getHabit(id: habit.id) { result in
            switch result {
            case .success(let habit):
                self.context.delete(habit)
                do {
                    try self.context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func getHabit(
        id: UUID,
        completion: @escaping (Result<CDHabit, Error>) -> Void
    ) {
        context.perform {
            let request = NSFetchRequest<CDHabit>(entityName: "CDHabit")
            request.predicate = NSPredicate(format: "%K == %@", #keyPath(CDHabit.id), id as CVarArg)

            do {
                let results = try self.context.fetch(request)

                guard let cdHabit = results.first else {
                    completion(.failure((HabitStorageError.habitDoesNotExist(id: id))))
                    return
                }
                completion(.success(cdHabit))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

enum HabitStorageError: Error {
    case unexpected(description: String)
    case habitDoesNotExist(id: UUID)
}
