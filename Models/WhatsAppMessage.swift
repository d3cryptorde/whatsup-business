import Foundation

struct WhatsAppMessage: Identifiable {
    let id: String
    let body: String
    let from: String
    let senderName: String
    let timestamp: Date = Date()
}
