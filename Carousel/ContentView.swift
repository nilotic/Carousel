//
//  ContentView.swift
//  Carousel
//
//  Created by Den Jo on 2022/03/18.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Value
    // MARK: Private
    @State private var pointX: CGFloat = 0
    @State private var scales          = [Int: CGFloat]()
    @State private var size: CGSize    = .zero
    @State private var currentIndex    = 0
    @State private var isDragging      = false

    @State private var previousIndex: Int? = nil
    
    @GestureState private var offsetState: CGSize = .zero
    
    private let itemCount             = 10
    private let spacing: CGFloat      = 12
    private let length: CGFloat       = 112
    private let minimumScale: CGFloat = 0.857
    private let deltaScale: CGFloat   = 0.143
    
    private var totalWidth: CGFloat {
        length * CGFloat(itemCount) + spacing *  CGFloat(max(0, itemCount - 1))
    }
    
    private var firstItemPositionX: CGFloat {
        (length * CGFloat(itemCount) + spacing *  CGFloat(itemCount)) / 2 + spacing + length
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
                        .scaleEffect(scales[i] ?? 1)
                        .frame { value in
                            let range = length + spacing
                            
                            var ratio: CGFloat {
                                switch value.origin.x {
                                case (proxy.size.width / 2 - length / 2)...(proxy.size.width + length / 2 + spacing):
                                    let offset = (proxy.size.width + length / 2 + spacing) - (proxy.size.width / 2) - value.origin.x
                                    return offset / range
                                    
                                case (spacing / 2)..<(proxy.size.width / 2 - length / 2):
                                    let offset = ((proxy.size.width - length) / 2) - value.origin.x
                                    return 1 - offset / range
                                    
                                default:
                                    return 0
                                }
                            }
                            
                            // Update currentIndex
                            if 0.5 < ratio {
                                currentIndex = i
                            }
                            
                            // Scale animation
                            let scale = minimumScale + deltaScale * ratio
                            withAnimation(isDragging ? nil : .spring(response: 0.5, dampingFraction: 0.9, blendDuration: 0)) {
                                scales[i] = max(minimumScale, min(1, scale))
                            }
                        }
                    }
                }
                .position(x: firstItemPositionX + pointX + offsetState.width, y: proxy.size.height / 2)
                .task {
                    size = proxy.size
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
        Circle()
            .fill(Color(.displayP3, red: 126 / 255, green: 67 / 255, blue: 250 / 255))
            .frame(width: 112, height: 112)
            .shadow(color: Color(.displayP3, red: 34 / 255, green: 34 / 255, blue: 34 / 255).opacity(0.08), radius: 24, x: 0, y: 12)
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
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = ContentView()
        
        view
            .previewDevice("iPhone 11 Pro")
    }
}
#endif
