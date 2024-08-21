//
//  SwiftUIView.swift
//
//
//  Created by SALGARA, YESKENDIR on 12.06.24.
//

import SwiftUI

struct CategoriesView: View {
    var items: [String]
    var onDidSelect: (String) -> Void

    @State private var fieldValue: String = ""

    init(
        items: [String],
        onDidSelect: @escaping (String) -> Void
    ) {
        self.items = items
        self.onDidSelect = onDidSelect
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            TextField(text: $fieldValue) {
                Text("Search..")
                    .foregroundStyle(.gray)
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.1))
            }
            .foregroundStyle(.white)
            .background(.clear)
            .padding(.horizontal, 20)

            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 120, maximum: 200)),
                ]) {
                    ForEach(items.filter { $0.starts(with: fieldValue) }, id: \.self) { city in
                        Button(action: {
                            onDidSelect(city)
                        }, label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.1))
                                .frame(height: 65)
                                .overlay {
                                    Text(city)
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundStyle(.black.opacity(0.8))
                                }
                        })
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .shadow(radius: 5)
            }
        }
    }
}

#Preview {
    CategoriesView(items: [
        "Paris 🇫🇷",
        "Frankfurt",
        "Paris 🇫🇷",
        "Paris 🇫🇷",
        "Paris 🇫🇷",
        "Paris 🇫🇷",
    ]) { print($0) }
}
