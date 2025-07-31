import SwiftUI
import SwiftData
import AVFoundation
import SpriteKit

struct ContentView: View {
    // Timer state
    @State private var timeRemaining = 25 * 60
    @State private var timerRunning = false
    @State private var onBreak = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showBox = false

    // initialize the rabbit jumping
    class CheerSceneHolder: ObservableObject {
        let scene: CheerScene

        init() {
            self.scene = CheerScene(size: CGSize(width: 60, height: 80))
        }
    }

    @StateObject private var sceneHolder = CheerSceneHolder()

    // keep track of the time
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // Tasks
    @State private var tasks: [Task] = []

    var body: some View {
        ZStack {
            Color.orange.opacity(0.4)
                .ignoresSafeArea()

            ScrollView {
                VStack() {

                    // SpriteKit character with text box
                    ZStack {
                        SpriteView(scene: sceneHolder.scene)
                            .frame(width: 200, height: 240)
                            .offset(y: 20)

                        if showBox {
                            VStack() {
                                // put in the text box
                                Image("textBox1")
                                    .resizable()
                                    .frame(width: 150, height: 120)
                                    .cornerRadius(4)
                            }
                            .offset(x: -75, y: -65)
                            .transition(.opacity)
                            .animation(.easeInOut, value: showBox)
                        }
                    }
                    // effectively padding
                    .frame(maxWidth: .infinity, minHeight: 300)

                    // work and break label
                    Text(onBreak ? "Break time!" : "Time to lock in >:)")
                        .foregroundColor(onBreak ? .mint : Color(red: 0.322, green: 0.251, blue: 0.173))
                        .fontWeight(onBreak ? .regular : .bold)

                    // timer countdown (25 min, 5 min)
                    Text(formatTime(seconds: timeRemaining))
                        .fontWeight(.bold)
                        .font(.system(size: 60))
                        .opacity(0.7)
                        .foregroundColor(Color(red: 0.58, green: 0.78, blue: 0.675))

                    // timer buttons
                    HStack {
                        Button {
                            timerRunning.toggle()
                        } label: {
                            Text(timerRunning ? "Pause" : "Start")
                        }
                        .padding()
                        .background(Circle().fill(Color(red: 0.58, green: 0.78, blue: 0.675)))
                        .opacity(0.7)
                        .foregroundColor(.black)

                        Button {
                            timerRunning = false
                            timeRemaining = 25 * 60
                        } label: {
                            Text("Reset")
                        }
                        .padding()
                        .background(Circle().fill(Color(red: 0.58, green: 0.78, blue: 0.675)))
                        .opacity(0.7)
                        .foregroundColor(.black)

                        Button {
                            skipTimer()
                        } label: {
                            Text("Skip")
                        }
                        .padding()
                        .background(Circle().fill(Color(red: 0.58, green: 0.78, blue: 0.675)))
                        .opacity(0.7)
                        .foregroundColor(.black)
                    }

                    // have the list of tasks with padding
                    VStack(alignment: .leading) {
                        Text("Task List")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top)
                            .frame(maxWidth: .infinity, alignment: .center)

                        Grid {
                            ForEach(Array(tasks.enumerated()), id: \.element.id) { index, task in
                                GridRow {
                                    TextField("Enter task...", text: $tasks[index].name)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)

                                    Button(action: {
                                        tasks.remove(at: index)
                                    }) {
                                        Text("✔️")
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.horizontal)
                            }
                        }
                        // add task option/button
                        Button("Add Task", systemImage: "plus") {
                            tasks.append(Task(name: ""))
                        }
                        
                        .frame(height: 25)
                        .frame(width: 120)
                        .foregroundColor(.black)
                        .background(Rectangle().fill(Color(red: 0.58, green: 0.78, blue: 0.675)))
                        .cornerRadius(8)
                        .opacity(0.7)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, minHeight: 320)
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            loadTasks()
        }
        .onChange(of: tasks) { _ in
            saveTasks()
        }
        .onReceive(timer) { _ in
            if timerRunning {
                if timeRemaining > 0 {
                    timeRemaining -= 1

                    // Optional dynamic message range (e.g., minute 12-13)
                    let totalDuration = onBreak ? 5 * 60 : 25 * 60
                    let secondsElapsed = totalDuration - timeRemaining
                    if secondsElapsed >= 60 && secondsElapsed <= 1440 {
                        showBox = true
                    } else {
                        showBox = false
                    }

                } else {
                    playSound()
                    timerRunning = false

                    if !onBreak {
                        onBreak = true
                        timeRemaining = 5 * 60
                        sceneHolder.scene.stopAnimationAtBreakFrame()
                    } else {
                        onBreak = false
                        timeRemaining = 25 * 60
                        sceneHolder.scene.startAnimation()
                    }
                }
            }
        }
    }

    // sounds

    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let displayedSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, displayedSeconds)
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

    func skipTimer() {
        timeRemaining = 0
    }

    func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "SavedTasks")
        }
    }

    func loadTasks() {
        if let savedData = UserDefaults.standard.data(forKey: "SavedTasks") {
            if let decoded = try? JSONDecoder().decode([Task].self, from: savedData) {
                tasks = decoded
            }
        }
    }
}

#Preview {
    ContentView()
}
