import SwiftUI
import Charts

struct CoverageView: View {
    @State private var selectedZone = DeliveryZone.downtown
    @State private var displayMode: CoverageDisplayMode = .map

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("COVERAGE")
                        .font(.caption.weight(.bold))
                        .tracking(1.5)
                        .foregroundStyle(SwiftRunTheme.aqua)
                    Text("Our delivery area")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                    Text("Choose a zone to see availability and the current dispatch signal.")
                        .foregroundStyle(SwiftRunTheme.muted)
                }

                ForEach(DeliveryZone.all) { zone in
                    ZoneCard(zone: zone, isSelected: zone.id == selectedZone.id) {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.78)) {
                            selectedZone = zone
                        }
                    }
                }

                Picker("Dashboard mode", selection: $displayMode) {
                    ForEach(CoverageDisplayMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(4)
                .glassCard()

                if displayMode == .map {
                    CoverageMap(selectedZone: selectedZone)
                } else {
                    RiderActivityChart(selectedZone: selectedZone)
                }

                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(SwiftRunTheme.aqua)
                    Text("Activity is a live-style demonstration based on the SwiftRun website's dispatch data. Contact SwiftRun for real-time service confirmation.")
                        .font(.footnote)
                        .foregroundStyle(SwiftRunTheme.muted)
                }
                .padding(14)
                .background(SwiftRunTheme.aqua.opacity(0.07))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(20)
            .padding(.bottom, 24)
        }
        .background(SwiftRunTheme.background.ignoresSafeArea())
        .navigationTitle("Coverage")
    }
}

private enum CoverageDisplayMode: String, CaseIterable, Identifiable {
    case map
    case activity

    var id: String { rawValue }
    var title: String { self == .map ? "Live map" : "Rider activity" }
}

private struct ZoneCard: View {
    let zone: DeliveryZone
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: zone.icon)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(zone.accent)
                    .frame(width: 48, height: 48)
                    .background(zone.accent.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(zone.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text(zone.detail)
                        .font(.subheadline)
                        .foregroundStyle(SwiftRunTheme.muted)
                    Text(zone.availability)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(zone.accent)
                }

                Spacer(minLength: 8)
                Image(systemName: isSelected ? "checkmark.circle.fill" : "chevron.right")
                    .font(.title3)
                    .foregroundStyle(isSelected ? zone.accent : SwiftRunTheme.muted)
            }
            .padding(16)
            .background(isSelected ? zone.accent.opacity(0.09) : Color.white.opacity(0.045))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? zone.accent.opacity(0.88) : Color.white.opacity(0.10), lineWidth: isSelected ? 1.5 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

private struct CoverageMap: View {
    let selectedZone: DeliveryZone

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Label("LIVE DISPATCH", systemImage: "location.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(SwiftRunTheme.aqua)
                Spacer()
                Text("Active riders: \(selectedZone.activeRiders)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.78))
            }
            .padding(16)
            .background(Color.white.opacity(0.035))

            ZStack {
                Image("Handover")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()

                LinearGradient(
                    colors: [Color.black.opacity(0.18), SwiftRunTheme.background.opacity(0.70)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                DispatchMarker(zone: selectedZone)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: selectedZone.markerAlignment)
                    .padding(34)
            }
        }
        .glassCard()
    }
}

private struct DispatchMarker: View {
    let zone: DeliveryZone
    @State private var pulse = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(zone.name)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                Text("Active riders: \(zone.activeRiders)")
                    .font(.caption2)
                    .foregroundStyle(zone.accent)
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 8)
            .background(SwiftRunTheme.surface.opacity(0.94))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(zone.accent.opacity(0.45), lineWidth: 1)
            )

            ZStack {
                Circle()
                    .stroke(zone.accent.opacity(pulse ? 0.03 : 0.62), lineWidth: 2)
                    .frame(width: pulse ? 56 : 24, height: pulse ? 56 : 24)
                Circle()
                    .fill(zone.accent)
                    .frame(width: 18, height: 18)
                    .overlay(Circle().stroke(.white.opacity(0.8), lineWidth: 2))
                    .shadow(color: zone.accent.opacity(0.9), radius: 12)
            }
            .frame(width: 56, height: 42)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.45).repeatForever(autoreverses: false)) {
                pulse = true
            }
        }
    }
}

private struct RiderActivityChart: View {
    let selectedZone: DeliveryZone

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("LIVE SIMULATION", systemImage: "dot.radiowaves.left.and.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(SwiftRunTheme.green)
                Spacer()
                Text(selectedZone.name)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(SwiftRunTheme.muted)
            }

            Chart {
                ForEach(RiderSeries.samples) { series in
                    ForEach(series.points) { point in
                        LineMark(
                            x: .value("Time", point.time),
                            y: .value("Riders", point.riders)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(series.color)
                        .lineStyle(StrokeStyle(lineWidth: series.name == selectedZone.chartSeriesName ? 3.5 : 1.6, lineCap: .round, lineJoin: .round))
                        .opacity(series.name == selectedZone.chartSeriesName ? 1 : 0.30)
                    }
                }
            }
            .chartYScale(domain: 0...180)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4)) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.white.opacity(0.10))
                    AxisValueLabel()
                        .foregroundStyle(SwiftRunTheme.muted)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.white.opacity(0.10))
                    AxisValueLabel()
                        .foregroundStyle(SwiftRunTheme.muted)
                }
            }
            .frame(height: 250)

            HStack(spacing: 14) {
                ForEach(RiderSeries.samples) { series in
                    HStack(spacing: 5) {
                        Circle().fill(series.color).frame(width: 8, height: 8)
                        Text(series.name)
                            .font(.caption2)
                            .foregroundStyle(SwiftRunTheme.muted)
                    }
                }
            }
        }
        .padding(16)
        .glassCard()
    }
}
