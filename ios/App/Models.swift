import Foundation
import CoreLocation
import Photos

struct JourneyMedia: Identifiable, Hashable {
    let id: String                // Local PhotoKit ID: not portable across family devices
    let takenAt: Date
    let isVideo: Bool
    let seconds: Double
    let latitude: Double?
    let longitude: Double?
    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    var dayKey: String { CalendarFormat.key(takenAt) }
    var localTime: String { CalendarFormat.time(takenAt) }
}

struct DiaryEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var day: String
    var title: String = ""
    var notes: String = ""
    var mediaIDs: [String] = []
    var coverID: String? = nil
    var createdAt: Date = Date()
}

struct DayCover: Codable {
    let day: String
    let mediaID: String
}

enum CalendarFormat {
    static let dayFormatter: DateFormatter = {
        let v = DateFormatter(); v.calendar = Calendar(identifier: .gregorian)
        v.locale = Locale(identifier: "en_US_POSIX"); v.timeZone = .current
        v.dateFormat = "yyyy-MM-dd"; return v
    }()
    static func key(_ date: Date) -> String { dayFormatter.string(from: date) }
    static func date(_ key: String) -> Date { dayFormatter.date(from: key) ?? Date() }
    static func monthTitle(_ date: Date) -> String {
        let comps = Calendar.current.dateComponents([.year, .month], from: date)
        return "\(comps.year ?? 2026)년 \(comps.month ?? 1)월"
    }
    static func time(_ d: Date) -> String {
        d.formatted(.dateTime.hour().minute().locale(Locale(identifier: "ko_KR")))
    }
    static func datesInCalendar(_ d: Date) -> [Date] {
        let c = Calendar.current
        let first = c.date(from: c.dateComponents([.year, .month], from: d)) ?? d
        let weekday = c.component(.weekday, from: first) - 1  // Sunday column 0
        let start = c.date(byAdding: .day, value: -weekday, to: first) ?? first
        let count = ((weekday + (c.range(of: .day, in: .month, for: first)?.count ?? 31) + 6) / 7) * 7
        return (0..<count).compactMap { c.date(byAdding: .day, value: $0, to: start) }
    }
}

struct JourneyStop: Identifiable {
    let id: String
    let mediaIDs: [String]
    let latitude: Double
    let longitude: Double
    let firstDate: Date
    var coordinate: CLLocationCoordinate2D { .init(latitude: latitude, longitude: longitude) }
    var count: Int { mediaIDs.count }
}

struct BackupFile: Codable {
    var formatVersion: Int = 1
    var exportedAt: Date = Date()
    var diaries: [DiaryEntry] = []
    var covers: [String: String] = [:]
}