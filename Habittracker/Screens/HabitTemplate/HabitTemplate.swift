import Foundation

struct HabitTemplate {
    let title: String
    let category: Category
}

extension HabitTemplate {
    static let earlyRise = Self(
        title: "Early rise β°",
        category: .health
    )
    static let earlyBedtime = Self(
        title: "Early bedtime π",
        category: .health
    )
    static let drinkWater = Self(
        title: "Drink water π§",
        category: .health
    )
    static let withoutSweet = Self(
        title: "Without sweet π½",
        category: .health
    )
    static let withoutAlcohol = Self(
        title: "Without alcohol π·",
        category: .health
    )
    static let vitamins = Self(
        title: "Vitamins π",
        category: .health
    )
    static let jogging = Self(
        title: "Jogging πββοΈ",
        category: .sport
    )
    static let yoga = Self(
        title: "Yoga π§ββοΈ",
        category: .sport
    )
    static let training = Self(
        title: "Training ποΈββοΈ",
        category: .sport
    )
    static let stretching = Self(
        title: "Stretching π€ΈββοΈ",
        category: .sport
    )
    static let cycling = Self(
        title: "Cycling π²",
        category: .sport
    )
    static let plank = Self(
        title: "Plank π§ββοΈ",
        category: .sport
    )
    static let reading = Self(
        title: "Reading π",
        category: .development
    )
    static let meditation = Self(
        title: "Meditation π",
        category: .development
    )
    static let english = Self(
        title: "English π",
        category: .development
    )
    static let withoutGadgets = Self(
        title: "Without gadgets π΅",
        category: .development
    )
    static let podcast = Self(
        title: "Podcast π§",
        category: .development
    )
    static let webinar = Self(
        title: "Webinar π©βπ»",
        category: .development
    )
}

extension HabitTemplate {
    enum Category: String, Comparable {
        case health
        case sport
        case development

        static func < (
            lhs: HabitTemplate.Category,
            rhs: HabitTemplate.Category
        ) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }
}

extension HabitTemplate {
    static let all: [Self] =
        [
            .earlyRise,
            .earlyBedtime,
            .drinkWater,
            .withoutSweet,
            .withoutAlcohol,
            .vitamins,
            .jogging,
            .yoga,
            .training,
            .stretching,
            .cycling,
            .plank,
            .reading,
            .meditation,
            .english,
            .withoutGadgets,
            .podcast,
            .webinar
        ]
}
