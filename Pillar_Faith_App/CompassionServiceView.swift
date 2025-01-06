import SwiftUI

struct CompassionServiceView: View {
    @EnvironmentObject var pillarScores: PillarScores
    @Environment(\.presentationMode) var presentationMode // For dismissing the current view
    @AppStorage("selectedCompassionFrequency") private var selectedCompassionFrequency: String = "" // Persist user choice
    @State private var progressValue: CGFloat = 0.83 // Updated progress for this view

    let compassionOptions: [(String, Int)] = [
        ("I rarely serve others but want to start small.", 20), 
        ("I try to serve and help others a few times a week.", 40),
        ("I regularly dedicate time to serving others with purpose.", 55)
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

                        Text("Compassion (Service and Kindness)")
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
                Image("church_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .padding(.top, 8)

                // Main Question
                Text("How often do you perform acts of kindness or serve others?")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                // Compassion Options
                VStack(spacing: 12) {
                    ForEach(compassionOptions, id: \.0) { option in
                        Button(action: {
                            selectedCompassionFrequency = option.0 // Persist selection
                            updateCompassionScore(score: option.1)
                        }) {
                            Text(option.0)
                                .font(.system(size: 14))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedCompassionFrequency == option.0 ? Color.brown.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedCompassionFrequency == option.0 ? Color.brown : Color.clear, lineWidth: 2)
                                )
                                .foregroundColor(selectedCompassionFrequency == option.0 ? .black : .gray)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)

                Spacer(minLength: 40)

                // NavigationLink to GratitudeView
                NavigationLink(destination: PresenceReflectionView().environmentObject(pillarScores)) {
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
    private func updateCompassionScore(score: Int) {
        if let index = pillarScores.scores.firstIndex(where: { $0.name == "Compassion" }) {
            pillarScores.scores[index].score = Double(score)
        }
    }
}
