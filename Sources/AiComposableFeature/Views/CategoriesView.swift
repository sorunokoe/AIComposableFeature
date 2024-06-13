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
    @State private var dateValue = Date.now

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

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
                    .fill(.white.opacity(0.1))
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
                                .fill(.white.opacity(0.1))
                                .frame(height: 70)
                                .overlay {
                                    Text(city)
                                        .font(.system(size: 18, weight: .regular))
                                        .foregroundStyle(.white)
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

//    @ViewBuilder
//    var categorySectionView: some View {
//        if let selectedCategory {
//            HStack(alignment: .center, spacing: 0) {
//                ForEach(categories, id: \.self) { category in
//                    Button(action: {
//                        withAnimation {
//                            selectedCategory = category
//                        }
//                    }, label: {
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(selectedCategory == category ? .white.opacity(0.1) : .clear)
//                            .frame(height: 50)
//                            .background {
//                                Text(category.title)
//                                    .font(.system(size: 20, weight: .medium))
//                                    .frame(maxWidth: .infinity, alignment: .center)
//                            }
//                            .opacity(selectedCategory == category ? 1 : 0.5)
//                    })
//                    .foregroundStyle(.white)
//                }
//            }
//            .background(.white.opacity(0.1))
//            .clipShape(RoundedRectangle(cornerRadius: 20))
//            .padding(.horizontal, 20)
//            .shadow(radius: 5)
//        } else {
//            EmptyView()
//        }
//    }
}

#Preview {
    CategoriesView(items: [
        "Paris 🇫🇷",
        "Paris 🇫🇷",
        "Paris 🇫🇷",
        "Paris 🇫🇷",
        "Paris 🇫🇷",
        "Paris 🇫🇷",
    ]) { _ in }
}
