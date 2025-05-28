//
//  ContentView.swift
//  UI Elements
//
//  Created by Mohsin Khawas on 5/28/25.
//

import SwiftUI
import Charts

struct UIElement: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let description: String
}

struct ContentView: View {
    let uiElements = [
        UIElement(name: "Button", category: "Basic Controls", description: "A standard button with various styles"),
        UIElement(name: "TextField", category: "Basic Controls", description: "Text input field with various configurations"),
        UIElement(name: "Toggle", category: "Basic Controls", description: "A switch control for boolean values"),
        UIElement(name: "Slider", category: "Basic Controls", description: "A slider control for selecting a value within a range"),
        UIElement(name: "Stepper", category: "Basic Controls", description: "A control for incrementing or decrementing a value"),
        UIElement(name: "List", category: "Containers", description: "A container that presents rows of data arranged in a single column"),
        UIElement(name: "ForEach", category: "Containers", description: "A view that creates a view for each element in a collection"),
        UIElement(name: "NavigationLink", category: "Navigation", description: "A button that triggers a navigation presentation"),
        UIElement(name: "TabView", category: "Navigation", description: "A view that switches between multiple child views using interactive interface elements"),
        UIElement(name: "DatePicker", category: "Input Controls", description: "A control for selecting a date and time"),
        UIElement(name: "ColorPicker", category: "Input Controls", description: "A control for selecting a color"),
        UIElement(name: "Picker", category: "Input Controls", description: "A control for selecting from a set of mutually exclusive values"),
        UIElement(name: "ProgressView", category: "Indicators", description: "A view that shows the progress towards completion of a task"),
        UIElement(name: "Gauge", category: "Indicators", description: "A view that displays a value within a range"),
        UIElement(name: "Charts", category: "Data Visualization", description: "A view that displays data in a chart format"),
        UIElement(name: "VStack", category: "Layout", description: "Vertical stack of views"),
        UIElement(name: "HStack", category: "Layout", description: "Horizontal stack of views"),
        UIElement(name: "LazyVGrid", category: "Layout", description: "A container that arranges its children in a grid that grows vertically"),
        UIElement(name: "ZStack", category: "Layout", description: "A view that overlays its children, aligning them in both axes")
    ]
    
    var body: some View {
        NavigationView {
            List(uiElements) { element in
                NavigationLink(destination: ElementDetailView(element: element)) {
                    VStack(alignment: .leading) {
                        Text(element.name)
                            .font(.headline)
                        Text(element.category)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("SwiftUI Elements")
        }
    }
}

// ElementDetailView.swift
struct ElementDetailView: View {
    let element: UIElement
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text(element.name)
                    .font(.largeTitle)
                    .bold()
                Text(element.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Demo area
                demoView(for: element.name)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
            }
            .padding()
        }
    }

    @ViewBuilder
    private func demoView(for name: String) -> some View {
        switch name {
        case "Button":
            ButtonDemo()
        case "TextField":
            TextFieldDemo()
        case "Toggle":
            ToggleDemo()
        case "Slider":
            SliderDemo()
        case "Stepper":
            StepperDemo()
        case "VStack":
            VStackDemo()
        case "HStack":
            HStackDemo()
        case "ZStack":
            ZStackDemo()
        case "LazyVGrid":
            LazyVGridDemo()
        case "List":
            ListDemo()
        case "ForEach":
            ForEachDemo()
        case "NavigationLink":
            NavigationLinkDemo()
        case "TabView":
            TabViewDemo()
        case "DatePicker":
            DatePickerDemo()
        case "ColorPicker":
            ColorPickerDemo()
        case "Picker":
            PickerDemo()
        case "ProgressView":
            ProgressViewDemo()
        case "Gauge":
            GaugeDemo()
        case "Charts":
            ChartsDemo()
        default:
            Text("Demo not implemented yet.")
        }
    }
}

// Example of a demo view for Button
struct ButtonDemo: View {
    @State private var buttonText = "Tap Me"
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                buttonText = "Tapped!"
            }) {
                Text(buttonText)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            // Add more button variations here
        }
        .padding()
    }
}

struct TextFieldDemo: View {
    @State private var text = ""
    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter text", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("You typed: \(text)")
        }
    }
}

struct ToggleDemo: View {
    @State private var isOn = false
    var body: some View {
        VStack(spacing: 16) {
            Toggle("Enable Feature", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .purple))
                .padding()
            RoundedRectangle(cornerRadius: 12)
                .fill(isOn ? Color.purple : Color.gray)
                .frame(width: 100, height: 100)
                .overlay(Text(isOn ? "ON" : "OFF").foregroundColor(.white))
                .animation(.easeInOut, value: isOn)
        }
    }
}

