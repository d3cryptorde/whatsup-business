import SwiftUI

struct LoginView: View {
    @ObservedObject var manager: WhatsAppWebManager
    
    var body: some View {
        VStack(spacing: 30) {
            Text("WhatsApp Business")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            if let qrString = manager.qrCode,
               let data = Data(base64Encoded: qrString.replacingOccurrences(of: "data:image/png;base64,", with: "")),
               let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
            
            Text("Scan the QR code with your phone to log in.")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .glassy()
        .padding()
    }
}
