//
//  SliderActionButton.swift
//  DemoProjact
//
//  Created by Noman belim on 25/12/25.
//

import Foundation
import SwiftUI
import SwiftUI

import SwiftUI

public struct SliderButton: View {

    // 🔹 Stored result (parent owns this)
    @Binding var paymentStatus: PaymentStatus

    let sliderColor: Color
    let text: String

    @State private var offset: CGFloat = 0
    private let height: CGFloat = 56

    public var body: some View {
        GeometryReader { geo in
            let maxOffset = geo.size.width - height

            ZStack(alignment: .leading) {

                Capsule()
                    .fill(sliderColor.opacity(0.15))

                Text(text)
                    .foregroundColor(sliderColor)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)

                Circle()
                    .fill(sliderColor)
                    .frame(width: height, height: height)
                    .overlay(
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .font(.title2)
                    )
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = min(
                                    max(0, value.translation.width),
                                    maxOffset
                                )
                            }
                            .onEnded { _ in
                                if offset > maxOffset * 0.9 {
                                    paymentStatus = .done   // ✅ STORED HERE
                                }
                                reset()
                            }
                    )
            }
        }
        .frame(height: height)
    }

    private func reset() {
        withAnimation(.easeOut) {
            offset = 0
        }
    }
}

enum PaymentStatus {
    case pending
    case done
}
