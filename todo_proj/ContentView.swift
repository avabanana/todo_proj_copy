//
//  ContentView.swift
//  todo_proj
//
//  Created by Scholar on 7/28/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showNewTask = false
    @Query var toDos: [ToDoItem]
    @Environment(\.modelContext) var modelContext
    var body: some View {
        VStack {
            HStack {
                Text("To Do List")
                    .font(.system(size: 40))
                    .fontWeight(.black)
                Spacer()
                Button {
                    withAnimation {
                        showNewTask = true
                    }
                } label: {
                    Text("+")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .padding()
            Spacer()
            List {
                ForEach(toDos) { toDoItem in
                    if toDoItem.isImportant {
                        Text("‼️" + toDoItem.title)
                        Text("Change 1")
                        Text("Change 2")
                    } else {
                        Text(toDoItem.title)
                    }
                }
                .onDelete(perform: deleteToDo)
                .listStyle(.plain)
            }
        }
        if showNewTask {
            NewToDoView(showNewTask: $showNewTask, toDoItem: ToDoItem(title: "", isImportant: false))
        }
    }
    func deleteToDo(at offsets: IndexSet) {
        for offset in offsets {
            let toDoItem = toDos[offset]
            modelContext.delete(toDoItem)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ToDoItem.self, inMemory: true)
}
