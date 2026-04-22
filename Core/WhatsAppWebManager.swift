import SwiftUI
import WebKit

class WhatsAppWebManager: NSObject, ObservableObject {
    @Published var isReady = false
    @Published var qrCode: String?
    @Published var lastMessage: WhatsAppMessage?
    
    var webView: WKWebView!
    
    override init() {
        super.init()
        setupWebView()
    }
    
    private func setupWebView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "bridgeReady")
        contentController.add(self, name: "newMessage")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        
        // Use a desktop User Agent to get WhatsApp Web
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
        
        let request = URLRequest(url: URL(string: "https://web.whatsapp.com")!)
        webView.load(request)
    }
    
    func sendMessage(chatId: String, body: String) {
        let js = "window.WhatsAppBridge.sendMessage('\(chatId)', '\(body)')"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    func fetchQRCode() {
        webView.evaluateJavaScript("window.WhatsAppBridge.getQRCode()") { (result, error) in
            if let qr = result as? String {
                DispatchQueue.main.async {
                    self.qrCode = qr
                }
            }
        }
    }
}

extension WhatsAppWebManager: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Inject JS bridge
        if let path = Bundle.main.path(forResource: "Inject", ofType: "js"),
           let js = try? String(contentsOfFile: path) {
            webView.evaluateJavaScript(js, completionHandler: nil)
        }
        
        // Start polling for QR code if not logged in
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            if !self.isReady {
                self.fetchQRCode()
            } else {
                timer.invalidate()
            }
        }
    }
}

extension WhatsAppWebManager: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "bridgeReady" {
            self.isReady = true
            self.qrCode = nil
        } else if message.name == "newMessage" {
            if let dict = message.body as? [String: Any],
               let id = dict["id"] as? String,
               let body = dict["body"] as? String,
               let from = dict["from"] as? String,
               let senderName = dict["senderName"] as? String {
                let msg = WhatsAppMessage(id: id, body: body, from: from, senderName: senderName)
                self.lastMessage = msg
            }
        }
    }
}

struct WhatsAppWebView: UIViewRepresentable {
    let manager: WhatsAppWebManager
    
    func makeUIView(context: Context) -> WKWebView {
        return manager.webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
