//
//  MakeWordView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 29.05.2025.
//


import SwiftUI


struct MakeWordView: View {
    @StateObject private var viewModel = MakeWordViewModel()
    @Binding var selectedTab: MainTabView.Tab
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            // Прогрес
            ProgressView(value: Double(viewModel.currentIndex + 1), total: Double(viewModel.questions.count))
                .padding(.horizontal)
                .accentColor(.mint)
            
            Spacer()
            
            VStack(spacing: 12) {
                Text("Склади слово")
                    .font(AppFont.comicSansMsBold.font(size: 36))
                    .fontWeight(.bold)
                
                Image(viewModel.currentQuestion.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .shadow(radius: 5)
            }
            
            // Слоти
            HStack(spacing: 12) {
                ForEach(0..<viewModel.selectedLetters.count, id: \.self) { idx in
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .frame(width: 50, height: 60)
                            .shadow(radius: 2)
                        
                        if let ch = viewModel.selectedLetters[idx] {
                            Text(String(ch))
                                .font(AppFont.comfortaaBold.font(size: 30))
                                .foregroundColor(.primary)
                        } else {
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(.gray.opacity(0.5))
                                .padding(.horizontal, 12)
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            viewModel.removeLetter(at: idx)
                        }
                    }
                }
            }
            .padding(.top)
            
            // Букви-кнопки
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                ForEach(viewModel.letterOptions) { letter in
                    Button(action: {
                        withAnimation {
                            viewModel.letterTapped(letter)
                        }
                    }) {
                        Text(String(letter.char))
                            .font(AppFont.comfortaaBold.font(size: 30))
                            .frame(width: 60, height: 60)
                            .background(letter.isUsed ? Color(hex: "FFFEFF") : Color(hex: "EF3349"))
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .disabled(letter.isUsed)
                }
            }
            .padding()
            
            //  перевірка
            PrimaryButton(
                title: "Перевірити",
                systemImage: "checkmark",
                isDisabled: viewModel.selectedLetters.contains(where: { $0 == nil }),
                action: {
                    viewModel.checkAnswer()
                }
            )
            .padding(.top)
            
            Spacer()
        }
        .padding()
        .background(Color.mainBackground.ignoresSafeArea())
        .fullScreenCover(isPresented: $viewModel.showResult) {
            ResultView(
                correctAnswers: viewModel.questions.count,
                totalQuestions: viewModel.questions.count,
                gameName: .makeWord,
                onRestart: {
                    viewModel.restartGame()
                },
                selectedTab: $selectedTab
            )
        }
    }
}

#Preview {
    MakeWordView(selectedTab: .constant(.home))
}
