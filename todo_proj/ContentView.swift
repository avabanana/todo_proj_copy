//
//  ContentView.swift
//  todo_proj
//
//  Created by Scholar on 7/28/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //timer stuff
    @State private var timeRemaining = 25*60 //in seconds
    @State private var timerRunning = false
    //timer publisher
    let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    //to do list stuff
    @State private var showNewTask = false
    @Query var toDos: [ToDoItem]
    @Environment(\.modelContext) var modelContext
    var body: some View {
            VStack {
                //pomodoro timer
                Image("timer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text(formatTime(seconds: timeRemaining))
                    .padding()
                Button {
                    if timerRunning{
                        timerRunning = false
                    }else{
                        timerRunning = true
                    }
                }label: {
                    if timerRunning{
                        Text("Pause")
                    } else{
                        Text("Start")
                    }
                }
                //tasks
                List {
                    ForEach(toDos) { toDoItem in
                        if toDoItem.isImportant {
                            Text("‼️" + toDoItem.title)
                        } else {
                            Text(toDoItem.title)
                        }
                    }
                    .onDelete(perform: deleteToDo)
                    .listStyle(.plain)
                }
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
            .onReceive(timer){ _ in
                if timerRunning && timeRemaining > 0{
                    timeRemaining -= 1
                }
            }
        
        if showNewTask {
            NewToDoView(showNewTask: $showNewTask, toDoItem: ToDoItem(title: "", isImportant: false))
        }
    }
    func formatTime(seconds: Int) -> String{
        let minutes = seconds/60
        let displayedSeconds = seconds % 60
        return String(format:"%02d:%02d", minutes, displayedSeconds)
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
