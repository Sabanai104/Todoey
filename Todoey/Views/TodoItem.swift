
import SwiftUI

struct TodoItem: View {
    @State var isChecked: Bool = false
    private let item: Item
    private let action: () -> Void

    init(item: Item, action: @escaping () -> Void) {
        self.item = item
        self.action = action
    }

    var body: some View {
        Button {
            isChecked.toggle()
            action()
        } label: {
            HStack(alignment: .center) {
                Text(item.title ?? "")
                Spacer()
                Image(systemName: isChecked ? "checkmark.square" : "square")
                    .foregroundColor(isChecked ? .blue : .gray)
            }
        }
        .onAppear() {
            isChecked = item.done
        }
    }
}
