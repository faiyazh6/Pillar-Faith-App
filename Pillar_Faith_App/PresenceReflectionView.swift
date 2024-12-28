import SwiftUI

struct PresenceReflectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("selectedPresenceReflection") private var selectedPresenceReflection: String = ""
    @State private var progressValue: CGFloat = 1.0

    let reflectionOptions = [
        "I don’t attend often but want to be more connected.",
        "I attend services or gatherings a few times a month.",
        "I actively participate weekly in worship and fellowship."
    ]

    var body: some View {
        VStack(spacing: 16) {
            // Header Section with Progress Bar
            VStack(alignment: .leading, spacing: 8) {
                // Back Arrow and Title
                HStack(spacing: 12) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                    }

                    Text("Presence (Spiritual Reflection)")
                        .font(.system(size: 14, weight: .semibold))
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
            .padding(.top, 40)

            // Icon
            Image("bird_icon")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .padding(.top, 16)

            // Main Question
            Text("How often do you take time to reflect on God’s presence in your life?")
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)

            // Reflection Options
            VStack(spacing: 12) {
                ForEach(reflectionOptions, id: \.self) { option in
                    Button(action: {
                        selectedPresenceReflection = option
                    }) {
                        Text(option)
                            .font(.system(size: 14))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedPresenceReflection == option ? Color.brown.opacity(0.2) : Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedPresenceReflection == option ? Color.brown : Color.clear, lineWidth: 2)
                            )
                            .foregroundColor(selectedPresenceReflection == option ? .black : .gray)
                    }
                }
            }
            .padding(.horizontal, 16)

            Spacer()

            // Navigation Buttons
            HStack(spacing: 16) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Previous")
                        .font(.system(size: 14))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .foregroundColor(.gray)
                }

                NavigationLink(destination: GratitudeView()) {
                    Text("Next")
                        .font(.system(size: 14))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 50) // Space between buttons and screen bottom
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(UIColor.systemBackground))
    }
}
