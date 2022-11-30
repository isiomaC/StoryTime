//
//  Prompt.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation

struct PromptPost {
    var prompt: String?
    var model: String
    var temperature: Decimal?
    var maxTokens: Int?
    var topP: Decimal?
    var frequencyPenalty: Decimal?
    var presencePenalty: Decimal?
}

struct Prompt {
    var prompt: String
    var model: String
    var temperature: Decimal
    var maxTokens: Int
    var topP: Decimal
    var frequencyPenalty: Decimal
    var presencePenalty: Decimal
}
