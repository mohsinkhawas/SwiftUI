import SwiftUI
import Charts

struct PieChartView: View {
    @State private var data = ChartData.generateMonthlyData()
    @State private var selectedSlice: MonthlyData?
    @State private var animateChart = false
    @State private var showLabels = true
    @State private var animationProgress: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Distribution")
                    .font(.title)
                    .padding(.horizontal)
                
                chartContent
                    .frame(height: 300)
                    .padding()
                
                customizationOptions
            }
        }
        .navigationTitle("Pie Chart")
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
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
                sectorMark(for: item)
                if let selected = selectedSlice, selected.id == item.id {
                    selectionMark(for: item)
                }
            }
        }
        .chartLegend(position: .bottom, alignment: .center, spacing: 20)
    }
    
    private func sectorMark(for item: MonthlyData) -> some ChartContent {
        SectorMark(
            angle: .value("Value", animateChart ? item.value : 0),
            innerRadius: .ratio(0.5),
            angularInset: 1.5
        )
        .foregroundStyle(by: .value("Month", item.month))
        .annotation(position: .overlay) {
            if showLabels {
                Text("\(Int(item.value))")
                    .font(.caption)
                    .foregroundColor(.white)
            }
        }
    }
    
    @ChartContentBuilder
    private func selectionMark(for item: MonthlyData) -> some ChartContent {
        SectorMark(
            angle: .value("Value", item.value),
            innerRadius: .ratio(0.5),
            angularInset: 1.5
        )
        .foregroundStyle(by: .value("Month", item.month))
        .opacity(0.3)
    }
    
    private var customizationOptions: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Customization Options")
                .font(.headline)
                .padding(.horizontal)
            
            Toggle("Show Labels", isOn: $showLabels)
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
        PieChartView()
    }
}
