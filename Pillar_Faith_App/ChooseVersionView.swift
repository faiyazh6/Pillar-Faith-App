import SwiftUI

struct ChooseVersionView: View {
    @EnvironmentObject var pillarScores: PillarScores
    @Environment(\.presentationMode) var presentationMode // For dismissing the current view
    @AppStorage("selectedVersion") private var selectedVersion: String = "King James Version (KJV)" // Persistent storage for selected option

    let versions = [
        "King James Version (KJV)",
        "New International Version (NIV)",
        "English Standard Version (ESV)",
        "New Living Translation (NLT)",
        "Others"
    ]

    var body: some View {
        VStack(spacing: 16) {
            // Header Section
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Go back to the previous screen
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            // Bible Image
            Image("bible_icon") // Replace with the actual image name
                .resizable()
                .scaledToFit()
                .frame(height: 80) // Properly resized for layout
                .padding(.top, -10)

            // Title and Subtitle
            VStack(spacing: 8) {
                Text("Choose your Preferred Bible Version")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Text("Which Bible version do you prefer to read?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            // Bible Version Options
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(versions, id: \.self) { version in
                        Button(action: {
                            selectedVersion = version // Save selection to @AppStorage
                        }) {
                            Text(version)
                                .font(.callout)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedVersion == version ? Color.brown.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedVersion == version ? Color.brown : Color.clear, lineWidth: 2)
                                )
                                .foregroundColor(selectedVersion == version ? .black : .gray)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }

            Spacer()

            // Navigation Buttons
            HStack(spacing: 16) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Go back to the previous screen
                }) {
                    Text("Previous")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                }

                NavigationLink(destination: SpiritualJourneyView().environmentObject(pillarScores)) { // Replace with the next view
                    Text("Next")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 45)
                        .background(Color.brown)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20) // Ensure proper spacing from the bottom
        }
        .navigationBarBackButtonHidden(true) // Hides the default back button
        .background(Color(UIColor.systemBackground))
        .ignoresSafeArea(edges: .top)
    }
}
