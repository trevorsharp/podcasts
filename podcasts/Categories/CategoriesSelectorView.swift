import SwiftUI
import PocketCastsServer

struct Category {
    let title: String
    let image: String
}

struct CategoriesSelectorView: View {
    @ObservedObject var observable: CategoriesSelectorViewController.Observable

    @State private var categories: [DiscoverCategory]?
    @State private var popular: [DiscoverCategory]?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if let popular {
                    CategoriesPillsView(categories: popular, selectedCategory: $observable.selectedCategory)
                        .environmentObject(Theme.sharedTheme)
                } else {
                    PlaceholderPillsView()
                }
            }
            .padding(16)
        }
        .task(id: observable.item?.source) {
            guard let source = observable.item?.source else { return }
            let categories = await DiscoverServerHandler.shared.discoverCategories(source: source)
            self.categories = categories
            popular = categories.filter {
                guard let id = $0.id else { return false }
                return observable.item?.popular?.contains(id) == true
            }
        }
    }
}

struct PlaceholderPillsView: View {
    var body: some View {
        ForEach(0..<10) { _ in
            Button(action: {}, label: {
                Text("Placeholder")
            })
            .buttonStyle(CategoryButtonStyle())
            .environmentObject(Theme.sharedTheme)
            .redacted(reason: .placeholder)
        }
    }
}

struct CategoriesPillsView: View {
    let categories: [DiscoverCategory]
    @Binding var selectedCategory: DiscoverCategory?

    @State private var showingCategories = false

    @Namespace private var animation

    var body: some View {
        if let selectedCategory {
            CloseButton(selectedCategory: $selectedCategory)
            CategoryButton(category: selectedCategory, selectedCategory: $selectedCategory)
                .matchedGeometryEffect(id: selectedCategory.id, in: animation)
        } else {
            Button(action: {
                showingCategories.toggle()
            }, label: {
                HStack {
                    Text("All Categories")
                    Image(systemName: "chevron.down")
                }
            })
            .buttonStyle(CategoryButtonStyle())
            ForEach(categories, id: \.id) { category in
                CategoryButton(category: category, selectedCategory: $selectedCategory)
                .matchedGeometryEffect(id: category.id, in: animation)
            }
        }
    }
}

struct CloseButton: View {
    @Binding var selectedCategory: DiscoverCategory?

    var body: some View {
        Button(action: {
            withAnimation {
                self.selectedCategory = nil
            }
        }, label: {
            Image(systemName: "xmark")
        })
        .buttonStyle(CategoryButtonStyle())
    }
}

struct CategoryButton: View {
    let category: DiscoverCategory

    @Binding var selectedCategory: DiscoverCategory?

    var isSelected: Bool {
        category.id == selectedCategory?.id
    }

    var body: some View {
        Button(action: {
            withAnimation {
                selectedCategory = category
            }
        }, label: {
            Text(category.name ?? "")
        })
        .buttonStyle(CategoryButtonStyle(isSelected: isSelected))
    }
}
