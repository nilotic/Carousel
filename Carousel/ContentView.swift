//
//  ContentView.swift
//  Carousel
//
//  Created by Den Jo on 2022/03/18.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Value
    // MARK: Public
    var body: some View {
        Text("Hello, world!")
            .padding()
        
        
    }
    
    // MARK: Private
    
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
