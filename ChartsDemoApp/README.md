# ChartsDemoApp

A SwiftUI demo application showcasing a variety of interactive and customizable charts using Apple's Charts framework.

## Demo Video



https://github.com/user-attachments/assets/30387cf1-83a1-4859-bf1f-79fcc43cc7ae

## Features

- **Bar Chart**: Displays monthly data with each bar in a different color.
- **Line Chart**: Shows time series data with optional gradient area and interactive point selection.
- **Area Chart**: Visualizes grouped area data by category with interactive selection.
- **Pie Chart**: Presents categorical data as a pie chart with animated slices and selection highlighting.
- **Scatter Plot**: Plots data points by category, with optional trend line and interactive selection.
- **Candlestick Chart**: Visualizes stock OHLC data with volume, interactive selection, and custom coloring.

## Getting Started

### Prerequisites
- Xcode 14 or later
- macOS Ventura or later
- Swift 5.7+

### Setup
1. Clone this repository:
   ```sh
   git clone <your-repo-url>
   cd ChartsDemoApp
   ```
2. Open `ChartsDemoApp.xcodeproj` in Xcode.
3. Build and run the app on the simulator or a real device.

## Project Structure

- `Models/ChartData.swift` — Data models and sample data generators for all chart types.
- `Models/ChartConfig.swift` — Shared chart configuration, colors, and view modifiers.
- `Views/BaseChartView.swift` — Generic reusable chart container for all chart types.
- `Views/BarChartView.swift`, `LineChartView.swift`, etc. — Individual chart implementations.
- `Views/ChartGridView.swift` — Main screen with a grid of chart options.

## Customization
- Easily add new chart types by extending the models and creating a new view.
- Change chart colors in `ChartConfig.swift`.
- Modify chart behaviors and animations in each chart view.

## Dependencies
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [Charts](https://developer.apple.com/documentation/charts)

## License

This project is for educational and demonstration purposes. Feel free to use and modify it for your own learning or projects. 
