//
//  FlightView.swift
//
//
//  Created by SALGARA, YESKENDIR on 12.06.24.
//

import SwiftUI

public struct FlightView<Content: View>: View {
    private let distance: CGFloat = 140
    private let size: CGFloat = 150

    @State var center: CGPoint = .zero

    let colors: [Color] = [
        .red,
        .yellow,
        .blue,
        .green,
        .purple,
    ]

    @State private var bublesViewSize: CGSize = .zero

    @State private var selectedItems: [String] = []
    var items: [String]
    var isLoading: Bool = false
    var onRequest: ([String]) -> Void

    let content: () -> Content

    public init(
        items: [String],
        isLoading: Bool,
        onRequest: @escaping ([String]) -> Void,
        content: @escaping () -> Content
    ) {
        self.items = items
        self.isLoading = isLoading
        self.onRequest = onRequest
        self.content = content
    }

    public var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    GeometryReader { geo in
                        ZStack {
                            BubbleView(size: size)
                                .overlay {
                                    if isLoading {
                                        Circle()
                                            .fill(.white.opacity(0.2))
                                            .stroke(
                                                LinearGradient(
                                                    colors: [.white.opacity(0.3), .white.opacity(0.1)],
                                                    startPoint: .bottomLeading,
                                                    endPoint: .topTrailing
                                                ),
                                                style: .init(lineWidth: 2)
                                            )
                                            .frame(width: size, height: size)
                                            .shadow(color: .white, radius: 5)
                                    }
                                }
                                .overlay {
                                    content()
                                }
                            ForEach(selectedItems, id: \.self) { item in
                                Circle()
                                    .fill(colors.randomElement()?.opacity(0.1) ?? .white)
                                    .frame(width: 90, height: 90)
                                    .shadow(color: .white, radius: 2)
                                    .overlay {
                                        Button(action: {
                                            withAnimation {
                                                selectedItems.removeAll { $0 == item }
                                            }
                                        }, label: {
                                            ZStack {
                                                Circle()
                                                    .fill(.white)
                                                    .frame(width: 24, height: 24)
                                                Image(systemName: "minus")
                                                    .foregroundStyle(.black)
                                            }
                                        })
                                        .shadow(color: .white, radius: 10)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    }
                                    .overlay(content: {
                                        Text(item)
                                            .font(.system(size: 14, weight: .medium))
                                            .multilineTextAlignment(.center)
                                            .foregroundStyle(.white)
                                    })
                                    .position(calculatePosition(with: item))
                                    .shadow(color: .white.opacity(0.5), radius: 0.5)
                                    .shiver()
                            }
                        }
                        .onAppear {
                            bublesViewSize = geo.size
                            center = .init(
                                x: geo.size.width / 2,
                                y: geo.size.height / 2
                            )
                        }
                    }
                    .frame(height: 400)
                    CategoriesView(items: items) { item in
                        withAnimation {
                            selectedItems.append(item)
                        }
                    }
                }
            }
        }
        .onChange(of: items) {
            requestTravelOptions()
        }
    }

    func calculatePosition(with item: String) -> CGPoint {
        guard let i = selectedItems.firstIndex(where: { $0 == item }) else { return .zero }
        guard i < selectedItems.count else { return .zero }
        let degree = 360 / selectedItems.count
        let itemDegree = CGFloat(degree * i)
        let cosinus = cos(itemDegree * CGFloat.pi / 180 + 30)
        let sinus = sin(itemDegree * CGFloat.pi / 180 + 30)
        let x = center.x + distance * cosinus
        let y = center.y + distance * sinus
        return CGPoint(x: x, y: y)
    }

    func requestTravelOptions() {
        onRequest(selectedItems)
    }
}

#Preview {
    FlightView(items: [
        "Paris 🇫🇷",
        "Paris 🇫🇷",
        "Paris 🇫🇷",
        "Paris 🇫🇷",
    ], isLoading: false, onRequest: { _ in }) {
        Text("450 euro")
            .font(.system(size: 18, weight: .medium))
    }
}
