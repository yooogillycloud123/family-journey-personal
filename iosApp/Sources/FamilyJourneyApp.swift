import SwiftUI

@main
struct FamilyJourneyApp: App {
    @StateObject private var store = FamilyStore()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(store)
                .task { await store.refreshLibrary() }
        }
    }
}
