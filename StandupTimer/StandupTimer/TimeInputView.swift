import SwiftUI

struct TimeInputView: View {
    @Binding var minutes: Int
    @Binding var seconds: Int
    @Binding var showingInputView: Bool
    @State private var minutesString: String
    @State private var secondsString: String
    
    init(minutes: Binding<Int>, seconds: Binding<Int>, showingInputView: Binding<Bool>) {
        self._minutes = minutes
        self._seconds = seconds
        self._showingInputView = showingInputView
        self._minutesString = State(initialValue: String(format: "%02d", minutes.wrappedValue))
        self._secondsString = State(initialValue: String(format: "%02d", seconds.wrappedValue))
    }
    
    var body: some View {
        VStack(spacing: 6) {
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
            .padding(.bottom, 4)
            
            Button(action: {
                showingInputView = false
            }) {
                Text("Save")
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
            }
            .background(Color(white: 0.95))
            .cornerRadius(6)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(width: 200, height: 140)
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
