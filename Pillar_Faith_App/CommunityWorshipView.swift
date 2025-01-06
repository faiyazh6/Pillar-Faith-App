import SwiftUI

struct CommunityWorshipView: View {
    @EnvironmentObject var pillarScores: PillarScores
    @Environment(\.presentationMode) var presentationMode // For dismissing the current view
    @AppStorage("selectedCommunityInvolvement") private var selectedCommunityInvolvement: String = "" // Persist user choice
    @State private var progressValue: CGFloat = 0.66 // Updated progress for this view

    let involvementOptions: [(String, Int)] = [
        ("I don’t attend often but want to be more connected.", 20),
        ("I attend services or gatherings a few times a month.", 40),
        ("I actively participate weekly in worship and fellowship.", 55)
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

                        Text("Community (Worship and Fellowship)")
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
                Image("cross_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .padding(.top, 8)

                // Main Question
                Text("How involved are you in church or Christian fellowship activities?")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                // Involvement Options
                VStack(spacing: 12) {
                    ForEach(involvementOptions, id: \.0) { option in
                        Button(action: {
                            selectedCommunityInvolvement = option.0 // Persist selection
                            updateCommunityScore(score: option.1)
                        }) {
                            Text(option.0)
                                .font(.system(size: 14))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedCommunityInvolvement == option.0 ? Color.brown.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedCommunityInvolvement == option.0 ? Color.brown : Color.clear, lineWidth: 2)
                                )
                                .foregroundColor(selectedCommunityInvolvement == option.0 ? .black : .gray)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)

                Spacer(minLength: 40)

                // NavigationLink to CompassionServiceView
                NavigationLink(destination: CompassionServiceView().environmentObject(pillarScores)) {
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
    private func updateCommunityScore(score: Int) {
        if let index = pillarScores.scores.firstIndex(where: { $0.name == "Community" }) {
            pillarScores.scores[index].score = Double(score)
        }
    }
}
