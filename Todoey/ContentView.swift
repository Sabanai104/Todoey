import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.objectID, ascending: false)],
        predicate: nil,
        animation: .default)
    private var items: FetchedResults<Item>
//    Como utilizar o encoded
//    private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//    @State private var itemsState: [Item] = []
    @State private var showAlert: Bool = false
    @State private var textFieldInput: String = ""
    @State var searchText: String = ""

//    var filteredItems: [Item] {
//        if searchText.isEmpty {
//            return Array(items)
//        } else {
//            return items.filter { $0.title?.localizedCaseInsensitiveContains(searchText) ?? false }
//        }
//    }

    var body: some View {
        NavigationStack {
            VStack {
                CategoryView()
            }
        }
    }
}


#Preview {
    ContentView()
}
