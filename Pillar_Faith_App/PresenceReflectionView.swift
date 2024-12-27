import SwiftUI

struct PresenceReflectionView: View {
    var body: some View {
        VStack {
            Text("Presence and Spiritual Reflection")
                .font(.title)
                .padding()

            Text("How often do you take time to reflect on God's presence in your life?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            VStack(spacing: 20) {
                Button("Daily") {}
                Button("Sometimes") {}
                Button("Rarely") {}
            }
            .padding()

            NavigationLink(destination: GratitudeView()) {
                Text("Next")
                    .font(.title2)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
