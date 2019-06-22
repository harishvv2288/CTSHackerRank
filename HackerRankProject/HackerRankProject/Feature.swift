//
//  Feature.swift
//  HackerRankProject
//
//  Created by Harish V V on 22/06/19.
//  Copyright © 2019 Company. All rights reserved.
//

import Foundation

///This acts as the ViewModel class which handles all the business logic

enum RequestableResult<T> {
    
    case result(T)
    case error(Any?)
    case partial(data:T?, chunkId: Any)
    case notsupported
    case timeout
    
    public var value: T? {
        switch self {
        case .result(let value):
            return value
        case .partial(data: let value, chunkId: _):
            return value
        default:
            return nil
        }
    }
    
    public var hasResult: Bool {
        switch self {
        case .result, .partial:
            return true
        default:
            return false
        }
    }
    
    public var hasError: Bool {
        switch self {
        case .error, .notsupported, .timeout:
            return true
        default:
            return false
        }
    }
    
}
