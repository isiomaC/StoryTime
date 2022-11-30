//
//  Prediction.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation


struct Prediction: Codable {
    var id: String      //'cmpl-6H4IkrqIxsf5ON0f66eWFCdSh5eKO',
    var object: String  //'text_completion',
    var created: Int    // 1669526130,
    var model: String
//    var prompt: String
    var choices: [Choice]
}

struct Choice: Codable {
    var text: String
    var index: Int
//    var logprobs:? ?? Unknow type, was nil
    var finish_reason: String
}
