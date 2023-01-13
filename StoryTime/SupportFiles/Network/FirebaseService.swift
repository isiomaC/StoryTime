//
//  FirebaseService.swift
//  StoryTime
//
//  Created by Chuck on 24/11/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseFunctions

enum CollectionName : String{
    case user
    case story
    case promptOuput
    case token
}


protocol FirebasServiceDelegate{
    
    func success(_ firebaseService : FirebaseService, collectionName: CollectionName, documents: [QueryDocumentSnapshot])
    
    func success(_ firebaseService : FirebaseService, collectionName: CollectionName, ref: DocumentReference)
    
    func failure(error: Error)
    
}


class FirebaseService {
    
    
    private static var instance: FirebaseService!
    static var shared : FirebaseService = {
        if instance == nil {
            instance = FirebaseService()
        }
        return instance
    }()
    
    
    typealias DocumentSnapshotHandler = (DocumentSnapshot?, Error?) -> Void
    
    typealias QueryDocumentSnapshotHandler = ([QueryDocumentSnapshot]?, Error?) -> Void
    
    typealias DocumentRefHandler = (DocumentReference?, Error?) -> Void
    
    
    var delegate : FirebasServiceDelegate?
    
    let db : Firestore?
    
    let auth : Auth?
    
    let storage : Storage
    
    let mFunctions : Functions
    
    
    init(){
        db = Firestore.firestore()
        auth = Auth.auth()
        storage = Storage.storage()
        mFunctions = Functions.functions()
    }
    
    
    
    // MARK: Get UserId and Document by Id
    func getUID() -> String{
        return auth!.currentUser!.uid
    }
    
    
    
    
    // MARK: Get Document Section
    
    func getById(_ collectionName: CollectionName, id: String, completion: @escaping DocumentSnapshotHandler ){
        let collection = collectionName.rawValue
        
        db?.collection(collection).document(id).getDocument(completion: { (snapShot, error) in
            if let err = error {
                completion(nil, err)
            }else{
                if let document = snapShot {
                    completion(document, nil)
                }
            }
        })
    }
    
    func getDocuments(_ collectionName: CollectionName, query: [String: Any]?){
        let collection = collectionName.rawValue
        
        let collectionRef: CollectionReference? = db?.collection(collection)

        if let filter = query {
            let firebaseQuery: Query? = updateFireQuery(filter, collectionRef: collectionRef)
        
            firebaseQuery?.getDocuments(completion: { (querySnapShot, error) in
                if let err = error {
                    self.delegate?.failure(error: err)
                }else{
                    
                    if let snapShot = querySnapShot {
                        if snapShot.documents.count > 0  {
                            self.delegate?.success(self, collectionName: collectionName, documents: snapShot.documents)
                        }
                    }
                }
            })
            
        }else{
            
            db?.collection(collection).getDocuments(completion: { (querySnapShot, error) in
                if let err = error {
                    self.delegate?.failure(error: err)
                }else{
                    
                    if let snapShot = querySnapShot {
                        if snapShot.documents.count > 0  {
                            self.delegate?.success(self, collectionName: collectionName, documents: snapShot.documents)
                        }
                    }
                }
            })
        }
    }
    
    func getDocuments(_ collectionName: CollectionName, query: [String: Any]?, completion: @escaping QueryDocumentSnapshotHandler){
        let collection = collectionName.rawValue
         
        let collectionRef: CollectionReference? = db?.collection(collection)
        
        if let filter = query {
            let firebaseQuery: Query? = updateFireQuery(filter, collectionRef: collectionRef)
            
            firebaseQuery?.getDocuments(completion: { (querySnapShot, error) in
                if let err = error {
                    completion(nil, err)
                }else{
                    
                    if let snapShot = querySnapShot {
                        if snapShot.documents.count > 0  {
                            completion( snapShot.documents, nil)
                        }
                    }
                }
            })
        }else{
            db?.collection(collection).getDocuments(completion: { (querySnapShot, error) in
                if let err = error {
                    completion(nil, err)
                }else{
                    
                    if let snapShot = querySnapShot {
                        if snapShot.documents.count > 0  {
                            completion( snapShot.documents, nil)
                        }
                    }
                }
            })
        }
        
    }
    
    
    
