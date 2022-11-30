//
//  WritingViewModel.swift
//  StoryTime
//
//  Created by Chuck on 27/11/2022.
//

import Foundation


class WritingViewModel{
    
    var writingData: ObservableObject<String> = ObservableObject(nil)
    
    var error: ObservableObject<String> = ObservableObject(nil)
    
    var options: ObservableObject<[String: String]?> = ObservableObject(nil)
    
    
    init(view: WritingView){
        
    }
    
    //MARK: TODO - use network to get prompts from openai
    func triggerPrompt(){
        
    }
    
    //MARK: TODO - Prompt options will be listened for here
    func updateOptions(){
        
    }
    
}
