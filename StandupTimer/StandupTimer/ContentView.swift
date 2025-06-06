//
//  ContentView.swift
//  StandupTimer
//
//  Created by Mohsin Khawas on 6/5/25.
//

import SwiftUI

struct ContentView: View {
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    @State private var elapsedTime: Int = 0
    @State private var isRunning = false
    @State private var timer: Timer?
    
    private var targetTime: Int {
        minutes * 60 + seconds
    }
    
    private var isOvertime: Bool {
        targetTime > 0 && elapsedTime >= targetTime
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<61) { minute in
                        Text("\(minute)")
                            .foregroundColor(.black)
                            .tag(minute)
                    }
                }
                .labelsHidden()
                
                Text(":")
                    .foregroundColor(.black)
                
                Picker("Seconds", selection: $seconds) {
                    ForEach(0..<60) { second in
                        Text("\(second)")
                            .foregroundColor(.black)
                            .tag(second)
                    }
                }
                .labelsHidden()
            }
            
            Text(timeString)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(isOvertime ? .red : .black)
            
            HStack(spacing: 20) {
                Button(action: resetTimer) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.black)
                }
                
                Button(action: toggleTimer) {
                    Image(systemName: isRunning ? "pause.fill" : "play.fill")
                        .foregroundColor(.black)
                }
            }
            .font(.title2)
        }
        .padding()
        .background(Color.white)
    }
    
    private var timeString: String {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func toggleTimer() {
        if isRunning {
            timer?.invalidate()
            timer = nil
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                elapsedTime += 1
            }
        }
        isRunning.toggle()
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        elapsedTime = 0
    }
}

#Preview {
    ContentView()
}
