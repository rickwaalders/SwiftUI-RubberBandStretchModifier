//
//  RubberBandStretchModifier.swift
//
//  Created by Rick Waalders on 17/02/2024.
//
import SwiftUI

struct RubberBandStretchModifier: ViewModifier {
    
    let scalingFactor: CGFloat
    let stretchFactor: CGFloat
    @GestureState private var dragState = DragState.inactive
    @State private var dragOffset = CGSize.zero
    @State private var scaleX: CGFloat = 1.0
    @State private var scaleY: CGFloat = 1.0

    init(scalingFactor: CGFloat = 200.0, stretchFactor: CGFloat = 0.3) {
        self.scalingFactor = scalingFactor
        self.stretchFactor = stretchFactor
    }

    func body(content: Content) -> some View {
        content
            .scaleEffect(x: scaleX, y: scaleY, anchor: .center)
            .offset(x: dragOffset.width, y: dragOffset.height)
            .gesture(
                DragGesture().updating($dragState) { value, state, _ in
                    state = .dragging(translation: value.translation)
                }
                    .onChanged { value in
                        withAnimation(.interactiveSpring()) {
                            let dragDistance = sqrt(value.translation.width * value.translation.width + value.translation.height * value.translation.height)
                            
                            // calculate scaling factor based on the drag distance
                            // this controls the intensity of the stretch effect
                            // also ensure the drag factor does not exceed 1.0
                            let dragFactor = min(dragDistance / scalingFactor, 1.0)
                            
                            // determine the stretch direction
                            let horizontalStretch = abs(value.translation.width) / dragDistance
                            let verticalStretch = abs(value.translation.height) / dragDistance
                            
                            // apply stretch by adjusting scaleX and scaleY independently
                            scaleX = 1.0 + (dragFactor * stretchFactor * (1 - verticalStretch))
                            scaleY = 1.0 + (dragFactor * stretchFactor * (1 - horizontalStretch))
                            
                            // calculate scaled offset to apply the drag effect
                            // maintain direction
                            let scaledWidth = value.translation.width * scalingFactor / (dragDistance + scalingFactor)
                            let scaledHeight = value.translation.height * scalingFactor / (dragDistance + scalingFactor)
                            self.dragOffset = CGSize(width: scaledWidth, height: scaledHeight)
                        }
                    }

                .onEnded { _ in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.55)) {
                        self.dragOffset = .zero
                        self.scaleX = 1.0
                        self.scaleY = 1.0
                    }
                }
            )
    }
    
    enum DragState {
        case inactive
        case dragging(translation: CGSize)
    }
}

extension View {
    func rubberBandStretchEffect(scalingFactor: CGFloat = 200.0, stretchFactor: CGFloat = 0.3) -> some View {
        self.modifier(RubberBandStretchModifier(scalingFactor: scalingFactor, stretchFactor: stretchFactor))
    }
}



//// usage example
//struct RubberBandStretchEffectView: View {
//    var body: some View {
//        Circle()
//            .frame(width: 100, height: 100)
//            .foregroundColor(.green)
//            .rubberBandStretchEffect(scalingFactor: 550.0, stretchFactor: 0.3)
//    }
//}
//
//struct RubberBandStretchEffectView_Previews: PreviewProvider {
//    static var previews: some View {
//        RubberBandStretchEffectView()
//    }
//}
