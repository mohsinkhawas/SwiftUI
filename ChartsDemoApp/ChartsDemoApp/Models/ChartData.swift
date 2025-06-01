import Foundation

// Sample data for different types of charts
struct MonthlyData: Identifiable {
    let id = UUID()
    let month: String
    let value: Double
}

struct SalesData: Identifiable {
    let id = UUID()
    let category: String
    let sales: Double
}

struct StockData: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
    let volume: Double
}

// Chart type enum
enum ChartType: String, CaseIterable, Identifiable {
    case bar = "Bar Chart"
    case line = "Line Chart"
    case area = "Area Chart"
    case pie = "Pie Chart"
    case scatter = "Scatter Plot"
    case candlestick = "Candlestick Chart"
    
    var id: String { self.rawValue }
    
    var systemImage: String {
        switch self {
        case .bar: return "chart.bar"
        case .line: return "chart.line.uptrend.xyaxis"
        case .area: return "chart.area"
        case .pie: return "chart.pie"
        case .scatter: return "chart.xyaxis.line"
        case .candlestick: return "chart.candlestick"
        }
    }
}

// Container for chart data generation methods
struct ChartData {
    // Sample data generators
    static func generateMonthlyData() -> [MonthlyData] {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return months.map { month in
            MonthlyData(month: month, value: Double.random(in: 10...100))
        }
    }
    
    static func generateSalesData() -> [SalesData] {
        let categories = ["Electronics", "Clothing", "Food", "Books", "Sports"]
        return categories.map { category in
            SalesData(category: category, sales: Double.random(in: 1000...10000))
        }
    }
    
    static func generateStockData() -> [StockData] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<30).map { day in
            let date = calendar.date(byAdding: .day, value: -day, to: today)!
            return StockData(
                date: date,
                price: Double.random(in: 100...200),
                volume: Double.random(in: 1000...5000)
            )
        }.reversed()
    }
} 