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
                .foregroundColor(.blue)
                .frame(height: 60)
            
            Text(chartType.rawValue)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    ChartGridView()
} 