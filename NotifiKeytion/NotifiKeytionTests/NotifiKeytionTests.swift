//
//  NotifiKeytionTests.swift
//  NotifiKeytionTests
//
//  Created by Sarah Lucioni on 11/30/17.
//  Copyright © 2017 Sarah Lucioni. All rights reserved.
//

import XCTest
@testable import NotifiKeytion

class NotifiKeytionTests: XCTestCase {
    
    //MARK: Item Class Tests
    
    // Confirm that the Item initialier returns nil when passed an empty name.
    func testItemInitializationFails() {
        
        // Empty String
        let emptyStringItem = Item.init(name: "", photo: nil, rowNum: 0)
        XCTAssertNil(emptyStringItem)
    }
}
