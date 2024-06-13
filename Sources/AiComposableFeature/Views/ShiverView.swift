//
//  SwiftUIView.swift
//
//
//  Created by SALGARA, YESKENDIR on 12.06.24.
//

import SwiftUI

struct ShiverView: ViewModifier {
    private let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    
    @State private var position: CGPoint = .zero
    @State private var size: CGSize = .zero
    
    private enum ShiverState: CaseIterable {
        case right, bottom, left, top, center
    }
    
    @State private var state: ShiverState = .center

    func body(content: Content) -> some View {
        GeometryReader { geo in
            ZStack {
                content
                    .position(position)
            }
            .onAppear {
                position = .init(x: geo.size.width / 2,
                                 y: geo.size.height / 2)
                size = geo.size
            }
        }
//        .frame(width: size.width, height: size.height)
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 2)) {
                switch state {
                case .right:
                    position.x = (size.width / 2) + (size.width * 0.01)
                    position.y = (size.height / 2)
                    state = ShiverState.allCases.randomElement() ?? .bottom
                case .bottom:
                    position.x = (size.width / 2)
                    position.y = (size.height / 2) + (size.height * 0.01)
                    state = ShiverState.allCases.randomElement() ?? .left
                case .left:
                    position.x = (size.width / 2) - (size.width * 0.01)
                    position.y = (size.height / 2)
                    state = ShiverState.allCases.randomElement() ?? .top
                case .top:
                    position.x = (size.width / 2)
                    position.y = (size.height / 2) - (size.height * 0.01)
                    state = ShiverState.allCases.randomElement() ?? .right
                case .center:
                    position.x = (size.width / 2)
                    position.y = (size.height / 2)
                    state = ShiverState.allCases.randomElement() ?? .right
                }
            }
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
}

extension View {
    func shiver() -> some View {
        modifier(ShiverView())
    }
}

#Preview {
    Circle()
        .shiver()
}
