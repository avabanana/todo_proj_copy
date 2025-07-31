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

    class CheerSceneHolder: ObservableObject {
        let scene: CheerScene

        init() {
            self.scene = CheerScene(size: CGSize(width: 60, height: 80))
        }
    }

    @StateObject private var sceneHolder = CheerSceneHolder()

    // Timer publisher
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    // Tasks
    @State private var tasks: [Task] = []

    // Optional ToDo (SwiftData)
    @State private var showNewTask = false
    @Environment(\.modelContext) var modelContext

    var body: some View {
        ZStack {
            Color.orange.opacity(0.4)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    // SpriteKit character with text box
                    ZStack {
                        SpriteView(scene: sceneHolder.scene)
                            .frame(width: 200, height: 240)
                            .offset(y: 20)

                        if showBox {
                            VStack(spacing: 8) {
                                Image("textBox1")
                                    .resizable()
                                    .frame(width: 150, height: 120)
                                    .offset(x: -8, y: -8)
                                    .cornerRadius(10)
                                    .padding()
                            }
                            .offset(y: -80)
                            .transition(.opacity)
                            .animation(.easeInOut, value: showBox)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)

                    // Work/break label
                    if onBreak {
                        Text("Break time!")
                            .foregroundColor(.mint)
                    } else {
                        Text("Time to lock in >:)")
                            .foregroundColor(Color(red: 0.322, green: 0.251, blue: 0.173))
                            .fontWeight(.bold)
                    }

                    // Timer countdown
                    Text(formatTime(seconds: timeRemaining))
                        .fontWeight(.bold)
                        .font(.system(size: 60))
                        .opacity(0.7)
                        .foregroundColor(Color(red: 0.58, green: 0.78, blue: 0.675))

                    // Timer buttons
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

                    // Tasks section using Grid layout
                    VStack(alignment: .leading) {
                        Text("Task List")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top)

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

                        Button("Add Task", systemImage: "plus") {
                            tasks.append(Task(name: ""))
                        }
                        .frame(height: 25)
                        .frame(width: 120)
                        .foregroundColor(.black)
                        .background(Rectangle().fill(Color(red: 0.58, green: 0.78, blue: 0.675)))
                        .cornerRadius(8)
                        .opacity(0.7)
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, minHeight: 320)
                .padding(.horizontal, 20)
            }
        }
        .onReceive(timer) { _ in
            if timerRunning {
                if timeRemaining > 0 {
                    timeRemaining -= 1

                    // Show text box at minute 12–13
                    let secondsPassed = 730 // Replace with actual logic if needed
                    if secondsPassed > 720 && secondsPassed < 780 {
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

                        // Stop animation on break frame
                        sceneHolder.scene.stopAnimationAtBreakFrame()
                    } else {
                        onBreak = false
                        timeRemaining = 25 * 60

                        // Resume animation for work time
                        sceneHolder.scene.startAnimation()
                    }
                }
            }
        }
    }

    // MARK: - Utility Functions

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
}
