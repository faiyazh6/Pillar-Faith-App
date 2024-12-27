import SwiftUI

struct GratitudeView: View {
    var body: some View {
        VStack {
            Text("Thankfulness and Gratitude")
                .font(.title)
                .padding()

            Text("How often do you express gratitude for God's blessings?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            VStack(spacing: 20) {
                Button("I regularly express gratitude") {}
                Button("Sometimes") {}
                Button("Rarely") {}
            }
            .padding()

            NavigationLink(destination: ResultsView()) {
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
