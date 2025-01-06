import SwiftUI

struct JournalView: View {
    @Binding var selectedTab: Tab
    @State private var isMoodSelectionActive: Bool = false
    @State private var isWritingActive: Bool = false
    @State private var selectedMood: Mood? = nil
    @State private var journalEntry: String = ""
    @State private var showConfirmation: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            if !isMoodSelectionActive && !isWritingActive {
                // Main Journal Page
                VStack {
                    // Custom Navigation Header
                    HStack(spacing: 16) {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundColor(.black)
                        
                        Spacer()

                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.trailing, 16)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)

                    // Main Content
                    ScrollView {
                        VStack(alignment: .center, spacing: 16) {
                            // Date and Greeting
                            Text("TUESDAY, DEC 24")
                                .font(.subheadline)
                                .foregroundColor(.gray)

                            Text("Hello, Dear Benjamin!")
                                .font(.title2)
                                .fontWeight(.bold)

                            // Daily Quote Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Daily Quotes")
                                    .font(.headline)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.brown.opacity(0.2))
                                        .frame(height: 100)
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Gratitude... encourages the development of other virtues such as patience, humility, and wisdom")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                            Text("ALLEN, S. (2018)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Image(systemName: "hands.clap")
                                            .font(.title)
                                            .foregroundColor(.brown)
                                    }
                                    .padding()
                                }
                            }
                            .padding(.horizontal)

                            // Start Journal Button
                            Button(action: {
                                isMoodSelectionActive = true
                            }) {
                                Text("Start Today's Journal")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.brown)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            }

                            // Recents Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Recents")
                                    .font(.headline)
                                    .padding(.horizontal)

                                VStack(spacing: 16) {
                                    ForEach(monthlyEntries, id: \.month) { group in
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(group.month)
                                                .font(.headline)
                                                .padding(.horizontal)
                                            
                                            ForEach(group.entries, id: \.self) { entry in
                                                RecentEntryView(entry: entry)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Task Manager
                    TaskManagerView(selectedTab: $selectedTab)
                }
            } else if isMoodSelectionActive {
                // Mood Selection Screen
                MoodSelectionView(isMoodSelectionActive: $isMoodSelectionActive, isWritingActive: $isWritingActive)
            } else if isWritingActive {
                // Writing Screen
                WritingView(isWritingActive: $isWritingActive, selectedTab: $selectedTab)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarHidden(true)
    }
}

struct MoodSelectionView: View {
    @Binding var isMoodSelectionActive: Bool
    @Binding var isWritingActive: Bool

    var body: some View {
        VStack(spacing: 16) {
            // Progress Bar
            HStack {
                Rectangle()
                    .fill(Color.brown)
                    .frame(height: 4)
                    .cornerRadius(2)
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 4)
                    .cornerRadius(2)
            }
            .padding(.horizontal)

            // Greeting and Question
            VStack(spacing: 8) {
                Text("Dear Benjamin!")
                    .font(.headline)

                Text("How do you feel this morning?")
                    .font(.title2)
                    .fontWeight(.bold)
            }

            // Mood Icons
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                MoodButton(iconName: "sad_icon", mood: "Sad") {
                    isMoodSelectionActive = false
                    isWritingActive = true
                }
                MoodButton(iconName: "angry_icon", mood: "Angry") {
                    isMoodSelectionActive = false
                    isWritingActive = true
                }
                MoodButton(iconName: "happy_icon", mood: "Happy") {
                    isMoodSelectionActive = false
                    isWritingActive = true
                }
                MoodButton(iconName: "great_icon", mood: "Great!") {
                    isMoodSelectionActive = false
                    isWritingActive = true
                }
            }

            Spacer()

            // Next Button
            Button(action: {
                isMoodSelectionActive = false // Placeholder
                isWritingActive = true
            }) {
                Image(systemName: "arrow.right.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.brown)
            }
            .padding(.bottom, 40)
        }
        .padding(.vertical)
    }
}

struct MoodButton: View {
    let iconName: String
    let mood: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                Text(mood)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .frame(width: 120, height: 120)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
        }
    }
}

// Component for a Single Recent Entry
struct RecentEntryView: View {
    let entry: JournalEntry

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack {
                Text(entry.day)
                    .font(.headline)
                    .foregroundColor(.brown)
                Text(entry.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(width: 60)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text("What I was grateful for")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(entry.content)
                    .font(.body)
            }

            Spacer()
        }
        .padding(.horizontal)
    }
}

// Sample Recent Entries and Moods
struct JournalEntry: Hashable {
    let day: String
    let date: String
    let content: String
}

struct MonthlyEntryGroup {
    let month: String
    let entries: [JournalEntry]
}

let monthlyEntries: [MonthlyEntryGroup] = [
    MonthlyEntryGroup(month: "March 2024", entries: [
        JournalEntry(day: "FRI", date: "12", content: "Sound Health"),
        JournalEntry(day: "SUN", date: "31", content: "Comfort of home")
    ]),
    MonthlyEntryGroup(month: "February 2024", entries: [
        JournalEntry(day: "MON", date: "07", content: "Good friends")
    ])
]

enum Mood: String, CaseIterable {
    case sad = "Sad"
    case angry = "Angry"
    case happy = "Happy"
    case great = "Great"

    var imageName: String {
        switch self {
        case .sad: return "face.dashed"
        case .angry: return "flame"
        case .happy: return "smiley"
        case .great: return "star.circle"
        }
    }
}

struct WritingView: View {
    @Binding var isWritingActive: Bool
    @Binding var selectedTab: Tab
    @State private var journalEntry: String = ""
    @State private var showConfirmation: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar
            HStack {
                Rectangle()
                    .fill(Color.brown)
                    .frame(height: 4)
                    .cornerRadius(2)
                Rectangle()
                    .fill(Color.brown)
                    .frame(height: 4)
                    .cornerRadius(2)
            }
            .padding(.horizontal)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Writing Prompt
                    Text("Use this space to describe your mood and what you are feeling grateful for.")
                        .font(.headline)
                        .padding()

                    // Text Editor
                    TextEditor(text: $journalEntry)
                        .frame(height: 200)
                        .border(Color.gray, width: 1)
                        .cornerRadius(8)
                        .padding(.horizontal)

                    // Add Attachments Section
                    HStack(spacing: 32) {
                        AttachmentButton(iconName: "camera", label: "Take a Photo") {
                            // Handle camera action
                        }

                        AttachmentButton(iconName: "video", label: "Record a Video") {
                            // Handle video recording action
                        }

                        AttachmentButton(iconName: "photo.on.rectangle.angled", label: "Open Gallery") {
                            // Handle gallery access action
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }

            Spacer()

            // Done Button
            Button(action: {
                showConfirmation = true
            }) {
                HStack {
                    Spacer()
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color.brown)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .alert(isPresented: $showConfirmation) {
                Alert(
                    title: Text("Journal Saved"),
                    message: Text("Your journal entry has been saved."),
                    dismissButton: .default(Text("OK"), action: {
                        isWritingActive = false
                        selectedTab = .journal // Return to home after saving
                    })
                )
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct AttachmentButton: View {
    let iconName: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: iconName)
                    .font(.largeTitle)
                    .foregroundColor(.brown)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
