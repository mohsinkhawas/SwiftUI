import SwiftUI
import Charts

struct LineChartView: View {
    @State private var data = ChartData.generateMonthlyData()
    @State private var selectedPoint: MonthlyData?
    @State private var animateChart = false
    @State private var showPoints = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Monthly Trends")
                    .font(.title)
                    .padding(.horizontal)
                
                Chart {
                    ForEach(data) { item in
                        LineMark(
                            x: .value("Month", item.month),
                            y: .value("Value", animateChart ? item.value : 0)
                        )
                        .foregroundStyle(Color.green.gradient)
                        .interpolationMethod(.catmullRom)
                        
                        if showPoints {
                            PointMark(
                                x: .value("Month", item.month),
                                y: .value("Value", animateChart ? item.value : 0)
                            )
                            .foregroundStyle(Color.green)
                            .symbolSize(selectedPoint?.id == item.id ? 100 : 50)
                        }
                        
                        if let selected = selectedPoint, selected.id == item.id {
                            RuleMark(
                                x: .value("Selected", item.month)
                            )
                            .foregroundStyle(Color.gray.opacity(0.3))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                            
                            PointMark(
                                x: .value("Month", item.month),
                                y: .value("Value", item.value)
                            )
                            .foregroundStyle(Color.green)
                            .annotation(position: .top) {
                                Text("\(Int(item.value))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .frame(height: 300)
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
                                        let x = value.location.x - geometry[proxy.plotAreaFrame].origin.x
                                        guard x >= 0, x < geometry[proxy.plotAreaFrame].width else {
                                            selectedPoint = nil
                                            return
                                        }
                                        
                                        let index = Int(x / (geometry[proxy.plotAreaFrame].width / CGFloat(data.count)))
                                        guard index >= 0, index < data.count else { return }
                                        selectedPoint = data[index]
                                    }
                                    .onEnded { _ in
                                        selectedPoint = nil
                                    }
                            )
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Customization Options")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Toggle("Show Points", isOn: $showPoints)
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
        .navigationTitle("Line Chart")
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateChart = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        LineChartView()
    }
} 