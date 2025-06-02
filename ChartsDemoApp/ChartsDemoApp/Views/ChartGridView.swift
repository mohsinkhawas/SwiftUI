import SwiftUI

struct ChartGridView: View {
    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(ChartType.allCases) { chartType in
                        NavigationLink(destination: chartDestination(for: chartType)) {
                            ChartOptionCard(chartType: chartType)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Charts Demo")
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
        }
    }
    
    @ViewBuilder
    private func chartDestination(for chartType: ChartType) -> some View {
        switch chartType {
        case .bar:
            BarChartView()
        case .line:
            LineChartView()
        case .area:
            AreaChartView()
        case .pie:
            PieChartView()
        case .scatter:
            ScatterPlotView()
        case .candlestick:
            CandlestickChartView()
        }
    }
}

struct ChartOptionCard: View {
    let chartType: ChartType
    
    var body: some View {
        VStack {
            Image(systemName: chartType.systemImage)
                .font(.system(size: 40))
                .foregroundColor(.cardIcon)
                .frame(height: 60)
                .padding(.bottom, 8)
            
            Text(chartType.rawValue)
                .font(.headline)
                .foregroundColor(.cardTitle)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(16)
        .shadow(color: .cardShadow.opacity(0.15), radius: 6, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.cardIcon.opacity(0.15), lineWidth: 1)
        )
    }
}

#Preview {
    ChartGridView()
}
