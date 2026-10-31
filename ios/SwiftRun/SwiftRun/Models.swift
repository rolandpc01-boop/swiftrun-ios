import SwiftUI

struct DeliveryZone: Identifiable {
    let id: String
    let name: String
    let detail: String
    let availability: String
    let icon: String
    let accent: Color
    let markerAlignment: Alignment
    let activeRiders: Int

    var chartSeriesName: String {
        switch id {
        case "downtown":
            return "Downtown"
        case "suburbs":
            return "Suburbs"
        default:
            return "Industrial"
        }
    }

    static let downtown = DeliveryZone(
        id: "downtown",
        name: "Downtown Core",
        detail: "Average delivery in 12–15 minutes.",
        availability: "24/7 operations",
        icon: "building.2.fill",
        accent: SwiftRunTheme.aqua,
        markerAlignment: .center,
        activeRiders: 142
    )

    static let suburbs = DeliveryZone(
        id: "suburbs",
        name: "North & West Suburbs",
        detail: "Average delivery in 20–25 minutes.",
        availability: "7:00 AM – Midnight",
        icon: "tree.fill",
        accent: SwiftRunTheme.green,
        markerAlignment: .topLeading,
        activeRiders: 53
    )

    static let industrial = DeliveryZone(
        id: "industrial",
        name: "Industrial Districts",
        detail: "Dedicated cargo and bulk delivery routes.",
        availability: "Scheduled daily",
        icon: "shippingbox.fill",
        accent: SwiftRunTheme.orange,
        markerAlignment: .bottomTrailing,
        activeRiders: 21
    )

    static let all = [downtown, suburbs, industrial]
}

struct RiderPoint: Identifiable {
    let id = UUID()
    let time: String
    let riders: Int
}

struct RiderSeries: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let points: [RiderPoint]

    static let samples: [RiderSeries] = [
        RiderSeries(
            name: "Downtown",
            color: SwiftRunTheme.aqua,
            points: zip(["13:40", "13:50", "14:00", "14:10", "14:20", "14:30", "14:40", "14:50"], [135, 138, 142, 140, 145, 148, 144, 142]).map { RiderPoint(time: $0.0, riders: $0.1) }
        ),
        RiderSeries(
            name: "Suburbs",
            color: SwiftRunTheme.green,
            points: zip(["13:40", "13:50", "14:00", "14:10", "14:20", "14:30", "14:40", "14:50"], [48, 52, 50, 53, 56, 54, 55, 53]).map { RiderPoint(time: $0.0, riders: $0.1) }
        ),
        RiderSeries(
            name: "Industrial",
            color: SwiftRunTheme.orange,
            points: zip(["13:40", "13:50", "14:00", "14:10", "14:20", "14:30", "14:40", "14:50"], [18, 20, 22, 21, 19, 23, 22, 21]).map { RiderPoint(time: $0.0, riders: $0.1) }
        )
    ]
}
