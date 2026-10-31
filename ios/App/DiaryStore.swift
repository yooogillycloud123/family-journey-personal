import Foundation
import SwiftUI
import UniformTypeIdentifiers

@MainActor
final class DiaryStore: ObservableObject {
    @Published var entries: [DiaryEntry] = []
    @Published var covers: [String: String] = [:]

    private var location: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("family-journey-diaries-v1.json")
    }
    init() { load() }
    func load() {
        guard let data = try? Data(contentsOf: location),
              let doc = try? JSONDecoder().decode(BackupFile.self, from: data) else { return }
        entries = doc.diaries; covers = doc.covers
    }
    private func persist() {
        let snapshot = BackupFile(diaries: entries, covers: covers)
        guard let json = try? JSONEncoder().encode(snapshot) else { return }
        try? json.write(to: location, options: .atomic)
    }
    func entriesOn(_ day: String) -> [DiaryEntry] { entries.filter { $0.day == day }.sorted { $0.createdAt < $1.createdAt } }
    func upsert(_ entry: DiaryEntry) {
        if let idx = entries.firstIndex(where: { $0.id == entry.id }) { entries[idx] = entry }
        else { entries.append(entry) }
        persist()
    }
    func delete(_ entry: DiaryEntry) { entries.removeAll { $0.id == entry.id }; persist() }
    func cover(for day: String, automatic: Bool, defaultID: String?) -> String? {
        if automatic { return covers["auto:\(day)"] ?? defaultID }
        return covers["manual:\(day)"] ?? defaultID
    }
    func setCover(_ id: String, for day: String, automatic: Bool) {
        covers["\(automatic ? "auto" : "manual"):\(day)"] = id; persist()
    }
    func backupURL() -> URL? {
        let file = FileManager.default.temporaryDirectory.appendingPathComponent("FamilyJourney-일기-백업-\(UUID().uuidString).json")
        let data = try? JSONEncoder().encode(BackupFile(diaries: entries, covers: covers))
        guard let data = data else { return nil }
        do { try data.write(to: file, options: .atomic); return file } catch { return nil }
    }
    func restore(from url: URL) -> Bool {
        let allowed = url.startAccessingSecurityScopedResource()
        defer { if allowed { url.stopAccessingSecurityScopedResource() } }
        guard let data = try? Data(contentsOf: url),
              let result = try? JSONDecoder().decode(BackupFile.self, from: data),
              result.formatVersion == 1 else { return false }
        // Import only diary metadata. Different phones have different PhotoKit local IDs.
        for item in result.diaries where !entries.contains(where: { $0.id == item.id }) { entries.append(item) }
        for (k, v) in result.covers where covers[k] == nil { covers[k] = v }
        persist(); return true
    }
}