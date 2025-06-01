//
//  MathSettingsView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 31.05.2025.
//


import SwiftUI

struct MathSettingsView: View {
    @State private var selectedOperation: OperationType = .addition
    @State private var maxRange: Int = 10
    @State private var numQuestions: Int = 5
    @State private var isPlaying = false
    
    @Binding var selectedTab: MainTabView.Tab
    
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("Налаштування гри")
                .font(.largeTitle.bold())
                .padding(.bottom, 32)
            
            Picker("Операція", selection: $selectedOperation) {
                ForEach(OperationType.allCases, id: \.self) { operation in
                    Text(operation.symbol)
                        .tag(operation)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Stepper("Максимальне число: \(maxRange)", value: $maxRange, in: 5...50)
                .padding(.horizontal)
            
            Stepper("Кількість питань: \(numQuestions)", value: $numQuestions, in: 3...20)
                .padding(.horizontal)
            
            Spacer()
            
            PrimaryButton(
                title: "Почати гру",
                systemImage: "play.fill",
                isDisabled: false,
                action: {
                    isPlaying = true
                }
            )
            .padding(.bottom, 32)
        }
        .padding()
        .background(Color.mainBackground.ignoresSafeArea())
        .fullScreenCover(isPresented: $isPlaying) {
            MathView(
                totalQuestions: numQuestions,
                maxRange: maxRange,
                operation: selectedOperation,
                selectedTab: $selectedTab
            )
        }
    }
}

#Preview {
    MathSettingsView(selectedTab: .constant(.home))
    
}
