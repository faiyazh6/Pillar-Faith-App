import SwiftUI

struct GratitudeView: View {
    @Environment(\.presentationMode) var presentationMode // For dismissing the current view
    @AppStorage("selectedGratitudeFrequency") private var selectedGratitudeFrequency: String = "" // Persist user choice
    @State private var progressValue: CGFloat = 1.0 // Final progress for this view

    let gratitudeOptions = [
        "I rarely express gratitude but want to start.",
        "I try to thank God for His blessings a few times a week.",
        "I express gratitude daily through prayer or reflection."
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

                        Text("Thankfulness (Gratitude)")
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
                Image("thanks_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .padding(.top, 8)

                // Main Question
                Text("How often do you express gratitude for God’s blessings?")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                // Gratitude Options
                VStack(spacing: 12) {
                    ForEach(gratitudeOptions, id: \.self) { option in
                        Button(action: {
                            selectedGratitudeFrequency = option // Persist selection
                        }) {
                            Text(option)
                                .font(.system(size: 14))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedGratitudeFrequency == option ? Color.brown.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedGratitudeFrequency == option ? Color.brown : Color.clear, lineWidth: 2)
                                )
                                .foregroundColor(selectedGratitudeFrequency == option ? .black : .gray)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)

                Spacer(minLength: 40)

                // NavigationLink to ResultsView
                NavigationLink(destination: ResultsView()) {
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
}
