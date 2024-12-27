import SwiftUI

struct CommunityWorshipView: View {
    var body: some View {
        VStack {
            Text("Community Worship and Fellowship")
                .font(.title)
                .padding()

            Text("How often do you participate in church or fellowship activities?")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            VStack(spacing: 20) {
                Button("Every week") {}
                Button("Once a month") {}
                Button("Rarely") {}
            }
            .padding()

            NavigationLink(destination: CompassionServiceView()) {
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
