//
//  TimerApp.swift
//  Timer
//
//  Created by SuriyaKrishnan on 19/06/21.
//

import SwiftUI

@main
struct TimerApp: App {
    var window = NSScreen.main?.visibleFrame
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: window!.width/3, height: window!.height/3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
//        .windowStyle(HiddenTitleBarWindowStyle)
    }
}
