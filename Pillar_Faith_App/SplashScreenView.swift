import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var pillarScores: PillarScores
    
    var body: some View {
        VStack(spacing: 20) {
            // Top Image Section
            Image("combined_image") // Replace with the actual image name
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .clipped()

            // Text Section
            VStack(spacing: 10) {
                Text("Your Companion on the Journey of Faith")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center) // Ensures proper alignment
                    .lineLimit(nil) // Allows wrapping to multiple lines
                    .frame(maxWidth: .infinity) // Ensures enough space for text
                    .padding(.horizontal, 20) // Adds padding to the sides

                Text("Discover a deeper connection with God through personalized tools that nurture your spiritual growth.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil) // Ensures text wraps properly
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20) // Adds padding to the sides
            }

            Spacer()

            // Get Started Button
            NavigationLink(destination: ChooseVersionView().environmentObject(pillarScores)) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.brown)
                    .cornerRadius(25)
                    .padding(.horizontal, 30)
            }

            Spacer().frame(height: 30)
        }
        .ignoresSafeArea(edges: .top) // Ensures image covers the top area
        .background(Color(UIColor.systemBackground))
    }
}
