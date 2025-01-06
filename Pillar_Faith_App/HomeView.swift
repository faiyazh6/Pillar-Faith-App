import SwiftUI

struct HomeView: View {
    @State private var selectedTab: Tab = .home // Default to Home tab
    @AppStorage("currentUser") private var currentUser: String = "" // Retrieve logged-in user
    @State private var showLogoutAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Header Section
                HStack {
                    Image(systemName: "hand.wave") // Hand icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                    Text("Hello, \(currentUser)!")
                        .font(.system(size: 24, weight: .bold))

                    Spacer()

                    // Profile button (optional functionality)
                    Button(action: {
                        // Add action for profile settings
                    }) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .alert(isPresented: $showLogoutAlert) {
                        Alert(
                            title: Text("Logout"),
                            message: Text("Are you sure you want to log out?"),
                            primaryButton: .destructive(Text("Logout")) {
                                currentUser = ""
                                selectedTab = .home // Reset to home
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // Scrollable Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Statistics Section
                        HStack {
                            VStack {
                                Text("2")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.brown)

                                Text("Day Streak")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            VStack {
                                Text("93.09%")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.brown)

                                Text("Pillar Score")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))

                        // Recent Tasks Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Tasks")
                                .font(.system(size: 16, weight: .semibold))

                            ForEach(Task.sampleTasks) { task in
                                HStack {
                                    Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.completed ? .green : .gray)

                                    VStack(alignment: .leading) {
                                        Text(task.title)
                                            .font(.system(size: 14))
                                        HStack {
                                            Text(task.category)
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                            Text("\(task.duration) mins")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        }
                                    }

                                    Spacer()

                                    Button(action: {
                                        // Add task start functionality
                                    }) {
                                        Text(task.completed ? "Done" : "Start")
                                            .font(.system(size: 14))
                                            .padding(8)
                                            .background(task.completed ? Color.green.opacity(0.2) : Color.brown)
                                            .cornerRadius(8)
                                            .foregroundColor(task.completed ? .green : .white)
                                    }
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                // Tab Bar
                HStack {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Button(action: {
                            selectedTab = tab
                        }) {
                            VStack {
                                Image(systemName: tab.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(selectedTab == tab ? .brown : .gray)

                                Text(tab.title)
                                    .font(.system(size: 12))
                                    .foregroundColor(selectedTab == tab ? .brown : .gray)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 4)
            }
            .background(
                NavigationLink(
                    destination: getViewForTab(selectedTab),
                    isActive: .constant(selectedTab != .home),
                    label: { EmptyView() }
                )
            )
            .navigationBarBackButtonHidden(true)
        }
    }

    // Get the destination view for the selected tab
    private func getViewForTab(_ tab: Tab) -> some View {
        switch tab {
        case .home:
            return AnyView(HomeView())
        case .aiPriest:
            return AnyView(AIPriestView(selectedTab: $selectedTab))
        case .abilities:
            return AnyView(Text("Abilities View")) // Replace with actual abilities view
        case .bible:
            return AnyView(BibleView(selectedTab: $selectedTab)) // Replace with actual Bible view
        case .journal:
            return AnyView(JournalView(selectedTab: $selectedTab)) // Replace with actual journal view
        }
    }
}

// Sample Task Data
struct Task: Identifiable {
    let id = UUID()
    let title: String
    let category: String
    let duration: Int
    let completed: Bool

    static let sampleTasks: [Task] = [
        Task(title: "Get Q2 reports done", category: "career", duration: 25, completed: true),
        Task(title: "Meditation", category: "spirituality", duration: 25, completed: false),
        Task(title: "Morning Grind", category: "strength", duration: 25, completed: false)
    ]
}