    // MARK: Save Document Section
    func saveDocument(_ collectionName: CollectionName, data: [String : Any] ){
        var ref: DocumentReference!
        let collection = collectionName.rawValue
        
        ref = db?.collection(collection).addDocument(data: data, completion: { (error) in
            if let err = error {
                self.delegate?.failure(error: err)
            }else{
                self.delegate?.success(self, collectionName: collectionName, ref: ref)
            }
        })
    }
    
    func saveDocument(_ collectionName: CollectionName, data: [String : Any], completion: @escaping DocumentRefHandler ){
        var ref: DocumentReference?
        let collection = collectionName.rawValue
        
        ref = db?.collection(collection).addDocument(data: data, completion: { (error) in
            if let err = error {
                completion(nil, err)
            }else{
                completion(ref, nil)
            }
        })
    }
    
    
    
    // MARK: Update Document Section
    func updateDocument(_ collectionName: CollectionName, query: [String: Any], data: [String: Any], completion: @escaping (Error?) -> Void){
        
        let collection = collectionName.rawValue
        
        let collectionRef: CollectionReference? = db?.collection(collection)

        let firebaseQuery: Query? = updateFireQuery(query, collectionRef: collectionRef)
        
        firebaseQuery?.getDocuments(completion: { (querySnapShot, error) in
            guard error == nil else {
                completion(error)
                return
            }
            let document = querySnapShot?.documents.first
            document?.reference.updateData(data)
            completion(nil)
        })
    }
    
    func updateDocument(_ collectionName: CollectionName, query: [String: Any], data: [String: Any], completion: @escaping DocumentSnapshotHandler){
        
        let collection = collectionName.rawValue
        var docId : String?
        
        let collectionRef: CollectionReference? = db?.collection(collection)

        let firebaseQuery: Query? = updateFireQuery(query, collectionRef: collectionRef)
        
        firebaseQuery?.getDocuments(completion: {
            [weak self](querySnapShot, error) in

            guard let strongSelf = self, error == nil, let snapShots = querySnapShot else {
                completion(nil, error)
                return
            }
            
            if snapShots.documents.count > 0 {
                guard let docSnapShot = snapShots.documents.first else {
                    completion(nil, nil)
                    return
                }
                docId = docSnapShot.documentID
                let collectionRef = strongSelf.db?.collection(collection).document(docSnapShot.documentID)
                
                guard let unwrappedColRef = collectionRef else { return }
                
                strongSelf.db?.runTransaction({ transaction, errorPointer in
                    transaction.updateData(data, forDocument: unwrappedColRef)
                    return nil
                }, completion: { [weak self] object, error in
                    if let error = error {
                        completion(nil, error)
                    } else {
                        if let id = docId{
                            self?.db?.collection(collection).document(id).getDocument(completion: { documentSnapShot, error in
                                guard error == nil else {
                                    completion(nil, error)
                                    return
                                }
                                completion(documentSnapShot, nil)
                            })
                        }
                    }
                })
            }else{
                completion(nil, nil)
            }
        })
    }

    
    // MARK: Delete Document Section
    func deleteDocument(_ collectionName: CollectionName, docId : String){
        let collection = collectionName.rawValue
        db?.collection(collection).document(docId).delete(completion: { (error) in
            guard error == nil else { return }
        })
    }
    
    
    
    // MARK: Snapshot Listener
    func addSnapShot(_ collectionName: CollectionName) -> ListenerRegistration{
        
        let collection = collectionName.rawValue
        
        let listener  = db?.collection(collection).addSnapshotListener({ (querySnapShot, error) in
            if let err = error {
                self.delegate?.failure(error: err)
            }else{
                if let snapShot = querySnapShot {
                    if snapShot.documents.count > 0  {
                        self.delegate?.success(self, collectionName: collectionName, documents: snapShot.documents)
                    }
                }
            }
        })
        
        return listener!
    }
    
    
    
    func removeSnapShot(_ listener: ListenerRegistration){
        listener.remove()
    }
    
    
    
    // MARK: Save To Firebase Storage
    private func saveFile(){
        
    }
    
}


extension FirebaseService {
    
    //MARK: Helper Functions
    private func updateFireQuery(_ filter: [String: Any], collectionRef: CollectionReference?) -> Query?{
        
        var firebaseQuery: Query? = nil
        let count = filter.keys.count
        
        if count > 0 {
            for (key, value) in filter {
                if let q = firebaseQuery {
                    q.whereField(key, isEqualTo: value)
                }else{
                    firebaseQuery = collectionRef?.whereField(key, isEqualTo: value)
                }
            }
        }

        return firebaseQuery
    }
    
}
