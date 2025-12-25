//
//  Created by Noman belim
//

import Foundation
import SwiftUI
 
public struct SliderButton: View {

    // 🔹 Stored result (owned by parent)
    @Binding private var paymentStatus: PaymentStatus

    private let sliderColor: Color
    private let text: String

    @State private var offset: CGFloat = 0
    private let height: CGFloat = 56

    // ✅ REQUIRED public initializer for Swift Package
    public init(
        paymentStatus: Binding<PaymentStatus>,
        sliderColor: Color,
        text: String
    ) {
        self._paymentStatus = paymentStatus
        self.sliderColor = sliderColor
        self.text = text
    }

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
                                    paymentStatus = .done
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

 
