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
    
    var outputText: ObservableObject<String> = ObservableObject(nil)
    
//    var currentPrompt: PromptDTO?
    var currentPrompt: PromptChatDTO?
    
    init(){ }
    
    func triggerPrompt(_ text: String){
        NetworkService.shared.postPromptChatGpt(text)
    }
    
    
    func savePromptOutput(_ uid: String, prompt: PromptChatDTO?, completion: @escaping(Error?) -> Void){
        
        guard let myPrompt = prompt, let promptText = myPrompt.prompt, let promptOuput = myPrompt.promptOutput else {
            return
        }
        
        let newPrompt = PromptV2(id: "", prompt: promptText, userId: uid, output: promptOuput)
        
        guard let promptToSave = newPrompt.removeKey() else {
            return
        }
        
        FirebaseService.shared.saveDocument(.promptOuput, data: promptToSave){ ref, error in
            guard error == nil else {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
    
    
//    func savePromptOutput(_ uid: String, prompt: PromptDTO?, completion: @escaping(Error?) -> Void){
//
//        guard let myPrompt = prompt, let promptText = myPrompt.prompt, let promptOuput = myPrompt.promptOutput else {
//            return
//        }
//
//        let newPrompt = Prompt(id: "", prompt: promptText, userId: uid, output: promptOuput)
//
//        guard let promptToSave = newPrompt.removeKey() else {
//            return
//        }
//
//        FirebaseService.shared.saveDocument(.promptOuput, data: promptToSave){ ref, error in
//            guard error == nil else {
//                completion(error)
//                return
//            }
//
//            completion(nil)
//        }
//    }
    
}
