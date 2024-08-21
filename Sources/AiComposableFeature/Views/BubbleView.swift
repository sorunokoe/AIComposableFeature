//
//  SwiftUIView.swift
//
//
//  Created by SALGARA, YESKENDIR on 12.06.24.
//

import SwiftUI

public struct BubbleView: View {
    var size: CGFloat
    private let childSize: CGFloat
    @State var frame1: CGSize
    @State var frame2: CGSize
    @State var frame3: CGSize
    @State var position1: CGPoint = .init(x: 0, y: 0)
    @State var position2: CGPoint = .init(x: 0, y: 0)
    @State var position3: CGPoint = .init(x: 0, y: 0)
    @State var size1: CGFloat = 150
    @State var size2: CGFloat = 150
    @State var size3: CGFloat = 150

    let timer1 = Timer.publish(every: 2, tolerance: 0.5, on: .main, in: .common).autoconnect()
    let timer2 = Timer.publish(every: 2, tolerance: 0.5, on: .main, in: .common).autoconnect()
    let timer3 = Timer.publish(every: 4, tolerance: 0.5, on: .main, in: .common).autoconnect()

    let colors: [Color] = [
        .red,
//        .yellow,
        .blue,
//        .green,
        .purple,
    ]
    let colors2: [Color] = [
//        .yellow,
//        .green,
        .red,
        .purple,
        .blue
    ]
    @State var stepColor: Int = 0

    @State var rotation1: Double = 0
    @State var rotation2: Double = 0
    @State var rotation3: Double = 0

    public init(size: CGFloat) {
        self.size = size
        self.childSize = size
        self.frame1 = .init(width: childSize, height: childSize)
        self.frame2 = .init(width: childSize, height: childSize)
        self.frame3 = .init(width: size, height: size)
        self.size1 = childSize / 2
        self.size2 = childSize / 2
        self.size3 = size / 2
        self.stepColor = stepColor
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [colors[stepColor].opacity(0.3),
                             colors2[stepColor].opacity(0.3)],
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                )
                .overlay {
                    Circle()
                        .stroke(colors[stepColor].opacity(0.5), lineWidth: 3)
                        .frame(width: frame3.width, height: frame3.height)
                        .blur(radius: 12)
                        .shadow(color: colors2[stepColor], radius: 15)
                }
            }
            .mask {
                ZStack {
                    Rectangle()
                        .frame(width: frame1.width, height: frame1.height)
                        .clipShape(RoundedRectangle(cornerRadius: size1, style: .circular))
                        .position(position1)
                        .rotationEffect(.degrees(rotation1))
                    Rectangle()
                        .frame(width: frame2.width, height: frame2.height)
                        .clipShape(RoundedRectangle(cornerRadius: size2, style: .circular))
                        .position(position2)
                        .rotationEffect(.degrees(rotation2))
                    Rectangle()
                        .frame(width: frame3.width, height: frame3.height)
                        .clipShape(RoundedRectangle(cornerRadius: size3, style: .circular))
                        .position(position3)
                        .rotationEffect(.degrees(rotation3))
                }
                .shadow(color: .white, radius: 5)
                .shadow(color: colors[stepColor].opacity(0.8), radius: 25)
            }
            .onAppear {
                position1 = .init(
                    x: geo.size.width / 2,
                    y: geo.size.height / 2
                )
                position2 = .init(
                    x: geo.size.width / 2,
                    y: geo.size.height / 2
                )
                position3 = .init(
                    x: geo.size.width / 2,
                    y: geo.size.height / 2
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
                stepColor += 1
                stepColor = stepColor % colors.count
            }
        }
        .onReceive(timer1) { _ in
            withAnimation(.easeInOut(duration: 2)) {
                if frame1.width == childSize {
                    size1 = childSize - 5
                    frame1 = .init(width: childSize + 20, height: childSize - 30)
//                    position1.x += 10
//                    position1.y += 10
                } else if frame1.width == childSize + 20 {
                    size1 = childSize + 20
//                    position1.x += 5
//                    position1.y += 5
                    frame1 = .init(width: childSize - 20, height: childSize + 30)
                } else if frame1.width == childSize - 20 {
                    size1 = childSize - 30
//                    position1.x -= 15
                    frame1 = .init(width: childSize - 40, height: childSize + 10)
                } else {
                    size1 = childSize
//                    position1.y -= 15
                    frame1 = .init(width: childSize, height: childSize)
                }
                rotation1 += 10
            }
        }
        .onReceive(timer2) { _ in
            withAnimation(.easeInOut(duration: 2)) {
                if frame2.width == childSize {
                    size2 = childSize - 5
                    frame2 = .init(width: childSize - 40, height: childSize + 40)
//                    position2.x -= 10
//                    position2.y -= 10
                } else if frame2.width == childSize - 40 {
                    size2 = childSize + 20
//                    position2.x -= 5
//                    position2.y -= 5
                    frame2 = .init(width: childSize + 30, height: childSize - 60)
                } else if frame2.width == childSize + 30 {
                    size2 = childSize - 30
//                    position2.x += 15
                    frame2 = .init(width: childSize + 60, height: childSize - 50)
                } else {
                    size2 = childSize
//                    position1.y += 15
                    frame2 = .init(width: childSize, height: childSize)
                }
                rotation2 += 5
            }
        }
        .onReceive(timer3) { _ in
            withAnimation(.easeInOut(duration: 2)) {
                if frame3.width == size {
                    frame3 = .init(width: size + 10, height: size + 5)
                    position3.x -= 5
                    position3.y -= 5
                } else {
                    position3.x += 5
                    position3.y += 5
                    frame3 = .init(width: size, height: size)
                }
            }
        }
        .onDisappear {
            timer1.upstream.connect().cancel()
            timer2.upstream.connect().cancel()
            timer3.upstream.connect().cancel()
        }
    }
}

#Preview {
    BubbleView(size: 180)
}
