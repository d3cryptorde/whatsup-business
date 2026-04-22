import Foundation

struct AutoResponseRule: Identifiable, Codable {
    var id = UUID()
    var trigger: String
    var response: String
    var isActive: Bool = true
}
