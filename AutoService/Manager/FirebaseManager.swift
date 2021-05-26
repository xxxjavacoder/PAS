import FirebaseDatabase
import Firebase

protocol FirebaseManagerProtocol: class {
    func getTests(completion: @escaping (Result<TestsEntity, Error>) -> Void)
}

final class FirebaseManager: FirebaseManagerProtocol {
    
    private var ref: DatabaseReference!
    
    func getTests(completion: @escaping (Result<TestsEntity, Error>) -> Void) {
        ref = Database.database().reference()
        
        ref.getData(completion: { error, snapshot in
            if snapshot.exists(),
               let json = snapshot.value as? NSDictionary,
               let data = try? JSONSerialization.data(withJSONObject: json, options: []),
               let model = try? JSONDecoder().decode(TestsEntity.self, from: data) {
                
                completion(.success(model))
            } else if let error = error {
                completion(.failure(error))
            }
        })
    }
}
