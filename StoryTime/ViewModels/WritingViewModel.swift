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
    
    var options: ObservableObject<[String: Any]?> = ObservableObject(nil)
    
    var outputText: ObservableObject<String> = ObservableObject(nil)
    
    
    init(){
        NetworkService.shared.delegate = self
    }
    
    //MARK: TODO - use network to get prompts from openai
    func triggerPrompt(_ text: String){
        NetworkService.shared.postPrompt(text)
        
    }
    
    func savePromptOutput(){
//        FirebaseService.shared.saveDocument(.promptOuput, data: <#T##[String : Any]#>)
    }
    
}


extension WritingViewModel: NetworkServiceDelegate  {
    func success(_ network: NetworkService, output: PromptOutputDTO) {
        outputText.value = output.choices.first?.text
    }
    
    func failure(error: Error?) {
        errorText.value = error?.localizedDescription
    }
}
