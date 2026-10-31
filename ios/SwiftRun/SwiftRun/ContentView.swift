import SwiftUI

enum SwiftRunTab: Hashable {
    case home
    case coverage
    case contact
}

struct ContentView: View {
    @State private var selectedTab: SwiftRunTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(
                showCoverage: { selectedTab = .coverage },
                showContact: { selectedTab = .contact }
            )
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(SwiftRunTab.home)

            CoverageView()
                .tabItem {
                    Label("Coverage", systemImage: "map.fill")
                }
                .tag(SwiftRunTab.coverage)

            ContactView()
                .tabItem {
                    Label("Contact", systemImage: "message.fill")
                }
                .tag(SwiftRunTab.contact)
        }
        .tint(SwiftRunTheme.aqua)
    }
}

struct HomeView: View {
    let showCoverage: () -> Void
    let showContact: () -> Void

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                hero
                features
            }
        }
        .background(SwiftRunTheme.background.ignoresSafeArea())
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            Image("Hero")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, minHeight: 540, maxHeight: 620)
                .clipped()

            SwiftRunTheme.heroGradient

            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                    Text("LIGHTNING FAST DELIVERY")
                }
                .font(.caption.weight(.bold))
                .foregroundStyle(SwiftRunTheme.aqua)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(SwiftRunTheme.aqua.opacity(0.14))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(SwiftRunTheme.aqua.opacity(0.32), lineWidth: 1))

                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 0) {
                        Text("Swift")
                            .foregroundStyle(SwiftRunTheme.aqua)
                        Text("Run")
                            .foregroundStyle(.white)
                    }
                    .font(.system(size: 28, weight: .heavy, design: .rounded))

                    Text("Hyperlocal Delivery\nRedefined.")
                        .font(.system(size: 38, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .lineSpacing(-4)
                }

                Text("Get packages, documents, and essentials delivered in under 20 minutes. Reliable, secure, and fully tracked in real time.")
                    .font(.body)
                    .foregroundStyle(Color.white.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 12) {
                    GradientActionButton(title: "Check coverage", icon: "map") {
                        showCoverage()
                    }
                    GradientActionButton(title: "Contact us", icon: "arrow.up.right", isPrimary: false) {
                        showContact()
                    }
                }

                HStack(spacing: 10) {
                    StatTile(value: "18m", label: "Average delivery")
                    StatTile(value: "99.9%", label: "Success rate")
                    StatTile(value: "24/7", label: "Live support")
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
    }

    private var features: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("DELIVERY, ON YOUR TERMS")
                    .font(.caption.weight(.bold))
                    .tracking(1.5)
                    .foregroundStyle(SwiftRunTheme.aqua)
                Text("Everything moves faster with SwiftRun.")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                Text("Open the Coverage tab to see active service zones and rider activity at a glance.")
                    .foregroundStyle(SwiftRunTheme.muted)
            }

            FeatureCard(
                icon: "location.fill",
                title: "Local by design",
                detail: "Coverage is organized around the neighborhoods we serve best.",
                accent: SwiftRunTheme.aqua
            )
            FeatureCard(
                icon: "shield.checkered",
                title: "Secure handoffs",
                detail: "Every job is handled with clear, real-time dispatch visibility.",
                accent: SwiftRunTheme.green
            )
            FeatureCard(
                icon: "headphones",
                title: "People on standby",
                detail: "Reach a SwiftRun specialist any time you need help.",
                accent: SwiftRunTheme.orange
            )
        }
        .padding(20)
        .padding(.bottom, 24)
    }
}

private struct StatTile: View {
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.headline.weight(.heavy))
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2)
                .foregroundStyle(Color.white.opacity(0.70))
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.white.opacity(0.09))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
}

private struct FeatureCard: View {
    let icon: String
    let title: String
    let detail: String
    let accent: Color

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title3.weight(.bold))
                .foregroundStyle(accent)
                .frame(width: 46, height: 46)
                .background(accent.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(SwiftRunTheme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .glassCard()
    }
}
