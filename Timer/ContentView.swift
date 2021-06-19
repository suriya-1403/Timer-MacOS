//
//  ContentView.swift
//  Timer
//
//  Created by SuriyaKrishnan on 19/06/21.
//

import SwiftUI
import AVKit
import AVFoundation

let defaultTimeRemaining: CGFloat = 900
let lineWith:CGFloat = 25
let radius:CGFloat = 50

struct ContentView: View {
    
    @State private var isActive = false
    @State private var timeRemaining:CGFloat = defaultTimeRemaining
    @State var audioPlayer: AVAudioPlayer!
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    let sound = Bundle.main.path(forResource: "Reflection", ofType: "m4r")
//    self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
    
    var body: some View {
        VStack(spacing: 25){
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 25, content: {
                Text("Timer").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            })
            ZStack{
                Circle()
                    .stroke(Color.gray.opacity(0.2),style: StrokeStyle(lineWidth: lineWith, lineCap: .round))
                Circle()
                    .trim(from: 0,to: 1-((defaultTimeRemaining-timeRemaining)/defaultTimeRemaining))
                    .stroke(timeRemaining>(defaultTimeRemaining/2) ? Color.green: timeRemaining>(defaultTimeRemaining/4) ? Color.yellow: Color.red ,style: StrokeStyle(lineWidth: lineWith, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut)
                Text("\(Int(timeRemaining))")
                    .font(.largeTitle)
            }.frame(width: radius*2, height: radius*2, alignment: .center)
            HStack(spacing: 25){
                Label("\(isActive ? "Pause" :"Play")",systemImage: "\(isActive ? "pause.fill" :"play.fill")")
                    .foregroundColor(isActive ? .purple : .red)
                    .font(.body).onTapGesture {
                        AudioServicesPlaySystemSound(1026)
                        isActive.toggle()
                        
                }
                Label("Resume",systemImage: "backward.fill")
                    .foregroundColor(.yellow)
                    .font(.body).onTapGesture {
                        AudioServicesPlaySystemSound(1026)
                        isActive = false
                        timeRemaining = defaultTimeRemaining
                }
            }

        }.onReceive(timer, perform: { _ in
            guard isActive else {return}
            if timeRemaining>0{
                timeRemaining-=1
            }
            else{
                isActive = false
                timeRemaining = defaultTimeRemaining
                
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
