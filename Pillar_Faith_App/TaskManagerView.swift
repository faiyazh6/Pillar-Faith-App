import SwiftUI

struct TaskManagerView: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack {
            TaskManagerButton(tab: .home, selectedTab: $selectedTab, label: "Home", systemImage: "house.fill")
            TaskManagerButton(tab: .aiPriest, selectedTab: $selectedTab, label: "AI Priest", systemImage: "wand.and.stars")
            TaskManagerButton(tab: .abilities, selectedTab: $selectedTab, label: "Abilities", systemImage: "heart.fill")
            TaskManagerButton(tab: .bible, selectedTab: $selectedTab, label: "Bible", systemImage: "book.fill")
            TaskManagerButton(tab: .journal, selectedTab: $selectedTab, label: "Journal", systemImage: "book.closed.fill")
        }
        .padding()
        .background(Color.white.shadow(radius: 5))
    }
}

struct TaskManagerButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    let label: String
    let systemImage: String

    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(selectedTab == tab ? .brown : .gray)

                Text(label)
                    .font(.caption)
                    .foregroundColor(selectedTab == tab ? .brown : .gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
