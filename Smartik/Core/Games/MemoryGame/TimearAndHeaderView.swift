//
//  TimerAndHeaderView.swift
//  Smartik
//
//  Created by Mariia Misarosh on 21.05.2025.
//

import SwiftUI

struct TimerAndHeaderView: View {
    @ObservedObject var viewModel: MemoryGameViewModel

    var body: some View {
        HStack {
            Text("⏱️ \(viewModel.timeRemaining)s")
                .font(AppFont.comicSansMsBold.font(size: 20))
                .foregroundColor(viewModel.timeRemaining < 10 ? .red : .primary)

            Spacer()

            Text("⭐️ Збіги: \(viewModel.matchedCount)")
                .font(AppFont.comicSansMsBold.font(size: 20))
        }
        .padding(.horizontal)
    }
}


#Preview {
    TimerAndHeaderView(viewModel: MemoryGameViewModel())
}
