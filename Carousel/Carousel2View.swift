//
//  Carousel2View.swift
//  Carousel
//
//  Created by Den Jo on 2022/08/22.
//

import SwiftUI

struct Carousel2View: View {
    
    // MARK: - Value
    // MARK: Private
    @State private var pointX: CGFloat = 0
    @State private var size: CGSize    = .zero
    @State private var currentIndex    = 0
    @State private var isDragging      = false

    @State private var length: CGFloat  = 0
    @State private var previousIndex: Int? = nil
    
    @GestureState private var offsetState: CGSize = .zero
    
    private let itemCount        = 10
    private let spacing: CGFloat = 20
    
    private var totalWidth: CGFloat {
        length * CGFloat(itemCount) + spacing *  CGFloat(max(0, itemCount - 1))
    }
    
    private var firstItemPositionX: CGFloat {
        (length * CGFloat(max(0, itemCount - 1)) + spacing *  CGFloat(max(0, itemCount - 1))) / 2 + size.width / 2
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                HStack(spacing: spacing) {
                    ForEach(0..<itemCount, id: \.self) { i in
                        ZStack {
                            cardView
                                
                            Text("\(i)")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .frame(width: length, height: length)
                        .frame { value in
                            var ratio: CGFloat {
                                switch value.origin.x {
                                case (-spacing)...(proxy.size.width * 3 / 2):
                                    return proxy.size.width + spacing
                                    
                                case (spacing * 3 / 2 - proxy.size.width)..<spacing:
                                    return 1 - ((spacing - value.origin.x) / (proxy.size.width + spacing))
                                    
                                default:
                                    return 0
                                }
                            }
                            
                            
//                            print(" \(ratio)  \(Int(value.origin.x))  \(proxy.size.width / 2 - length / 2) ~  \(proxy.size.width + length / 2 + spacing)  ||   \(-(length + spacing / 2)) ~ \(proxy.size.width / 2 - length / 2)")
                            
                            
                            // Update currentIndex
                            guard 0.5 < ratio else { return }
                            currentIndex = i
                        }
                    }
                }
                .position(x: firstItemPositionX + pointX + offsetState.width, y: proxy.size.height / 2)
                .task {
                    size   = proxy.size
                    length = proxy.size.width - spacing * 2
                }
            }
            
            
            currentItemView
            guideLineView
        }
        .frame(height: 300)
        .background(Color.white)
        .gesture(
            DragGesture()
                .updating($offsetState) { currentState, gestureState, transaction in
                    gestureState = currentState.translation
                }
                .onChanged { value in
                    isDragging = true
                    
                    guard previousIndex == nil else { return }
                    previousIndex = currentIndex
                }
                .onEnded { value in
                    isDragging = false
                    pointX += value.translation.width
                    
                    var targetPointX = -(CGFloat(currentIndex) * length + (CGFloat(currentIndex) * spacing))
                    let delta = abs(currentIndex - (previousIndex ?? 0))
                    
                    
                    // Calcualte velocity
                    if 150 < value.predictedEndTranslation.width, delta < 1 {         // Left
                        targetPointX = -(CGFloat(max(0, currentIndex - 1)) * length + (CGFloat(max(0, currentIndex - 1)) * spacing))
                        
                    } else if value.predictedEndTranslation.width < -150, delta < 1 { // Right
                        targetPointX = -(CGFloat(min(itemCount - 1, currentIndex)) * length + (CGFloat(min(itemCount - 1, currentIndex)) * spacing))
                    }
                    
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.9, blendDuration: 0)) {
                        pointX = targetPointX
                    }
                }
        )
    }
    
    // MARK: Private
    private var cardView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(.displayP3, red: 126 / 255, green: 67 / 255, blue: 250 / 255))
            .frame(width: length, height: length)
    }
    
    private var currentItemView: some View {
        Text("\(currentIndex)")
            .font(.system(size: 30, weight: .bold))
            .offset(y: -200)
    }
    
    private var guideLineView: some View {
        Color.green
            .frame(width: 1, height: 800)
    }
}

#if DEBUG
struct Carousel2View_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = Carousel2View()
        
        view
            .previewDevice("iPhone 11 Pro")
    }
}
#endif
