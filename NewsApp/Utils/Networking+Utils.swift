//
//  Networking+Utils.swift
//  NewsApp
//
//  Created by Vishal Madheshia on 2/24/19.
//  Copyright © 2019 Vishal Madheshia. All rights reserved.
//

import Foundation

func jsonSerializedUTF8(json: [String: Any]) -> Data {
    do {
        return try JSONSerialization.data(
            withJSONObject: json,
            options: [.prettyPrinted]
        )
    } catch {
        return Data()
    }
}
