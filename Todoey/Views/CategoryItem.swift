import SwiftUI

struct CategoryItem: View {
    private let category: Category
    private let action: () -> Void

    init(category: Category, action: @escaping () -> Void) {
        self.category = category
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center) {
                Text(category.name ?? "")
            }
        }
    }
}
