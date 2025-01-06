import SwiftUI

struct PillarScoreManagerView: View {
    @State var scores: [PillarScore] = [
        PillarScore(name: "Faith", score: 0),
        PillarScore(name: "Wisdom", score: 0),
        PillarScore(name: "Community", score: 0),
        PillarScore(name: "Compassion", score: 0),
        PillarScore(name: "Presence", score: 0),
        PillarScore(name: "Thankfulness", score: 0)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Header
                Text("Pillar Scores")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                // List of Pillar Scores
                List {
                    ForEach(scores) { score in
                        HStack {
                            Text(score.name)
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("\(Int(score.score))%")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(PlainListStyle())
                
                // Update Scores Button
                Button(action: {
                    updateScores() // Update the scores dynamically
                }) {
                    Text("Update Scores")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brown)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 16)
            }
            .navigationTitle("Pillar Scores")
        }
    }
    
    // MARK: - Update Scores Function
    private func updateScores() {
        // Simulate score updates (In real scenarios, fetch from backend or calculate dynamically)
        scores = scores.map { score in
            var updatedScore = score
            updatedScore.score = Double(Int.random(in: 20...55)) // Replace with actual logic
            return updatedScore
        }
    }
}

class PillarScores: ObservableObject {
    @Published var scores: [PillarScore] = [
        PillarScore(name: "Faith", score: 0),
        PillarScore(name: "Wisdom", score: 0),
        PillarScore(name: "Community", score: 0),
        PillarScore(name: "Compassion", score: 0),
        PillarScore(name: "Presence", score: 0),
        PillarScore(name: "Thankfulness", score: 0)
    ]
}

struct PillarScore: Identifiable {
    let id = UUID()
    let name: String
    var score: Double
}
