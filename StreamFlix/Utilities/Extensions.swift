import SwiftUI

extension Double {
    func formatAsTime() -> String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}

extension Color {
    static let appPrimary = Color.red
    static let appBackground = Color.black
    static let appSecondary = Color.gray
}
