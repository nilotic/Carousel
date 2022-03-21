//
//  ViewExtension.swift
//  Carousel
//
//  Created by Den Jo on 2022/03/21.
//

import SwiftUI

extension View {
    
    func frame(perform: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader {
                Color.clear
                    .preference(key: FramePreferenceKey.self, value: $0.frame(in: .global))
            }
        )
        .onPreferenceChange(FramePreferenceKey.self) { value in
            DispatchQueue.main.async { perform(value) }
        }
    }
}
