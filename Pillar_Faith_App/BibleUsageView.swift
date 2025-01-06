import SwiftUI

struct BibleUsageView: View {
    @EnvironmentObject var pillarScores: PillarScores
    @Environment(\.presentationMode) var presentationMode // For dismissing the current view
    @AppStorage("selectedPrayerConsistency") private var selectedPrayerConsistency: String = "" // Persist user choice
    @State private var progressValue: CGFloat = 0.33 // Initial progress for this view

    let prayerOptions: [(String, Int)] = [
        ("I rarely pray, but I want to start", 20),
        ("I pray sometimes, but I could be more consistent.", 40),
        ("I pray daily and want to deepen my prayer life.", 55)
    ]

    var body: some View {
        ScrollView { // Added ScrollView for scrollability
            VStack(spacing: 16) {
                // Header Section with Progress Bar
                VStack(alignment: .leading, spacing: 8) {
                    // Back Arrow and Title
                    HStack(spacing: 12) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss() // Go back to the previous screen
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                        }

                        Text("Faith (Prayer)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 16)

                    // Progress Bar
                    ZStack(alignment: .leading) {
                        Capsule()
                            .frame(height: 5)
                            .foregroundColor(.gray.opacity(0.3))
                        Capsule()
                            .frame(width: progressValue * UIScreen.main.bounds.width * 0.75, height: 5)
                            .foregroundColor(.brown)
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 20)

                // Emoji Icon
                Image("faith_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .padding(.top, 8)

                // Main Question
                Text("How consistent are you in daily prayer?")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                // Prayer Options
                VStack(spacing: 12) {
                    ForEach(prayerOptions, id: \.0) { option in
                        Button(action: {
                            selectedPrayerConsistency = option.0 // Persist selection
                            updateFaithScore(score: option.1)
                        }) {
                            Text(option.0)
                                .font(.system(size: 14))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedPrayerConsistency == option.0 ? Color.brown.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedPrayerConsistency == option.0 ? Color.brown : Color.clear, lineWidth: 2)
                                )
                                .foregroundColor(selectedPrayerConsistency == option.0 ? .black : .gray)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity) // Ensure full width

                Spacer(minLength: 40)

                // NavigationLink to WisdomScriptureView
                NavigationLink(destination: WisdomScriptureView().environmentObject(pillarScores)) {
                    Text("Next")
                        .font(.system(size: 16))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
            .onAppear {
                print("Entered BibleUsageView")
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(UIColor.systemBackground))
    }
    
    // Function to Update Faith Score
    private func updateFaithScore(score: Int) {
        if let index = pillarScores.scores.firstIndex(where: { $0.name == "Faith" }) {
            print("Updating score for Faith at index \(index) to \(score).")
            DispatchQueue.main.async {
                self.pillarScores.scores[index].score = Double(score)
            }
        } else {
            print("Error: Faith not found in pillarScores.")
        }
    }
}
