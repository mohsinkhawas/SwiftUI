//
//  ContentView.swift
//  StandupTimer
//
//  Created by Mohsin Khawas on 6/5/25.
//

import SwiftUI

struct ContentView: View {
    @State private var minutes: Int = 1  // Default 1 minute
    @State private var seconds: Int = 30 // Default 30 seconds
    @State private var minutesString: String = "01"
    @State private var secondsString: String = "30"
    @State private var elapsedTime: Int = 0
    @State private var isRunning = false
    @State private var timer: Timer?
    @State private var shakeOffset: CGFloat = 0
    @State private var showingTimeInput = false
    
    private var targetTime: Int {
        minutes * 60 + seconds
    }
    
    private var isOvertime: Bool {
        targetTime > 0 && elapsedTime >= targetTime
    }
    
    var body: some View {
        ZStack {
            // Main Timer View
            VStack(spacing: 12) {
                Text(timeString)
                    .font(.system(size: 58, weight: .bold))
                    .foregroundColor(isOvertime ? .red : .black)
                    .offset(x: shakeOffset)
                    .onChange(of: isOvertime) { newValue in
                        if newValue {
                            withAnimation(.easeInOut(duration: 0.1).repeatCount(3)) {
                                shakeOffset = 5
                            } completion: {
                                shakeOffset = 0
                            }
                        }
                    }
                
                HStack(spacing: 20) {
                    Button(action: resetTimer) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.black)
                    }
                    
                    Button(action: toggleTimer) {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                            .foregroundColor(.black)
                    }
                    
                    Button(action: { showingTimeInput = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.black)
                    }
                }
                .font(.title2)
            }
            .padding()
            .background(Color.white)
            
            // Popup Time Input View
            if showingTimeInput {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showingTimeInput = false
                    }
                
                VStack(spacing: 8) {
                    Text("Enter the time limit")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            HStack(spacing: 4) {
                                TextField("", text: $minutesString)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 40)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                                    #if os(iOS)
                                    .keyboardType(.numberPad)
                                    #endif
                                    .onChange(of: minutesString) { _ in
                                        validateAndUpdateTime()
                                    }
                                Text("m")
                                    .foregroundColor(.black)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            HStack(spacing: 4) {
                                TextField("", text: $secondsString)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 40)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                                    #if os(iOS)
                                    .keyboardType(.numberPad)
                                    #endif
                                    .onChange(of: secondsString) { _ in
                                        validateAndUpdateTime()
                                    }
                                Text("s")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    
                    Button("Done") {
                        showingTimeInput = false
                    }
                    .foregroundColor(.black)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
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
        // Reset text fields to current values
        minutesString = String(format: "%02d", minutes)
        secondsString = String(format: "%02d", seconds)
    }
    
    private func validateAndUpdateTime() {
        let newMinutes = Int(minutesString) ?? 0
        let newSeconds = Int(secondsString) ?? 0
        
        minutes = min(max(newMinutes, 0), 60)
        seconds = min(max(newSeconds, 0), 59)
        
        minutesString = String(format: "%02d", minutes)
        secondsString = String(format: "%02d", seconds)
    }
}

#Preview {
    ContentView()
}
