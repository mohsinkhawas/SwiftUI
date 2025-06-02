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
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
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
        guard let plotFrame = proxy.plotFrame else { return }
        let x = value.location.x - geometry[plotFrame].origin.x
        let y = value.location.y - geometry[plotFrame].origin.y
        
        // Normalize coordinates
        let normalizedX = x / geometry[plotFrame].width
        let normalizedY = 1 - (y / geometry[plotFrame].height) // Invert Y axis
        
        // Find closest point
        var closestPoint: StockData?
        var minDistance = CGFloat.infinity
        
        for point in data {
            let pointX = CGFloat(point.volume) / 100.0 // Normalize X (0-100 to 0-1)
            let pointY = CGFloat(point.price) / 100.0 // Normalize Y (0-100 to 0-1)
            
            let distance = sqrt(pow(pointX - normalizedX, 2) + pow(pointY - normalizedY, 2))
            if distance < minDistance {
                minDistance = distance
                closestPoint = point
            }
        }
        
        // Only select if within a reasonable distance
        if minDistance < 0.1 { // 10% of the chart size
            selectedPoint = closestPoint
        } else {
            selectedPoint = nil
        }
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
