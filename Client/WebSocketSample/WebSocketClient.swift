//
//  WebSocketClient.swift
//  WebSocketSample
//

import Foundation

class WebSocketClient : NSObject, ObservableObject {
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    @Published var isConnected: Bool = false
    
    // 接続
    func connect() {
        let urlSession: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        // 接続先のIPアドレスに差し替えてください
        webSocketTask = urlSession.webSocketTask(with: URL(string: "ws://XXX.XXX.XXX.XXX:XXXXX/")!)
        webSocketTask?.resume()
        self.receive()
    }
    
    // 切断
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    // 送信
    func send(message: String) {
        let msg = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(msg, completionHandler: { error in
            if let error = error {
                print(error)
            }
        })
    }
    
    // 受信
    func receive() {
        webSocketTask?.receive(completionHandler: { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text message: \(text)")
                case .data(let data):
                    print("Received binary data: \(data)")
                default:
                    print("Received Unkonwn Error")
                }
            case .failure(let error):
                print("Receive is failed by: \(error) ")
            }
        })
    }
    
}

extension WebSocketClient: URLSessionWebSocketDelegate {

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("didOpenWithProtocol")
        DispatchQueue.main.async {
            self.isConnected = true
        }
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("didCloseWith: closeCode: \(closeCode) reason: \(String(describing: reason))")
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("didCompleteWithError error: \(String(describing: error))")
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }
}
