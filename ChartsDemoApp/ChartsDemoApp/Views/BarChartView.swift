import SwiftUI
import Charts

struct BarChartView: View {
    @State private var data = ChartData.generateMonthlyData()
    @State private var selectedBar: MonthlyData?
    @State private var animateChart = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Monthly Performance")
                    .font(.title)
                    .padding(.horizontal)
                
                Chart {
                    ForEach(data) { item in
                        BarMark(
                            x: .value("Month", item.month),
                            y: .value("Value", animateChart ? item.value : 0)
                        )
                        .foregroundStyle(Color.blue.gradient)
                        .annotation(position: .top) {
                            if selectedBar?.id == item.id {
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
                                            selectedBar = nil
                                            return
                                        }
                                        
                                        let index = Int(x / (geometry[proxy.plotAreaFrame].width / CGFloat(data.count)))
                                        guard index >= 0, index < data.count else { return }
                                        selectedBar = data[index]
                                    }
                                    .onEnded { _ in
                                        selectedBar = nil
                                    }
                            )
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Customization Options")
                        .font(.headline)
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
        .navigationTitle("Bar Chart")
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateChart = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        BarChartView()
    }
} 