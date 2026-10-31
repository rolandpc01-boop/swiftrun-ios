import SwiftUI
import UIKit

struct ContactView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var topic = "General inquiry"
    @State private var message = ""
    @State private var didSubmit = false

    private let topics = [
        "General inquiry",
        "Business / enterprise delivery",
        "Become a rider",
        "Customer support"
    ]

    private var canSubmit: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        email.contains("@") &&
        !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("CONNECT")
                        .font(.caption.weight(.bold))
                        .tracking(1.5)
                        .foregroundStyle(SwiftRunTheme.aqua)
                    Text("Let’s start a partnership.")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                    Text("Questions about enterprise rates, delivery routes, or rider opportunities? Send a note and SwiftRun will get back to you within the hour.")
                        .foregroundStyle(SwiftRunTheme.muted)
                }

                VStack(spacing: 14) {
                    ContactLink(
                        icon: "phone.fill",
                        title: "Call us",
                        detail: "+1 (800) 555-SWIFT",
                        accent: SwiftRunTheme.aqua,
                        destination: URL(string: "tel:+18005557943")!
                    )
                    ContactLink(
                        icon: "envelope.fill",
                        title: "Email us",
                        detail: "hello@swiftrun.delivery",
                        accent: SwiftRunTheme.green,
                        destination: URL(string: "mailto:hello@swiftrun.delivery")!
                    )
                    ContactAddress()
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("Send a message")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)

                    ContactTextField(title: "Your name", placeholder: "John Doe", text: $name, contentType: .name)
                    ContactTextField(title: "Email address", placeholder: "john@example.com", text: $email, contentType: .emailAddress, keyboardType: .emailAddress)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("How can we help?")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(SwiftRunTheme.muted)
                        Picker("How can we help?", selection: $topic) {
                            ForEach(topics, id: \.self) { item in
                                Text(item).tag(item)
                            }
                        }
                        .tint(SwiftRunTheme.aqua)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(SwiftRunTheme.background.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Message")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(SwiftRunTheme.muted)
                        TextEditor(text: $message)
                            .frame(minHeight: 120)
                            .padding(8)
                            .scrollContentBackground(.hidden)
                            .background(SwiftRunTheme.background.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Color.white.opacity(0.10), lineWidth: 1)
                            )
                    }

                    GradientActionButton(title: "Send message", icon: "paperplane.fill") {
                        didSubmit = true
                    }
                    .disabled(!canSubmit)
                    .opacity(canSubmit ? 1 : 0.45)
                }
                .padding(18)
                .glassCard()

                Text("© 2026 SwiftRun Delivery Service. All rights reserved.")
                    .font(.footnote)
                    .foregroundStyle(SwiftRunTheme.muted)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4)
            }
            .padding(20)
            .padding(.bottom, 24)
        }
        .background(SwiftRunTheme.background.ignoresSafeArea())
        .alert("Message queued", isPresented: $didSubmit) {
            Button("Done", role: .cancel) { }
        } message: {
            Text("Thanks, \(name). Our dispatch team will contact you shortly.")
        }
    }
}

private struct ContactLink: View {
    let icon: String
    let title: String
    let detail: String
    let accent: Color
    let destination: URL

    var body: some View {
        Link(destination: destination) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundStyle(accent)
                    .frame(width: 42, height: 42)
                    .background(accent.opacity(0.12))
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 3) {
                    Text(title.uppercased())
                        .font(.caption.weight(.bold))
                        .foregroundStyle(SwiftRunTheme.muted)
                    Text(detail)
                        .font(.body.weight(.medium))
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(SwiftRunTheme.muted)
            }
            .padding(14)
            .glassCard()
        }
    }
}

private struct ContactAddress: View {
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "mappin.and.ellipse")
                .font(.headline)
                .foregroundStyle(SwiftRunTheme.orange)
                .frame(width: 42, height: 42)
                .background(SwiftRunTheme.orange.opacity(0.12))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 3) {
                Text("HEADQUARTERS")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(SwiftRunTheme.muted)
                Text("500 Courier Ave, Suite 100, Metro City")
                    .font(.body.weight(.medium))
                    .foregroundStyle(.white)
            }
            Spacer()
        }
        .padding(14)
        .glassCard()
    }
}

private struct ContactTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var contentType: UITextContentType?
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(SwiftRunTheme.muted)
            TextField(placeholder, text: $text)
                .textContentType(contentType)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(contentType == .emailAddress ? .never : .words)
                .autocorrectionDisabled(contentType == .emailAddress)
                .padding(13)
                .background(SwiftRunTheme.background.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
        }
    }
}
