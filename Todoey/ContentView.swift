import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.title, ascending: true)],
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
                itemsList
            }
            .onAppear {
//                loadItems()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.cyan, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Todoey")
                        .font(.headline)
                        .foregroundColor(.white)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    alertToolbar
                }
            }
        }
    }
}

extension ContentView {
    var alertToolbar: some View {
        Button {
            showAlert = true
        } label: {
            Image(systemName: "plus")
                .foregroundStyle(.white)
        }
        .alert("Criar nova tarefa", isPresented: $showAlert) {
            TextField("Digite a nova tarefa", text: $textFieldInput)
            Button("Cancelar", role: .cancel) {}
            Button("Criar") {
//                Utilizando o encoded
//                let newItem = Item(title: textFieldInput, done: false)
//                itemsState.append(newItem)

                addItem(title: textFieldInput, done: false)

                textFieldInput = ""
            }
        }
    }

    var itemsList: some View {
        List {
            ForEach(items.indices, id: \.self) { index in
                HStack {
                    TodoItem(item: items[index]) {
                        items[index].done.toggle()
                        print(items[index].objectID)
                        updateItems()
                    }
                    .padding(.vertical, 8)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(.plain)
        .searchable(text: $searchText, prompt: "Search items")
        .onChange(of: searchText) {
            updatePredicate()
        }
    }
}

extension ContentView {
//    Usando o Encoded

//    func deleteItem(at offsets: IndexSet) {
//        itemsState.remove(atOffsets: offsets)
//        saveItems()
//    }

//    func saveItems() {
//        do {
//            let encoded = try PropertyListEncoder().encode(itemsState)
//            if let dataFilePath {
//                try encoded.write(to: dataFilePath)
//            }
//        } catch {
//            print(error)
//        }
//    }

//    func loadItems() {
//        guard let dataFilePath, let data = try? Data(contentsOf: dataFilePath) else { return }
//
//        if let savedItems = try? PropertyListDecoder().decode([Item].self, from: data) {
//            itemsState = savedItems
//        }
//    }

    private func addItem(title: String, done: Bool) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.title = title
            newItem.done = done

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func updatePredicate() {
        if searchText.isEmpty {
            items.nsPredicate = nil
        } else {
            items.nsPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }

    private func updateItems() {
        withAnimation {
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    ContentView()
}
