//
//  ContentView.swift
//  todo_proj
//
//  Created by Scholar on 7/28/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var tasks: [Task] = []
    
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
            
            //TASK CODE
            Grid {
                ForEach($tasks) { $task in
                    GridRow {
                        TextField("Enter task...", text: $task.name)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.vertical)
            
            Button("Add Tasks", systemImage: "plus") {
                tasks.append(Task(name: ""))
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
