import Foundation

extension Date {

    func formatDate() -> String {
        self.formatted(date: .numeric, time: .omitted)
    }
}
