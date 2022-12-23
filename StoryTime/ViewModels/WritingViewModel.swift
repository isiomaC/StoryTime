//
//  WritingViewModel.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation


class WritingViewModel {
    
    var promptText: ObservableObject<String> = ObservableObject(nil)
    
    var errorText: ObservableObject<String> = ObservableObject(nil)
    
//    var options: ObservableObject<[String: Any]?> = ObservableObject(nil)
    
    var outputText: ObservableObject<String> = ObservableObject(nil)
    
    var currentPrompt: PromptDTO?
    
    init(){ }
    
    //MARK: TODO - use network to get prompts from openai
    func triggerPrompt(_ text: String){
        NetworkService.shared.postPrompt(text)
        
    }
    
    func updatePromptOuput(_ uid: String, prompt: PromptDTO?){
        
    }
    
    func savePromptOutput(_ uid: String, prompt: PromptDTO?){
        
        guard let myPrompt = prompt, let promptText = myPrompt.prompt, let promptOuput = myPrompt.promptOutput else {
            return
        }
        
        let newPrompt = Prompt(id: "", prompt: promptText, userId: uid, output: promptOuput)
        
        guard let promptToSave = newPrompt.removeKey() else {
            return
        }
        
        FirebaseService.shared.saveDocument(.promptOuput, data: promptToSave)
    }
    
}
