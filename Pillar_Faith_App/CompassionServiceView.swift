import SwiftUI

struct CompassionServiceView: View {
    @Environment(\.presentationMode) var presentationMode // For dismissing the current view
    @AppStorage("selectedCompassionFrequency") private var selectedCompassionFrequency: String = "" // Persist user choice
    @State private var progressValue: CGFloat = 0.83 // Updated progress for this view

    let compassionOptions = [
        "I rarely serve others but want to start small.",
        "I try to serve and help others a few times a week.",
        "I regularly dedicate time to serving others with purpose."
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
                    ForEach(compassionOptions, id: \.self) { option in
                        Button(action: {
                            selectedCompassionFrequency = option // Persist selection
                        }) {
                            Text(option)
                                .font(.system(size: 14))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedCompassionFrequency == option ? Color.brown.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedCompassionFrequency == option ? Color.brown : Color.clear, lineWidth: 2)
                                )
                                .foregroundColor(selectedCompassionFrequency == option ? .black : .gray)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)

                Spacer(minLength: 40)

                // NavigationLink to GratitudeView
                NavigationLink(destination: GratitudeView()) {
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
