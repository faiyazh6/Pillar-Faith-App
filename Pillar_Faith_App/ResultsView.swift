import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var pillarScores: PillarScores // Access the shared scores
    @Environment(\.presentationMode) var presentationMode // For dismissing the current view
    @State private var navigateToOnboardingComplete = false // Navigation trigger for the next view
    @State private var showSubscription = false // State for showing the subscription pop-up

    var body: some View {
        ZStack {
            // Main Content
            ScrollView {
                VStack(spacing: 16) {
                    // Header Section
                    HStack {
                        // Previous Button
                        Button(action: {
                            presentationMode.wrappedValue.dismiss() // Go back to the previous screen
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.brown)
                        }
                        
                        Spacer()
                        
                        // Next Button
                        NavigationLink(destination: OnboardingCompleteView()) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.brown)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    // Title
                    HStack {
                        Image("hands_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Text("This is your ability score")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.brown)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)

                    // Radar Chart Section
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        
                        RadarChartView(scores: pillarScores.scores.map { $0.score }) // Dynamic scores
                            .padding(16)
                    }
                    .frame(height: 240)
                    .padding(.horizontal, 16)
                    
                    // Pillars Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Pillars")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.horizontal, 16)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(pillarScores.scores) { pillar in
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        VStack {
                                            Image(systemName: "chart.line.uptrend.xyaxis")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 40)
                                                .foregroundColor(.green)
                                            
                                            Text("\(pillar.score, specifier: "%.2f")%")
                                                .font(.system(size: 14, weight: .semibold))
                                            
                                            Text(pillar.name)
                                                .font(.system(size: 14))
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                    }
                                    .frame(height: 120)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 32)
            }
            .background(Color(UIColor.systemBackground))
            .navigationBarBackButtonHidden(true)

            // Subscription Modal
            if showSubscription {
                SubscriptionView(isPresented: $showSubscription)
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    showSubscription = true
                }
            }
        }
    }
}

struct SubscriptionView: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Spacer() // Push the modal to the bottom
            
            VStack(spacing: 16) {
                Image("church_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.top, 16)
                
                Text("Choose a plan for after your 7-day free trial")
                    .font(.system(size: 18, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                
                VStack(spacing: 12) {
                    HStack {
                        Text("Weekly Plan")
                        Spacer()
                        Text("$4.99 / Week")
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    
                    HStack {
                        Text("Monthly Plan")
                        Spacer()
                        Text("$2.49 / Month")
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
                .padding(.horizontal, 16)
                
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            isPresented = false // Dismiss the modal with slide-down animation
                        }
                    }) {
                        Text("Maybe later")
                            .font(.system(size: 16))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: {
                        // Add subscription logic here
                    }) {
                        Text("Subscribe")
                            .font(.system(size: 16))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.brown)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 20)
        }
        .edgesIgnoringSafeArea(.all)
        .background(
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isPresented = false // Dismiss modal when tapping outside
                    }
                }
        )
        .transition(.move(edge: .bottom)) // Apply slide-down transition
    }
}


// MARK: - Onboarding Complete View
struct OnboardingCompleteView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image("check_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text("Onboarding is complete!")
                .font(.system(size: 18, weight: .semibold))

            Text("Your Personalized Dashboard Is Ready!")
                .font(.system(size: 14))
                .foregroundColor(.gray)

            NavigationLink(destination: AuthenticationView()) {
                Text("Proceed")
                    .font(.system(size: 16, weight: .bold))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

// MARK: - Radar Chart Implementation
struct RadarChartView: View {
    let scores: [Double]
    let labels = ["Faith", "Wisdom", "Thankfulness", "Presence", "Compassion", "Community"]

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: size / 2, y: size / 2)
            let radius = size / 2

            ZStack {
                drawGrid(center: center, radius: radius, layers: 5, labels: labels)
                drawDataLayer(center: center, radius: radius, scores: scores)
                drawLabels(center: center, radius: radius, labels: labels)
            }
            .frame(width: size, height: size)
        }
    }

    private func drawGrid(center: CGPoint, radius: CGFloat, layers: Int, labels: [String]) -> some View {
        ZStack {
            ForEach(1...layers, id: \.self) { i in
                let layerRadius = radius * CGFloat(i) / CGFloat(layers)
                Polygon(sides: labels.count, radius: layerRadius, center: center)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            }
        }
    }

    private func drawDataLayer(center: CGPoint, radius: CGFloat, scores: [Double]) -> some View {
        ZStack {
            let dataPoints = scores.map { $0 / 100 * radius }
            RadarPath(sides: scores.count, dataPoints: dataPoints, center: center)
                .fill(Color.blue.opacity(0.2))
                .overlay(RadarPath(sides: scores.count, dataPoints: dataPoints, center: center).stroke(Color.blue, lineWidth: 2))
        }
    }
    
    // Function to draw labels
    private func drawLabels(center: CGPoint, radius: CGFloat, labels: [String]) -> some View {
        ZStack {
            ForEach(0..<labels.count, id: \.self) { i in
                let angle = 2 * .pi * CGFloat(i) / CGFloat(labels.count)
                let labelX = center.x + (radius + 20) * cos(angle) // Adjust distance
                let labelY = center.y + (radius + 20) * sin(angle)

                Text(labels[i])
                    .font(.caption)
                    .foregroundColor(.gray)
                    .position(x: labelX, y: labelY)
            }
        }
    }
}

// Utility shape for polygons
struct Polygon: Shape {
    var sides: Int
    var radius: CGFloat
    var center: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let angle = 2 * .pi / CGFloat(sides)
        for i in 0...sides {
            let x = center.x + radius * cos(CGFloat(i) * angle)
            let y = center.y + radius * sin(CGFloat(i) * angle)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        return path
    }
}

// Utility shape for radar paths
struct RadarPath: Shape {
    var sides: Int
    var dataPoints: [CGFloat]
    var center: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let angle = 2 * .pi / CGFloat(sides)
        for i in 0..<sides {
            let x = center.x + dataPoints[i] * cos(CGFloat(i) * angle)
            let y = center.y + dataPoints[i] * sin(CGFloat(i) * angle)
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Pillar Data Model
struct Pillar: Identifiable {
    let id = UUID()
    let name: String
    let score: Double
}

//let pillarData = [
//    Pillar(name: "Faith", score: 93.09),
//    Pillar(name: "Wisdom", score: 93.09),
//    Pillar(name: "Community", score: 93.09),
//    Pillar(name: "Compassion", score: 93.09),
//    Pillar(name: "Presence", score: 93.09),
//    Pillar(name: "Thankfulness", score: 93.09)
//]
