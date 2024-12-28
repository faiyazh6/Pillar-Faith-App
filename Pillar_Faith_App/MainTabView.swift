import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home // Use the globally defined Tab enum

    var body: some View {
        VStack(spacing: 0) {
            // Main Content Changes Based on Selected Tab
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .aiPriest:
                    AIPriestView(selectedTab: $selectedTab)
                case .abilities:
                    Text("Abilities View") // Replace with actual abilities view
                case .bible:
                    Text("Bible View") // Replace with actual Bible view
                case .journal:
                    Text("Journal View") // Replace with actual journal view
                }
            }

            // Task Manager View at the Bottom
            TaskManagerView(selectedTab: $selectedTab)
        }
        .edgesIgnoringSafeArea(.bottom) // Ensure the bottom Task Manager stays visible
    }
}

// Tab Enum to Define Tabs
enum Tab: CaseIterable {
    case home, aiPriest, abilities, bible, journal

    var title: String {
        switch self {
        case .home: return "Home"
        case .aiPriest: return "AI Priest"
        case .abilities: return "Abilities"
        case .bible: return "Bible"
        case .journal: return "Journal"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .aiPriest: return "wand.and.stars"
        case .abilities: return "heart.fill"
        case .bible: return "book.fill"
        case .journal: return "book.closed.fill"
        }
    }
}
