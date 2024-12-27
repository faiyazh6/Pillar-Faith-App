import SwiftUI

struct ResultsView: View {
    var body: some View {
        VStack {
            Text("This is your ability score")
                .font(.title)
                .padding()

            Image(systemName: "chart.bar.fill") // Placeholder for chart visualization
                .font(.system(size: 100))
                .padding()

            VStack(spacing: 10) {
                Text("Gratitude: 95%")
                Text("Compassion: 90%")
                Text("Community: 85%")
                Text("Reflection: 88%")
            }
            .font(.headline)
            .padding()
        }
        .padding()
    }
}
