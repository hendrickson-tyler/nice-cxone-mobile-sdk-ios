import Foundation
import XCTest
@testable import CXoneChatSDK


// MARK: - URLSessionWebSocketTaskMock

class URLSessionWebSocketTaskMock: URLSessionWebSocketTaskProtocol {
    
    // MARK: - Properties
    
    var delegate: URLSessionTaskDelegate?
    var closure: ((String) -> Void)?
    
    
    // MARK: - Methods
    
    func send(_ message: URLSessionWebSocketTask.Message, completionHandler: @escaping (Error?) -> Void) {
        var messageString = "messageString"
        
        guard case URLSessionWebSocketTask.Message.string(let string) = message else {
            return
        }
        
        if string != "{\"action\":\"heartbeat\"}" {
            guard let data = string.data(using: .utf8) else {
                completionHandler(CXoneChatError.invalidData)
                return
            }
            
            do {
                let decode = try JSONDecoder().decode(EventPayLoadCodable.self, from: data)
                
                switch decode.payload.eventType {
                case .authorizeCustomer:
                    messageString = try loadStubFromBundle(withName: "authorize", extension: "json").utf8string
                    
                    closure?(messageString)
                case .customerAuthorized, .tokenRefreshed, .messageCreated, .moreMessagesLoaded,
                        .messageReadChanged, .threadRecovered, .threadListFetched, .threadMetadataLoaded, .threadArchived,
                        .contactInboxAssigneeChanged, .messageSeenByCustomer, .reconnectCustomer, .refreshToken:
                    break
                case .sendMessage:
                    messageString = try loadStubFromBundle(withName: "MessageCreated", extension: "json").utf8string
                case .loadThreadMetadata:
                    messageString = try loadStubFromBundle(withName: "threadMetadaLoaded", extension: "json").utf8string
                    
                    closure?(messageString)
                default:
                    break
                }
                
                closure?(messageString)
            } catch {
                completionHandler(error)
            }
        } else {
            closure?(string)
        }
    }
    
    func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
        closure = { string in
            completionHandler(.success(.string(string)))
        }
    }
    
    func sendPing(pongReceiveHandler: @escaping (Error?) -> Void) {
        pongReceiveHandler(nil)
    }
    
    func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) { }
    
    func resume() { }
    
    func loadStubFromBundle(withName name: String, extension: String) throws -> Data {
        let url = URL(forResource: name, type: `extension`)
        
        return try Data(contentsOf: url)
    }
}


// MARK: - URLSessionMock
 
class URLSessionMock: URLProtocol, URLSessionProtocol {
    
    // MARK: - Properties
    
    var delegate: URLSessionDelegate?
    
    
    // MARK: - Methods
    
    func webSocketTask(with request: URLRequest) -> URLSessionWebSocketTaskMock { URLSessionWebSocketTaskMock() }
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() { }
    
    override func stopLoading() { }
}
