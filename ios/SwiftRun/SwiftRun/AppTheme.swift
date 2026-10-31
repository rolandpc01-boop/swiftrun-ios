import SwiftUI

enum SwiftRunTheme {
    static let background = Color(hex: "0B0F19")
    static let surface = Color(hex: "131B2E")
    static let card = Color(hex: "1E293B")
    static let aqua = Color(hex: "00F2FE")
    static let blue = Color(hex: "4FACFE")
    static let green = Color(hex: "38EF7D")
    static let orange = Color(hex: "FF7B00")
    static let muted = Color(hex: "94A3B8")

    static let heroGradient = LinearGradient(
        colors: [Color.black.opacity(0.20), background.opacity(0.72), background],
        startPoint: .top,
        endPoint: .bottom
    )

    static let aquaGradient = LinearGradient(
        colors: [aqua, blue],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)

        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
    }
}

struct GlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white.opacity(0.045))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.10), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCard())
    }
}

struct GradientActionButton: View {
    let title: String
    let icon: String
    var isPrimary = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                Image(systemName: icon)
                    .font(.subheadline.weight(.bold))
            }
            .font(.subheadline.weight(.bold))
            .foregroundStyle(isPrimary ? SwiftRunTheme.background : Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background {
                if isPrimary {
                    SwiftRunTheme.aquaGradient
                } else {
                    Color.white.opacity(0.08)
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(isPrimary ? Color.clear : Color.white.opacity(0.14), lineWidth: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