struct SliderDemo: View {
    @State private var value: Double = 0.5
    var body: some View {
        VStack(spacing: 16) {
            Slider(value: $value)
            Text("Value: \(String(format: "%.2f", value))")
        }
    }
}

struct StepperDemo: View {
    @State private var count = 0
    var body: some View {
        VStack(spacing: 16) {
            Stepper("Count: \(count)", value: $count)
        }
    }
}

struct VStackDemo: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Top")
            Divider()
            Text("Middle")
            Divider()
            Text("Bottom")
        }
        .padding()
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(8)
    }
}

struct HStackDemo: View {
    var body: some View {
        HStack(spacing: 8) {
            Text("Left")
            Divider()
            Text("Center")
            Divider()
            Text("Right")
        }
        .padding()
        .background(Color.green.opacity(0.2))
        .cornerRadius(8)
    }
}

struct ZStackDemo: View {
    var body: some View {
        ZStack {
            Circle().fill(Color.blue.opacity(0.3)).frame(width: 120, height: 120)
            Text("On Top")
                .font(.title)
                .foregroundColor(.blue)
        }
        .padding()
    }
}

struct LazyVGridDemo: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0..<6) { i in
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.orange.opacity(0.7))
                    .frame(height: 50)
                    .overlay(Text("Item \(i+1)").foregroundColor(.white))
            }
        }
        .padding()
    }
}

struct ListDemo: View {
    let items = ["Apple", "Banana", "Cherry", "Date"]
    var body: some View {
        List(items, id: \ .self) { item in
            Text(item)
        }
        .frame(height: 180)
    }
}

struct ForEachDemo: View {
    var body: some View {
        HStack {
            ForEach(0..<5) { i in
                Circle()
                    .fill(Color.pink.opacity(0.7))
                    .frame(width: 30, height: 30)
                    .overlay(Text("\(i+1)").foregroundColor(.white))
            }
        }
        .padding()
    }
}

struct NavigationLinkDemo: View {
    var body: some View {
        NavigationLink(destination: Text("You navigated!")) {
            Text("Tap to Navigate")
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

struct TabViewDemo: View {
    var body: some View {
        TabView {
            Text("First Tab")
                .tabItem { Label("First", systemImage: "1.circle") }
            Text("Second Tab")
                .tabItem { Label("Second", systemImage: "2.circle") }
        }
        .frame(height: 120)
    }
}

struct DatePickerDemo: View {
    @State private var date = Date()
    var body: some View {
        DatePicker("Select Date", selection: $date, displayedComponents: .date)
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
    }
}

struct ColorPickerDemo: View {
    @State private var color = Color.red
    var body: some View {
        VStack(spacing: 16) {
            ColorPicker("Pick a color", selection: $color)
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 100, height: 50)
        }
        .padding()
    }
}

struct PickerDemo: View {
    @State private var selection = 0
    let options = ["Option 1", "Option 2", "Option 3"]
    var body: some View {
        Picker("Select an option", selection: $selection) {
            ForEach(0..<options.count) { i in
                Text(options[i]).tag(i)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        Text("Selected: \(options[selection])")
    }
}

struct ProgressViewDemo: View {
    @State private var progress = 0.3
    var body: some View {
        VStack(spacing: 16) {
            ProgressView(value: progress)
            Button("Increase Progress") {
                withAnimation { progress = min(progress + 0.1, 1.0) }
            }
        }
        .padding()
    }
}

struct GaugeDemo: View {
    @State private var value = 0.5
    var body: some View {
        VStack(spacing: 16) {
            if #available(iOS 16.0, *) {
                Gauge(value: value) {
                    Text("Gauge")
                }
                .gaugeStyle(.accessoryCircular)
                .frame(width: 80, height: 80)
            } else {
                Text("Gauge requires iOS 16+")
            }
            Slider(value: $value)
        }
        .padding()
    }
}

struct ChartsDemo: View {
    @State private var values: [Double] = [0.2, 0.5, 0.7, 0.4]
    var body: some View {
        VStack(spacing: 16) {
            if #available(iOS 16.0, *) {
                Chart {
                    ForEach(Array(values.enumerated()), id: \ .offset) { idx, val in
                        BarMark(
                            x: .value("Index", idx),
                            y: .value("Value", val)
                        )
                        .foregroundStyle(Color.blue.gradient)
                    }
                }
                .frame(height: 120)
            } else {
                Text("Charts require iOS 16+")
            }
            Button("Randomize") {
                withAnimation { values = values.map { _ in Double.random(in: 0.1...1.0) } }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
