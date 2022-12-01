//
//  WritingViewModel.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation


class WritingViewModel{
    
    var writingText: ObservableObject<String> = ObservableObject(nil)
    
    var error: ObservableObject<String> = ObservableObject(nil)
    
    var options: ObservableObject<[String: Any]?> = ObservableObject(nil)
    
    var view: WritingView
    
    init(view: WritingView){
        self.view = view
    }
    
    //MARK: TODO - use network to get prompts from openai
    func triggerPrompt(){
        
    }
    
    //MARK: TODO - Prompt options will be listened for here
    func updateOptions(){
        print("Options Updated")
    }
    
    func updateTextView(){
        view.inputTextView.text = writingText.value
    }
    
    func handleError(_ vc: WritingViewController) {
        
        guard let errString = error.value else { return }
        
        vc.showAlert(.error, ("Error", errString))
    }
    
}
