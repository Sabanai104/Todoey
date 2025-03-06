//
//  Category.swift
//  Todoey
//
//  Created by Gabriel Sabanai on 05/03/25.
//
import SwiftUI

struct CategoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.objectID, ascending: false)],
        predicate: nil,
        animation: .default)

    private var categories: FetchedResults<Category>
    @State private var showAlert: Bool = false
    @State private var textFieldInput: String = ""

    var body: some View {
        List {
            ForEach(categories.indices, id: \.self) { index in
                NavigationLink {
                    ItemView(category: categories[index])
                } label: {
                    HStack {
                        CategoryItem(category: categories[index]) {}
                        .padding(.vertical, 8)
                    }
                }
            }
            .onDelete(perform: deleteCategory)
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.cyan, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Todoey")
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }

            ToolbarItem(placement: .topBarTrailing) {
                alertToolbar
            }
        }
    }
}

extension CategoryView {
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

                addCategory(name: textFieldInput)

                textFieldInput = ""
            }
        }
    }
}

extension CategoryView {
    private func addCategory(name: String) {
        withAnimation {
            let newCategory = Category(context: viewContext)
            newCategory.name = name

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteCategory(offsets: IndexSet) {
        withAnimation {
            offsets.map { categories[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoryView()
    }
}
