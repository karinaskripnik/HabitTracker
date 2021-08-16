import Foundation

struct HabitTemplate {
    let title: String
    let category: Category
}

extension HabitTemplate {
    static let earlyRise = Self(
        title: "Early rise ⏰",
        category: .health
    )
    static let earlyBedtime = Self(
        title: "Early bedtime 🌙",
        category: .health
    )
    static let drinkWater = Self(
        title: "Drink water 💧",
        category: .health
    )
    static let withoutSweet = Self(
        title: "Without sweet 🐽",
        category: .health
    )
    static let withoutAlcohol = Self(
        title: "Without alcohol 🍷",
        category: .health
    )
    static let vitamins = Self(
        title: "Vitamins 💊",
        category: .health
    )
    static let jogging = Self(
        title: "Jogging 🏃‍♀️",
        category: .sport
    )
    static let yoga = Self(
        title: "Yoga 🧘‍♀️",
        category: .sport
    )
    static let training = Self(
        title: "Training 🏋️‍♀️",
        category: .sport
    )
    static let stretching = Self(
        title: "Stretching 🤸‍♀️",
        category: .sport
    )
    static let cycling = Self(
        title: "Cycling 🚲",
        category: .sport
    )
    static let plank = Self(
        title: "Plank 🧍‍♀️",
        category: .sport
    )
    static let reading = Self(
        title: "Reading 📖",
        category: .development
    )
    static let meditation = Self(
        title: "Meditation 🙏",
        category: .development
    )
    static let english = Self(
        title: "English 📒",
        category: .development
    )
    static let withoutGadgets = Self(
        title: "Without gadgets 📵",
        category: .development
    )
    static let podcast = Self(
        title: "Podcast 🎧",
        category: .development
    )
    static let webinar = Self(
        title: "Webinar 👩‍💻",
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
