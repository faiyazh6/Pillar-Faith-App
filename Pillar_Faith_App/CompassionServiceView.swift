import SwiftUI

struct CompassionServiceView: View {
    var body: some View {
        VStack {
            Text("Compassion, Service, and Kindness")
                .font(.title)
                .padding()

            Text("How often do you perform acts of kindness or service to others?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            VStack(spacing: 20) {
                Button("Regularly") {}
                Button("Sometimes") {}
                Button("Rarely") {}
            }
            .padding()

            NavigationLink(destination: PresenceReflectionView()) {
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
