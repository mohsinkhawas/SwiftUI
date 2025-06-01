import SwiftUI
import Charts

struct BarChartView: View {
    @State private var data = ChartData.generateMonthlyData()
    @State private var selectedBar: MonthlyData?
    @State private var animateChart = false
    @State private var showGradient = true
    @State private var animationProgress: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Monthly Performance")
                    .font(.title)
                    .padding(.horizontal)
                
                chartContent
                    .frame(height: 300)
                    .padding()
                
                customizationOptions
            }
        }
        .navigationTitle("Bar Chart")
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                animateChart = true
                animationProgress = 1.0
            }
        }
    }
    
    private var chartContent: some View {
        Chart {
            ForEach(data) { item in
                barMark(for: item)
                if let selected = selectedBar, selected.id == item.id {
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
        .chartYScale(domain: 0...(animateChart ? 100 : 0))
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
                                selectedBar = nil
                            }
                    )
            }
        }
    }
    
    private func barMark(for item: MonthlyData) -> some ChartContent {
        BarMark(
            x: .value("Month", item.month),
            y: .value("Value", animateChart ? item.value : 0)
        )
        .foregroundStyle(
            showGradient ? 
            AnyShapeStyle(
                LinearGradient(
                    colors: [.blue.opacity(0.8), .blue.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            ) :
            AnyShapeStyle(Color.blue.opacity(0.8))
        )
    }
    
    @ChartContentBuilder
    private func selectionMarks(for item: MonthlyData) -> some ChartContent {
        RuleMark(
            x: .value("Selected", item.month)
        )
        .foregroundStyle(Color.gray.opacity(0.3))
        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
        
        PointMark(
            x: .value("Month", item.month),
            y: .value("Value", item.value)
        )
        .foregroundStyle(Color.blue)
        .annotation(position: .top) {
            Text("\(Int(item.value))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private func handleDrag(_ value: DragGesture.Value, geometry: GeometryProxy, proxy: ChartProxy) {
        guard let plotFrame = proxy.plotFrame else { return }
        let x = value.location.x - geometry[plotFrame].origin.x
        guard x >= 0, x < geometry[plotFrame].width else {
            selectedBar = nil
            return
        }
        
        let index = Int(x / (geometry[plotFrame].width / CGFloat(data.count)))
        guard index >= 0, index < data.count else { return }
        selectedBar = data[index]
    }
    
    private var customizationOptions: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Customization Options")
                .font(.headline)
                .padding(.horizontal)
            
            Toggle("Show Gradient", isOn: $showGradient)
                .padding(.horizontal)
            
            Button("Regenerate Data") {
                withAnimation {
                    data = ChartData.generateMonthlyData()
                }
            }
            .buttonStyle(.bordered)
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        BarChartView()
    }
} 