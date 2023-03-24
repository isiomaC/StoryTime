//
//  PromptDTO.swift
//  StoryTime
//
//  Created by Chuck on 02/12/2022.
//

import Foundation

// MARK: For displaying data on UI (davinci-003)
struct PromptDTO: Hashable, Codable, Equatable {
    
    var id: String?
    var prompt: String?
    var outputText: String?
    var promptOutput: PromptOutputDTO?
    
    init(prompt: Prompt){
        self.id = prompt.id
        self.prompt = prompt.prompt
        self.outputText = prompt.output.choices.first?.text
        self.promptOutput = prompt.output
    }
    
    init(id: String?, prompt: String, promptOutput: PromptOutputDTO?) {
        self.id = id
        self.prompt = prompt
        self.outputText = promptOutput?.choices.first?.text
        self.promptOutput = promptOutput
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(prompt)
        hasher.combine(outputText)
    }
    
//    init(id: String?, prompt: String?, outputText: String?) {
//        self.id = id
//        self.prompt = prompt
//        self.outputText = outputText
//    }
    
    static func == (lhs: PromptDTO, rhs: PromptDTO) -> Bool {
        lhs.id == rhs.id && lhs.promptOutput == rhs.promptOutput && lhs.prompt == rhs.prompt
    }
}

//MARK: For displaying data on UI (chatGpt)
struct PromptChatDTO: Hashable, Codable, Equatable {
    
    var id: String?
    var prompt: String?
    var outputText: String?
    var promptOutput: PromptOutputChatGptDTO?
    
    init(prompt: PromptV2){
        self.id = prompt.id
        self.prompt = prompt.prompt
        self.outputText = prompt.output.choices.first?.message.content
        self.promptOutput = prompt.output
    }
    
    init(id: String?, prompt: String, promptOutput: PromptOutputChatGptDTO?) {
        self.id = id
        self.prompt = prompt
        self.outputText = promptOutput?.choices.first?.message.content
        self.promptOutput = promptOutput
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(prompt)
        hasher.combine(outputText)
    }
    
    static func == (lhs: PromptChatDTO, rhs: PromptChatDTO) -> Bool {
        lhs.id == rhs.id && lhs.promptOutput == rhs.promptOutput && lhs.prompt == rhs.prompt
    }
}


// MARK: For sending prompt to backend server
struct PromptPostDTO: Codable, Hashable{
    var prompt: String
    var model: String?
    var temperature: Decimal?
    var maxTokens: Int?
    var topP: Decimal?
    var frequencyPenalty: Decimal?
    var presencePenalty: Decimal?
}


//MARK: Output from prompt posted to backend server
struct PromptOutputDTO: Codable, Equatable {
   
    var id: String      //'cmpl-6H4IkrqIxsf5ON0f66eWFCdSh5eKO',
    var object: String  //'text_completion',
    var created: Int    // 1669526130,
    var model: String
    var choices: [Choice]
    var usage: Usage
    
    static func == (lhs: PromptOutputDTO, rhs: PromptOutputDTO) -> Bool {
        lhs.id == rhs.id && lhs.choices == rhs.choices
    }
}

struct Choice: Codable, Equatable {
    var text: String
    var index: Int
    var logprobs: String?
    var finish_reason: String
    
    static func == (lhs: Choice, rhs: Choice) -> Bool {
        lhs.text == rhs.text
    }
}


//MARK: Output from chatGpt prompt posted to backend server
struct PromptOutputChatGptDTO: Codable, Equatable {
    
     var id: String      //'cmpl-6H4IkrqIxsf5ON0f66eWFCdSh5eKO',
     var object: String  //'text_completion',
     var created: Int    // 1669526130,
     var model: String
     var choices: [ChoiceChatGpt]
     var usage: Usage
     
     static func == (lhs: PromptOutputChatGptDTO, rhs: PromptOutputChatGptDTO) -> Bool {
         lhs.id == rhs.id && lhs.choices == rhs.choices
     }
}

struct ChoiceChatGpt: Codable, Equatable {
    var message: ChatGptMessage
    var index: Int
    var finish_reason: String
    
    static func == (lhs: ChoiceChatGpt, rhs: ChoiceChatGpt) -> Bool {
        lhs.message == rhs.message
    }
}

struct ChatGptMessage: Codable, Equatable {
    var role: String
    var content: String
}

struct Usage: Codable {
    var prompt_tokens: Int
    var completion_tokens: Int
    var total_tokens :Int
}
