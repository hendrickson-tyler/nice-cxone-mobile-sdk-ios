//
// Copyright (c) 2021-2024. NICE Ltd. All rights reserved.
//
// Licensed under the NICE License;
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    https://github.com/nice-devone/nice-cxone-mobile-sdk-ios/blob/main/LICENSE
//
// TO THE EXTENT PERMITTED BY APPLICABLE LAW, THE CXONE MOBILE SDK IS PROVIDED ON
// AN “AS IS” BASIS. NICE HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS
// OR IMPLIED, INCLUDING (WITHOUT LIMITATION) WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT, AND TITLE.
//

import Foundation

internal enum WebSocketError: Error {
    case serverError(URLSessionWebSocketTask.CloseCode)
    case protocolError(Error)
    case cxoneError(CXoneChatError)

    var description: String {
        switch self {
        case let .serverError(code):        "Server Error: \(code)"
        case let .cxoneError(code):         code.localizedDescription
        case let .protocolError(error):     "Unknown Error: \(error)"
        }
    }
}