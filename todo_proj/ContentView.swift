//
//  ContentView.swift
//  todo_proj
//
//  Created by Scholar on 7/28/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
//    @State private var showNewTask = false
    
    @Query var toDos: [ToDoItem]
    @Environment(\.modelContext) var modelContext
    @State private var newTaskTitle = ""
    
    var body: some View {
            VStack {
                //pomodoro timer
                Image("timer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("placeholder for time display")
                    .padding()
                Button {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }label: {
                    Text("pause/start")
                }
                
                //Divider()
                
                //task code
                
                List {
                    ForEach(toDos) { toDoItem in //why name changed from toDoItem to task?
                        Text(toDoItem.title)
                    }
                    .onDelete(perform: deleteToDo)
//                    .listStyle(.plain) //mv this outside List closing }??
                }
                
//                HStack {
                   TextField("Add Task", text: $newTaskTitle)
                       .textFieldStyle(.roundedBorder)
                   Button(action: addTask) {
                       Image(systemName: "plus.circle.fill") //huh cirlce?
                           .font(.title2)
                   }
                   .disabled(newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty) //huh
//               }
//               .padding(.horizontal)
//               .padding(.bottom)
                
            }
            .padding() //added padding
        
//        if showNewTask {
//            NewToDoView(showNewTask: $showNewTask, toDoItem: ToDoItem(title: "", isImportant: false))
//        }
    }
    
    func addTask() {
        //how?
        let trimmed = newTaskTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        let newToDo = ToDoItem(title: trimmed)
        modelContext.insert(newToDo)
        newTaskTitle = ""
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
