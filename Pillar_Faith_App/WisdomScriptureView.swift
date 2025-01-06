import SwiftUI

struct WisdomScriptureView: View {
    @EnvironmentObject var pillarScores: PillarScores
    @Environment(\.presentationMode) var presentationMode // For dismissing the current view
    @AppStorage("selectedBibleUsage") private var selectedBibleUsage: String = "" // Persist user choice
    @State private var progressValue: CGFloat = 0.5 // Updated progress for this view

    let usageOptions: [(String, Int)] = [
        ("I read it occasionally, but I’m not consistent.", 20),
        ("I read the Bible weekly and reflect on its meaning.", 40),
        ("I study the Bible daily and enjoy deepening my understanding.", 55)
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

                        Text("Wisdom (Scripture)")
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
                Image("book_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .padding(.top, 8)

                // Main Question
                Text("How often do you read or study the Bible?")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                // Usage Options
                VStack(spacing: 12) {
                    ForEach(usageOptions, id: \.0) { option in
                        Button(action: {
                            selectedBibleUsage = option.0 // Persist selection
                            updateWisdomScore(score: option.1)
                        }) {
                            Text(option.0)
                                .font(.system(size: 14))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedBibleUsage == option.0 ? Color.brown.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedBibleUsage == option.0 ? Color.brown : Color.clear, lineWidth: 2)
                                )
                                .foregroundColor(selectedBibleUsage == option.0 ? .black : .gray)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity) // Ensure full width

                Spacer(minLength: 40)

                // NavigationLink to CommunityWorshipView
                NavigationLink(destination: CommunityWorshipView().environmentObject(pillarScores)) {
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
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(UIColor.systemBackground))
    }
    
    // Function to Update Score
    private func updateWisdomScore(score: Int) {
        if let index = pillarScores.scores.firstIndex(where: { $0.name == "Wisdom" }) {
            pillarScores.scores[index].score = Double(score)
        }
    }
}
