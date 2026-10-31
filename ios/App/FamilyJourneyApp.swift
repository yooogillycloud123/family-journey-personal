import SwiftUI

@main
struct FamilyJourneyApp: App {
    @StateObject private var library = MediaLibrary()
    @StateObject private var diary = DiaryStore()

    var body: some Scene {
        WindowGroup {
            MainTabs()
                .environmentObject(library)
                .environmentObject(diary)
                .tint(Color(red: 0.22, green: 0.48, blue: 0.94))
                .task { library.requestAndScan() }
        }
    }
}