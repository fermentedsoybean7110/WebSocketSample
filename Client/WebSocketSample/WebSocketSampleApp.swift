//
//  WebSocketSampleApp.swift
//  WebSocketSample
//

import SwiftUI

@main
struct WebSocketSampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(client: WebSocketClient())
        }
    }
}
