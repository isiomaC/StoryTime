//
//  Utils.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation

struct Utils {
    static func readFromPList(_ filename: String, key: String) -> String{
        guard let filePath = Bundle.main.path(forResource: filename, ofType: "plist") else {
          fatalError("Couldn't find file '\(filename).plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: key) as? String else {
          fatalError("Couldn't find key '\(key)' in '\(filename).plist'.")
        }
        return value
    }
}
