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
    
    var currentPrompt: PromptDTO?
    
    init(){ }
    
    func triggerPrompt(_ text: String){
        NetworkService.shared.postPrompt(text)
    }
    
//    func updatePromptOuput(_ uid: String, prompt: PromptDTO, completion: @escaping(Error?) -> Void){
//        guard let promptId = prompt.id else {
//            return
//        }
//        
//        let promptToUpdate : [String: Any] = [
//            "prompt": prompt.prompt as Any,
//            "output": prompt.promptOutput as Any
//        ]
//
//        FirebaseService.shared.updateDocumentById(.promptOuput, id: promptId, data: promptToUpdate) { error in
//            guard error == nil else {
//                completion(error)
//                return
//            }
//            completion(nil)
//        }
//    }
    
    func savePromptOutput(_ uid: String, prompt: PromptDTO?, completion: @escaping(Error?) -> Void){
        
        guard let myPrompt = prompt, let promptText = myPrompt.prompt, let promptOuput = myPrompt.promptOutput else {
            return
        }
        
        let newPrompt = Prompt(id: "", prompt: promptText, userId: uid, output: promptOuput)
        
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
    
}
