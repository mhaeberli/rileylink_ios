//
//  BGReceived.swift
//  RileyLink
//
//  Created by Pete Schwamb on 3/8/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

import Foundation

public struct BGReceivedPumpEvent: TimestampedPumpEvent {
    public let length: Int
    public let rawData: NSData
    public let timestamp: NSDateComponents
    public let amount: Int
    public let meter: String
    
    public init?(availableData: NSData, pumpModel: PumpModel) {
        length = 10
        
        guard length <= availableData.length else {
            return nil
        }

        rawData = availableData[0..<length]
        
        func d(idx:Int) -> Int {
            return Int(availableData[idx] as UInt8)
        }
        
        timestamp = NSDateComponents(pumpEventData: availableData, offset: 2)
        amount = (d(1) << 3) + (d(4) >> 5)
        meter = availableData.subdataWithRange(NSMakeRange(7, 3)).hexadecimalString
    }
    
    public var dictionaryRepresentation: [String: AnyObject] {
        return [
            "_type": "BGReceivedPumpEvent",
            "amount": amount,
            "meter": meter,
        ]
    }
}
