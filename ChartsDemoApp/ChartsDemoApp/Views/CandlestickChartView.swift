import SwiftUI
import Charts

struct CandlestickChartView: View {
    @State private var data = ChartData.generateStockData()
    @State private var selectedCandle: StockData?
    @State private var animateChart = false
    @State private var showVolume = true
    
    // Generate OHLC data from price
    private func generateOHLC(from price: Double) -> (open: Double, high: Double, low: Double, close: Double) {
        let variation = price * 0.1 // 10% variation
        let open = price + Double.random(in: -variation...variation)
        let close = price + Double.random(in: -variation...variation)
        let high = max(open, close) + Double.random(in: 0...variation)
        let low = min(open, close) - Double.random(in: 0...variation)
        return (open, high, low, close)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Stock Price Movement")
                    .font(.title)
                    .padding(.horizontal)
                
                Chart {
                    ForEach(data) { item in
                        let ohlc = generateOHLC(from: item.price)
                        
                        // Candlestick
                        RectangleMark(
                            x: .value("Date", item.date),
                            yStart: .value("Open", animateChart ? ohlc.open : 0),
                            yEnd: .value("Close", animateChart ? ohlc.close : 0)
                        )
                        .foregroundStyle(ohlc.close >= ohlc.open ? Color.green : Color.red)
                        
                        // Wicks
                        RuleMark(
                            x: .value("Date", item.date),
                            yStart: .value("Low", animateChart ? ohlc.low : 0),
                            yEnd: .value("High", animateChart ? ohlc.high : 0)
                        )
                        .foregroundStyle(ohlc.close >= ohlc.open ? Color.green : Color.red)
                        
                        if showVolume {
                            RectangleMark(
                                x: .value("Date", item.date),
                                y: .value("Volume", animateChart ? item.volume : 0)
                            )
                            .foregroundStyle(Color.gray.opacity(0.3))
                        }
                        
                        if let selected = selectedCandle, selected.id == item.id {
                            RuleMark(
                                x: .value("Selected", item.date)
                            )
                            .foregroundStyle(Color.gray.opacity(0.3))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 5]))
                            
                            PointMark(
                                x: .value("Date", item.date),
                                y: .value("Price", item.price)
                            )
                            .foregroundStyle(Color.blue)
                            .annotation(position: .top) {
                                VStack(alignment: .leading) {
                                    Text("Open: $\(Int(ohlc.open))")
                                    Text("High: $\(Int(ohlc.high))")
                                    Text("Low: $\(Int(ohlc.low))")
                                    Text("Close: $\(Int(ohlc.close))")
                                    if showVolume {
                                        Text("Volume: \(Int(item.volume))")
                                    }
                                }
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
                        AxisValueLabel(format: .dateTime.month().day())
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
                                            selectedCandle = nil
                                            return
                                        }
                                        
                                        let index = Int(x / (geometry[proxy.plotAreaFrame].width / CGFloat(data.count)))
                                        guard index >= 0, index < data.count else { return }
                                        selectedCandle = data[index]
                                    }
                                    .onEnded { _ in
                                        selectedCandle = nil
                                    }
                            )
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Customization Options")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Toggle("Show Volume", isOn: $showVolume)
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
        .navigationTitle("Candlestick Chart")
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateChart = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        CandlestickChartView()
    }
} 