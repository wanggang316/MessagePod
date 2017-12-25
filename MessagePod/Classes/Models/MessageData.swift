//
//  MessageData.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import Foundation
import CoreLocation

public enum MessageData {
    case text(String, [String: String]?)
    case location(String, String, CLLocation)
}
