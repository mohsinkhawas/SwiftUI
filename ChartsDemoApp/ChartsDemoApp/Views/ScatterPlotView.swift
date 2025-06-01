import SwiftUI
import Charts

struct ScatterPlotView: View {
    @State private var data = ChartData.generateStockData()
    @State private var selectedPoint: StockData?
    @State private var animateChart = false
    @State private var showTrendLine = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Price vs Volume")
                    .font(.title)
                    .padding(.horizontal)
                
                chartContent
                    .frame(height: 300)
                    .padding()
                
                customizationOptions
            }
        }
        .navigationTitle("Scatter Plot")
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateChart = true
            }
        }
    }
    
    private var chartContent: some View {
        Chart {
            ForEach(data) { item in
                pointMark(for: item)
                if showTrendLine {
                    trendLine(for: item)
                }
                if let selected = selectedPoint, selected.id == item.id {
                    selectionMarks(for: item)
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine()
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine()
                AxisValueLabel()
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                handleDrag(value, geometry: geometry, proxy: proxy)
                            }
                            .onEnded { _ in
                                selectedPoint = nil
                            }
                    )
            }
        }
    }
    
    private func pointMark(for item: StockData) -> some ChartContent {
        PointMark(
            x: .value("Volume", animateChart ? item.volume : 0),
            y: .value("Price", animateChart ? item.price : 0)
        )
        .foregroundStyle(Color.purple.gradient)
        .symbolSize(selectedPoint?.id == item.id ? 100 : 50)
    }
    
    private func trendLine(for item: StockData) -> some ChartContent {
        LineMark(
            x: .value("Volume", item.volume),
            y: .value("Price", item.price)
        )
        .foregroundStyle(Color.purple.opacity(0.3))
        .interpolationMethod(.catmullRom)
    }
    
    @ChartContentBuilder
    private func selectionMarks(for item: StockData) -> some ChartContent {
        RuleMark(
            x: .value("Selected Volume", item.volume)
        )
        .foregroundStyle(Color.gray.opacity(0.3))
        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
        
        RuleMark(
            y: .value("Selected Price", item.price)
        )
        .foregroundStyle(Color.gray.opacity(0.3))
        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
        
        PointMark(
            x: .value("Volume", item.volume),
            y: .value("Price", item.price)
        )
        .foregroundStyle(Color.purple)
        .annotation(position: .top) {
            VStack(alignment: .leading) {
                Text("Price: $\(Int(item.price))")
                Text("Volume: \(Int(item.volume))")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }
    
    private func handleDrag(_ value: DragGesture.Value, geometry: GeometryProxy, proxy: ChartProxy) {
        let x = value.location.x - geometry[proxy.plotAreaFrame].origin.x
        let y = value.location.y - geometry[proxy.plotAreaFrame].origin.y
        
        guard x >= 0, x < geometry[proxy.plotAreaFrame].width,
              y >= 0, y < geometry[proxy.plotAreaFrame].height else {
            selectedPoint = nil
            return
        }
        
        // Calculate the position in the chart's coordinate space
        let xPosition = x / geometry[proxy.plotAreaFrame].width
        let yPosition = 1 - (y / geometry[proxy.plotAreaFrame].height) // Invert Y axis
        
        // Find the closest point using normalized coordinates
        selectedPoint = data.min(by: { point1, point2 in
            let point1X = (point1.volume - data.map(\.volume).min()!) / (data.map(\.volume).max()! - data.map(\.volume).min()!)
            let point1Y = (point1.price - data.map(\.price).min()!) / (data.map(\.price).max()! - data.map(\.price).min()!)
            let point2X = (point2.volume - data.map(\.volume).min()!) / (data.map(\.volume).max()! - data.map(\.volume).min()!)
            let point2Y = (point2.price - data.map(\.price).min()!) / (data.map(\.price).max()! - data.map(\.price).min()!)
            
            let distance1 = pow(point1X - xPosition, 2) + pow(point1Y - yPosition, 2)
            let distance2 = pow(point2X - xPosition, 2) + pow(point2Y - yPosition, 2)
            return distance1 < distance2
        })
    }
    
    private var customizationOptions: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Customization Options")
                .font(.headline)
                .padding(.horizontal)
            
            Toggle("Show Trend Line", isOn: $showTrendLine)
                .padding(.horizontal)
            
            Button("Regenerate Data") {
                withAnimation {
                    data = ChartData.generateStockData()
                }
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        ScatterPlotView()
    }
} 