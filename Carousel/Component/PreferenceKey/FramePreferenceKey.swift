//
//  FramePreferenceKey.swift
//  Carousel
//
//  Created by Den Jo on 2022/03/21.
//

import SwiftUI

struct FramePreferenceKey: PreferenceKey {
    
    static var defaultValue: CGRect = .zero
  
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}
