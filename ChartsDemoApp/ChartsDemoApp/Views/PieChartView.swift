import SwiftUI
import Charts

struct PieChartView: View {
    @State private var data = ChartData.generateSalesData()
    @State private var selectedSegment: SalesData?
    @State private var animateChart = false
    @State private var showLabels = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Sales Distribution")
                    .font(.title)
                    .padding(.horizontal)
                
                Chart {
                    ForEach(data) { item in
                        SectorMark(
                            angle: .value("Sales", animateChart ? item.sales : 0),
                            innerRadius: .ratio(0.5),
                            angularInset: 1.5
                        )
                        .foregroundStyle(by: .value("Category", item.category))
                        .annotation(position: .overlay) {
                            if showLabels && selectedSegment?.id == item.id {
                                Text("$\(Int(item.sales))")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                    }
                }
                .frame(height: 300)
                .chartLegend(position: .bottom, alignment: .center, spacing: 20)
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let center = CGPoint(
                                            x: geometry[proxy.plotAreaFrame].midX,
                                            y: geometry[proxy.plotAreaFrame].midY
                                        )
                                        let angle = atan2(
                                            value.location.y - center.y,
                                            value.location.x - center.x
                                        )
                                        let normalizedAngle = (angle + .pi * 2).truncatingRemainder(dividingBy: .pi * 2)
                                        let segmentAngle = .pi * 2 / CGFloat(data.count)
                                        let index = Int(normalizedAngle / segmentAngle)
                                        
                                        guard index >= 0, index < data.count else { return }
                                        selectedSegment = data[index]
                                    }
                                    .onEnded { _ in
                                        selectedSegment = nil
                                    }
                            )
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Customization Options")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Toggle("Show Labels", isOn: $showLabels)
                        .padding(.horizontal)
                    
                    Button("Regenerate Data") {
                        withAnimation {
                            data = ChartData.generateSalesData()
                        }
                    }
                    .buttonStyle(.bordered)
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Pie Chart")
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateChart = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        PieChartView()
    }
} 