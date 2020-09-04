//
//  ContentView.swift
//  Todos
//
//  Created by Will Xavier on 02/09/20.
//  Copyright © 2020 Willyelns Consulting and Development Services. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var newTodo = ""
    @State private var allTodos: [TodoItem] = []
    private let todosKey = "TodosKey"
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Add todo...", text: $newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        guard !self.newTodo.isEmpty else  {return}
                        self.allTodos.append(TodoItem(todo: self.newTodo))
                        self.newTodo = ""
                        self.saveTodos()
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.leading, 5)
                }.padding()
                List {
                    ForEach(allTodos) {
                        todoItem in Text(todoItem.todo)
                    }.onDelete(perform: deleteTodo)
                }
            }.navigationBarTitle("Todos")
        }.onAppear(perform: loadTodos)
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        self.allTodos.remove(atOffsets: offsets)
    }
    
    private func loadTodos() {
        if let todosData = UserDefaults.standard.value(forKey: self.todosKey) as? Data {
            if let todosList = try? PropertyListDecoder().decode(Array<TodoItem>.self, from: todosData) {
                self.allTodos = todosList
            }
        }
    }
    
    private func saveTodos() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allTodos), forKey: self.todosKey)
    }
}

struct TodoItem: Identifiable, Codable {
    let id = UUID()
    let todo: String
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
