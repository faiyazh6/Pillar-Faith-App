import SwiftUI

struct BibleView: View {
    @Binding var selectedTab: Tab
    @State private var selectedStory: BibleStory? // Tracks the selected story for navigation
    @State private var isNavigating: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // Content Section
            ScrollView {
                VStack(spacing: 16) {
                    // Greeting
                    HStack {
                        Text("Hello! Samuel")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        HStack(spacing: 12) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                            Text("2")
                            Image(systemName: "person.circle")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)

                    // Pillars of Christianity Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pillars of Christianity")
                            .font(.headline)
                            .padding(.horizontal)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(pillarsOfChristianity, id: \.self) { pillar in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 100)
                                    Text(pillar.name)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Bible Stories Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bible Stories")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(bibleStories) { story in
                            Button(action: {
                                selectedStory = story
                                isNavigating = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 100)
                                    VStack {
                                        Text(story.title)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text(story.subtitle)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.top, 16)
            }
            .background(
                NavigationLink(
                    destination: BibleStoryDetailView(story: selectedStory ?? bibleStories[0]),
                    isActive: $isNavigating,
                    label: { EmptyView() }
                )
            )

            // Task Manager at the Bottom
            TaskManagerView(selectedTab: $selectedTab)
                .background(Color.white.shadow(radius: 5))
        }
        .navigationTitle("Bible")
        .navigationBarHidden(true) // Hide the navigation bar
    }
}

// Placeholder models and data
struct BiblePillar: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
}

let pillarsOfChristianity = [
    BiblePillar(name: "Faith", imageName: "faith"),
    BiblePillar(name: "Wisdom", imageName: "wisdom"),
    BiblePillar(name: "Community", imageName: "community"),
    BiblePillar(name: "Presence", imageName: "presence"),
    BiblePillar(name: "Compassion", imageName: "compassion"),
    BiblePillar(name: "Thankful", imageName: "thankful")
]

struct BibleStory: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let content: String
}

let bibleStories = [
    BibleStory(
        title: "David and Goliath",
        subtitle: "A story of faith and courage.",
        imageName: "david_goliath",
        content: """
        The Philistines, led by the giant Goliath, challenged the Israelites to a one-on-one duel...
        """
    ),
    BibleStory(
        title: "Crossing of the Red Sea",
        subtitle: "Moses leads the Israelites.",
        imageName: "red_sea",
        content: """
        Moses stretched out his hand over the sea, and the Lord drove the sea back by a strong east wind all night...
        """
    ),
    BibleStory(
        title: "Adam and Eve",
        subtitle: "The story of creation.",
        imageName: "adam_eve",
        content: """
        In the beginning, God created the heavens and the earth...
        """
    )
]
