import SwiftUI

struct GlassModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

extension View {
    func glassy() -> some View {
        self.modifier(GlassModifier())
    }
}

struct LiquidBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            Canvas { context, size in
                // Custom drawing for more complex liquid effects could go here
            }
            
            // Animated Blobs
            Circle()
                .fill(Color.blue.opacity(0.5))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: animate ? 100 : -100, y: animate ? -200 : 200)
            
            Circle()
                .fill(Color.purple.opacity(0.4))
                .frame(width: 400, height: 400)
                .blur(radius: 80)
                .offset(x: animate ? -150 : 150, y: animate ? 250 : -250)
            
            Circle()
                .fill(Color.green.opacity(0.3))
                .frame(width: 350, height: 350)
                .blur(radius: 70)
                .offset(x: animate ? 200 : -200, y: animate ? 150 : -150)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}
