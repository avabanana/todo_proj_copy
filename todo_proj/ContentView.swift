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
    @State private var onBreak = false
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
                //img or character
                Image("timer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                //test fro break or work time
                if onBreak{
                    Text("Break time!")
                }else{
                    Text("Time to lock in >:)")
                }
                //time display
                Text(formatTime(seconds: timeRemaining))
                    .padding()
                //pause button
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
                //reset button
                Button {
                    timerRunning = false
                    timeRemaining = 25*60
                }label: {
                    Text("Reset")                }

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
                if timerRunning {
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        //alert
                        
                        //break
                        if !onBreak{
                            onBreak = true
                            timeRemaining = 5*60
                        }else{
                            onBreak = false
                            timeRemaining = 25*60

                        }
                        
                    }
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
