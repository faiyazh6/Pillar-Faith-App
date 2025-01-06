import SwiftUI

@main
struct Pillar_Faith_AppApp: App {
    @StateObject private var pillarScores = PillarScores()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SplashScreenView().environmentObject(pillarScores)
            }
        }
    }
}
