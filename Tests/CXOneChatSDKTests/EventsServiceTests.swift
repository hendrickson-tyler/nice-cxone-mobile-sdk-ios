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

@testable import CXoneChatSDK
import XCTest

class EventsServiceTests: CXoneXCTestCase {
    
    func testCreateThrowsVisitorIdUnsupportedChannelConfig() {
        socketService.connectionContext.visitorId = nil
        
        XCTAssertThrowsError(try eventsService.create(.reconnectCustomer))
    }
    
    func testCreateThrowsCustomerUnsupportedChannelConfig() {
        socketService.connectionContext.visitorId = nil
        
        XCTAssertThrowsError(try eventsService.create(.reconnectCustomer))
    }
    
    func testCreateSuccecsful() {
        eventsService.connectionContext.customer = CustomerIdentityDTO(idOnExternalPlatform: UUID().uuidString, firstName: "John", lastName: "Doe")
        eventsService.connectionContext.visitorId = UUID()
        
        XCTAssertNoThrow(try eventsService.create(.reconnectCustomer))
    }
}
