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
    @State private var scale: CGFloat  = 1
    @State private var scales          = [Int: CGFloat]()
    
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
    
    private var currentItem: Int {
        let startPoint = firstItemPositionX + length / 2
        
        return 0
    }
    
    
    // MARK: - Value
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
                            
                            let scale = minimumScale + deltaScale * ratio
                            scales[i] = max(minimumScale, min(1, scale))
                        }
                    }
                }
                .background(Color.red)
                .position(x: firstItemPositionX + pointX + offsetState.width, y: proxy.size.height / 2)
            }
            
            
            Text("\(currentItem)")
                .font(.system(size: 30, weight: .bold))
                .offset(y: -200)
            
            Color.green
                .frame(width: 1, height: 800)
        }
        .clipped()
        .onChange(of: pointX) {
            let positionX = firstItemPositionX + $0 + offsetState.width
            // print("\(positionX)")
        }
        .onChange(of: offsetState.width) {
            let positionX = firstItemPositionX + pointX + $0
            // print(" --- \(positionX)")
            
        }
        .gesture(
            DragGesture()
                .updating($offsetState) { currentState, gestureState, transaction in
                    gestureState = currentState.translation
                }
                .onEnded { value in
                    pointX = pointX + value.translation.width
                    
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.9, blendDuration: 0)) {
                        
                    }
                }
        )
    }
    
    // MARK: Private
    private var cardView: some View {
        Circle()
            .fill(.white)
            .frame(width: 112, height: 112)
            .shadow(color: Color(.displayP3, red: 34 / 255, green: 34 / 255, blue: 34 / 255).opacity(0.08), radius: 24, x: 0, y: 12)
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
