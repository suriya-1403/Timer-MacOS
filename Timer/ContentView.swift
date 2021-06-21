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
var player: AVAudioPlayer!

struct NeumorphicButtonStyle: ButtonStyle {
    var bgColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(20)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .shadow(color: .white, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? -5: -15, y: configuration.isPressed ? -5: -15)
                        .shadow(color: .black, radius: configuration.isPressed ? 7: 10, x: configuration.isPressed ? 5: 15, y: configuration.isPressed ? 5: 15)
                        .blendMode(.overlay)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(bgColor)
                }
        )
            .scaleEffect(configuration.isPressed ? 0.95: 1)
            .foregroundColor(.primary)
            .animation(.spring())
    }
}

struct ContentView: View {
    
    @State private var isActive = false
//    static let space: KeyEquivalent
//    Space (U+0020)
    @State private var timeRemaining:CGFloat = defaultTimeRemaining
    @State var audioPlayer: AVAudioPlayer!
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
                ZStack{
                    Button(action: {
                        AudioServicesPlaySystemSound(1026)
                        isActive.toggle()
                        debugPrint("Button Pressed")
                    }){}
                    .padding(0)
                    .opacity(0)
                    .frame(width: 0, height: 0)
                    .keyboardShortcut(.space,modifiers: [])
                    Button(action: {
                        AudioServicesPlaySystemSound(1026)
                        isActive.toggle()
                    }){
                        HStack{
                            Image(systemName: "\(isActive ? "pause.fill" :"play.fill")")
                            Text("\(isActive ? "Pause" :"Play")")
                        }
                    }
                    .foregroundColor(isActive ? .purple: .red)
                    .font(.body)
                    .buttonStyle(PlainButtonStyle())
                }
                ZStack{
                    Button(action: {
                        AudioServicesPlaySystemSound(1026)
                        isActive.toggle()
                        debugPrint("Button Pressed")
                    }){}
                    .padding(0)
                    .opacity(0)
                    .frame(width: 0, height: 0)
                    .keyboardShortcut("s",modifiers: [])
                    Button(action: {
                        AudioServicesPlaySystemSound(1026)
                        isActive = false
                        timeRemaining = defaultTimeRemaining
                    }){
                        HStack{
                            Image(systemName: "backward.fill")
                            Text("Resume")
                        }
                    }
                    .foregroundColor(.yellow)
                    .font(.body)
                    .buttonStyle(PlainButtonStyle())
                }
//                Label("Resume",systemImage: "backward.fill")
//                    .foregroundColor(.yellow)
//                    .font(.body).onTapGesture {
//                        AudioServicesPlaySystemSound(1026)
//                        isActive = false
//                        timeRemaining = defaultTimeRemaining
//                }
            }

        }.onReceive(timer, perform: { _ in
            guard isActive else {return}
            if timeRemaining>0{
                timeRemaining-=1
            }
            else{
                isActive = false
                let url = Bundle.main.url(forResource: "Reflection", withExtension: "m4r")
                guard url != nil else {
                    return
                }
                do{
                    player = try AVAudioPlayer(contentsOf: url!)
                    player?.play()
                    player.numberOfLoops = 4
                }catch{
                    print("Error on playing the sound")
                }
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
