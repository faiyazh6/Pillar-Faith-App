import SwiftUI

struct BibleUsageView: View {
    @Environment(\.presentationMode) var presentationMode // For dismissing the current view
    @AppStorage("selectedPrayerConsistency") private var selectedPrayerConsistency: String = "" // Persist user choice
    @State private var progressValue: CGFloat = 0.33 // Initial progress for this view

    let prayerOptions = [
        "I rarely pray, but I want to start",
        "I pray sometimes, but I could be more consistent.",
        "I pray daily and want to deepen my prayer life."
    ]

    var body: some View {
        VStack(spacing: 20) {
            // Header Section
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Go back to the previous screen
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                    }

                    Text("Faith (Prayer)")
                        .font(.headline) // Reduced font size
                        .fontWeight(.semibold)
                }

                // Progress Bar
                ZStack(alignment: .leading) {
                    Capsule()
                        .frame(height: 6) // Slightly thicker progress bar
                        .foregroundColor(.gray.opacity(0.3))
                    Capsule()
                        .frame(width: progressValue * UIScreen.main.bounds.width, height: 6)
                        .foregroundColor(.brown)
                }
            }
            .padding(.horizontal, 20) // Adjusted padding for better alignment
            .padding(.top, 20) // Moved down slightly

            // Emoji Icon
            Image("faith_icon")
                .resizable()
                .scaledToFit()
                .frame(height: 100) // Reduced size for better layout
                .padding(.top, -5)

            // Main Question
            Text("How consistent are you in daily prayer?")
                .font(.subheadline) // Reduced font size
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            // Prayer Options
            VStack(spacing: 12) { // Reduced spacing between options
                ForEach(prayerOptions, id: \.self) { option in
                    Button(action: {
                        selectedPrayerConsistency = option // Persist selection
                    }) {
                        Text(option)
                            .font(.footnote) // Reduced font size
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedPrayerConsistency == option ? Color.brown.opacity(0.2) : Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedPrayerConsistency == option ? Color.brown : Color.clear, lineWidth: 2)
                            )
                            .foregroundColor(selectedPrayerConsistency == option ? .black : .gray)
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            // Next Button
            Button(action: {
                // Simulate progress update and navigate to the next view
                progressValue = 0.66 // Update progress for the next view
                // Navigate to the next view or perform an action
            }) {
                Text("Next")
                    .font(.subheadline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20) // Ensures button is visible
        }
        .navigationBarBackButtonHidden(true) // Hides the default back button
        .background(Color(UIColor.systemBackground))
    }
}
