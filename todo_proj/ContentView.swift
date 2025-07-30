//
//  ContentView.swift
//  todo_proj
//
//  Created by Scholar on 7/28/25.
//

import SwiftUI
import SwiftData
import AVFoundation

struct ContentView: View {
    //timer stuff
    @State private var timeRemaining = 25*60 //in seconds
    @State private var timerRunning = false
    @State private var onBreak = false
    @State private var audioPlayer: AVAudioPlayer?
    //timer publisher
    let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    //to do list stuff
    @State private var showNewTask = false
    @Query var toDos: [ToDoItem]
    @Environment(\.modelContext) var modelContext
    var body: some View {
        ZStack{
            Color.orange.opacity(0.4)
                    .ignoresSafeArea()
            VStack {
                //pomodoro timer
                //img or character
                Image("timer")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                //test fro break or work time
                if onBreak{
                    Text("Break time!")
                }else{
                    Text("Time to lock in >:)")
                }
                //time display
                Text(formatTime(seconds: timeRemaining))
                    .fontWeight(.bold)
                    .padding()
                    .font(.system(size: 60))
                    .opacity(0.7)
                    .foregroundColor(Color(red: 0.58, green: 0.78, blue: 0.675))
                HStack{
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
                    .padding()
                    .background(Circle().fill(Color(red: 0.58, green: 0.78, blue: 0.675)))
                    .opacity(0.7)
                    .foregroundColor(.black)
                    //reset button
                    Button {
                        timerRunning = false
                        timeRemaining = 25*60
                    }label: {
                        Text("Reset")
                    }
                    .padding()
                    .background(Circle().fill(Color(red: 0.58, green: 0.78, blue: 0.675)))
                    .opacity(0.7)
                    .foregroundColor(.black)
                    //skip button
                    Button {
                        skipTimer()
                    }label: {
                        Text("Skip")
                    }
                    .padding()
                    .background(Circle().fill(Color(red: 0.58, green: 0.78, blue: 0.675)))
                    .opacity(0.7)
                    .foregroundColor(.black)
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
                if timerRunning {
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        //alert
                        playSound()
                        //stop timer
                        timerRunning = false
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
    }
    func formatTime(seconds: Int) -> String{
        let minutes = seconds/60
        let displayedSeconds = seconds % 60
        return String(format:"%02d:%02d", minutes, displayedSeconds)
    }
    
    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: "ding", withExtension: "mp3") else {
            print("Sound file not found!")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    func skipTimer(){
        timeRemaining = 0
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
