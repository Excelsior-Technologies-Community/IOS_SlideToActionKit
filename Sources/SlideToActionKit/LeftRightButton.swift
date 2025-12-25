//
//  SlideToActionKit
//
//  Created by Noman Belim
//

import SwiftUI

public struct CallSliderButton: View {

    // 🔹 Result binding
    @Binding private var slideDirection: SlideDirection

    // 🔹 Customization
    private let rightSliderColor: Color
    private let leftSliderColor: Color
    private let centerSliderColor: Color
    private let knobImage: String

    @State private var offset: CGFloat = 0
    private let knobSize: CGFloat = 70

    public init(
        slideDirection: Binding<SlideDirection>,
        rightSliderColor: Color,
        leftSliderColor: Color,
        centerSliderColor: Color,
        knobImage: String
    ) {
        self._slideDirection = slideDirection
        self.rightSliderColor = rightSliderColor
        self.leftSliderColor = leftSliderColor
        self.centerSliderColor = centerSliderColor
        self.knobImage = knobImage
    }

    public var body: some View {
        GeometryReader { geo in
            let maxOffset = (geo.size.width - knobSize) / 2

            ZStack {
                Capsule()
                    .fill(Color.black.opacity(0.1))

                Circle()
                    .fill(currentKnobColor)
                    .frame(width: knobSize, height: knobSize)
                    .overlay(
                        Image(systemName: knobImage)
                            .foregroundColor(.white)
                            .font(.title)
                    )
                    .offset(x: offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = min(
                                    max(-maxOffset, value.translation.width),
                                    maxOffset
                                )
                            }
                            .onEnded { _ in
                                if offset > maxOffset * 0.8 {
                                    slideDirection = .right
                                } else if offset < -maxOffset * 0.8 {
                                    slideDirection = .left
                                } else {
                                    slideDirection = .none
                                }
                                reset()
                            }
                    )
            }
        }
        .frame(height: knobSize)
    }

    private var currentKnobColor: Color {
        if offset > 5 {
            return rightSliderColor
        } else if offset < -5 {
            return leftSliderColor
        } else {
            return centerSliderColor
        }
    }

    private func reset() {
        withAnimation(.spring()) {
            offset = 0
        }
    }
}


struct ResultView: View {

   let slideDirection: SlideDirection

   var body: some View {
       VStack(spacing: 24) {

           Text("User Action")
               .font(.title)

           Text(resultText)
               .font(.largeTitle)
               .fontWeight(.bold)
       }
       .padding()
   }

   private var resultText: String {
       switch slideDirection {
       case .left:
           return "❌ Call Declined"
       case .right:
           return "✅ Call Accepted"
       case .none:
           return "No Action"
       }
   }
}
