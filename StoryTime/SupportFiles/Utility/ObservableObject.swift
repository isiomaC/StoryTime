//
//  ObservableObject.swift
//  StoryTime
//
//  Created by Chuck on 24/11/2022.
//

import Foundation

final class ObservableObject<T>{
    
    typealias Listener = (T?) -> Void
    
    private(set) var listener: Listener?
    
    var value: T?{
        didSet{
            listener?(value)
        }
    }
    
    init(_ value: T?){
        self.value = value
    }
    
    func bind(listener: @escaping Listener){
        listener(value)
        self.listener = listener
    }
}
