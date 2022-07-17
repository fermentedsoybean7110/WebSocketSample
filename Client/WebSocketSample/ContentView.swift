//
//  ContentView.swift
//  WebSocketSample
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var client: WebSocketClient
    @State private var inputText: String = ""
    @State var isWebSocketReady: Bool = false
    @State var isTextEmpty: Bool = false
    
    var body: some View {
        VStack {
            if client.isConnected {
                Text("接続中")
                    .padding()
            } else {
                Text("未接続")
                    .padding()
            }
            HStack {
                Button("接続") {
                    client.connect()
                }
                .padding()
                Button("切断") {
                    client.disconnect()
                }
                .padding()
            }
            TextField("入力フォーム", text: $inputText)
                .padding()
            Button("送信") {
                if client.isConnected {
                    if inputText.isEmpty {
                        isTextEmpty = true
                    } else {
                        client.send(message: inputText)
                    }
                } else {
                    isWebSocketReady = true
                }
            }
            .padding()
            .alert("送信不可能", isPresented: $isWebSocketReady) {
                Button("OK") { }
            } message: {
                Text("サーバーと接続されておりません")
            }
            .alert("送信不可能", isPresented: $isTextEmpty) {
                Button("OK") { }
            } message: {
                Text("文字を入力してください")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(client: WebSocketClient())
    }
}
