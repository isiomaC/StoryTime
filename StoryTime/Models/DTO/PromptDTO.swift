//
//  PromptDTO.swift
//  StoryTime
//
//  Created by Chuck on 02/12/2022.
//

import Foundation

// MARK: For displaying data on UI
struct PromptDTO: Hashable, Codable {
    
    let id: String
    let prompt: String?
    let outputText: String?
    
    init(prompt: Prompt){
        self.id = prompt.id
        self.prompt = prompt.prompt
        self.outputText = prompt.output.choices.first?.text
    }
    
    init(id: String, prompt: String, promptOutput: PromptOutputDTO) {
        self.id = id
        self.prompt = prompt
        self.outputText = promptOutput.choices.first?.text
    }
    
    static func == (lhs: PromptDTO, rhs: PromptDTO) -> Bool {
        lhs.id == rhs.id
    }
}


// MARK: For sending prompt to backend server
struct PromptPostDTO: Codable {
    var prompt: String
    var model: String?
    var temperature: Decimal?
    var maxTokens: Int?
    var topP: Decimal?
    var frequencyPenalty: Decimal?
    var presencePenalty: Decimal?
}


//MARK: Output from prompt posted to backend server
struct PromptOutputDTO: Codable {
    var id: String      //'cmpl-6H4IkrqIxsf5ON0f66eWFCdSh5eKO',
    var object: String  //'text_completion',
    var created: Int    // 1669526130,
    var model: String
    var choices: [Choice]
    var usage: Usage
}

struct Choice: Codable {
    var text: String
    var index: Int
    var logprobs: String?
    var finish_reason: String
}

struct Usage: Codable {
    var prompt_tokens: Int
    var completion_tokens: Int
    var total_tokens :Int
}
