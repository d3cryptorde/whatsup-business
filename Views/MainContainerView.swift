import SwiftUI

struct MainContainerView: View {
    @StateObject var webManager = WhatsAppWebManager()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            LiquidBackground()
            
            if !webManager.isReady {
                LoginView(manager: webManager)
                    .transition(.move(edge: .bottom))
            } else {
                TabView(selection: $selectedTab) {
                    ChatListView()
                        .tabItem {
                            Label("Chats", systemImage: "message.fill")
                        }
                        .tag(0)
                    
                    AutoResponderView()
                        .tabItem {
                            Label("Autoresponder", systemImage: "bolt.fill")
                        }
                        .tag(1)
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                        .tag(2)
                }
                .accentColor(.white)
            }
        }
        .onReceive(webManager.$lastMessage) { message in
            guard let msg = message else { return }
            handleAutoResponse(for: msg)
        }
    }
    
    private func handleAutoResponse(for message: WhatsAppMessage) {
        // Simple logic to match rules (in a real app, this would use the rules from AutoResponderView)
        let rules = [
            AutoResponseRule(trigger: "hello", response: "Hello! How can we help you today?"),
            AutoResponseRule(trigger: "price", response: "Our pricing starts at $10/month.")
        ]
        
        for rule in rules where rule.isActive {
            if message.body.lowercased().contains(rule.trigger.lowercased()) {
                webManager.sendMessage(chatId: message.from, body: rule.response)
                break
            }
        }
    }
}

struct ChatListView: View {
    var body: some View {
        VStack {
            Text("Conversations")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
            
            List {
                ForEach(0..<5) { _ in
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white.opacity(0.6))
                        
                        VStack(alignment: .leading) {
                            Text("Customer Name")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Last message preview...")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.vertical, 5)
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(PlainListStyle())
        }
        .glassy()
        .padding()
    }
}

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
            
            Form {
                Section(header: Text("Business Info").foregroundColor(.white)) {
                    Text("Business Name: My Shop")
                    Text("Status: Online")
                }
                .listRowBackground(Color.white.opacity(0.1))
                
                Section {
                    Button("Logout") {
                        // Logout logic
                    }
                    .foregroundColor(.red)
                }
                .listRowBackground(Color.white.opacity(0.1))
            }
            .scrollContentBackground(.hidden)
        }
        .glassy()
        .padding()
    }
}
