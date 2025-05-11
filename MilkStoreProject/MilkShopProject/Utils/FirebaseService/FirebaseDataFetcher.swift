import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseDataFetcher {
    
    static let shared = FirebaseDataFetcher()
    
    private let db: Firestore
    
    init() {
        db = Firestore.firestore()
    }
    
    
    func fetchAllMilks(completion: @escaping (Milks?, Error?) -> Void) {
        db.collection("milks").getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(nil, NSError(domain: "FirebaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Không có dữ liệu"]))
                return
            }
            
            var dataMilkList: [DataMilk] = []
            
            for document in snapshot.documents {
                do {
                    let dataMilk = try document.data(as: DataMilk.self)
                    dataMilkList.append(dataMilk)
                } catch {
                    print("Lỗi khi chuyển đổi document: \(error)")
                }
            }
            
            let milks = Milks()
            milks.dataMilk = dataMilkList
            completion(milks, nil)
        }
    }
    
    func fetchProduct(by id: String, completion: @escaping ((DataMilk?) -> Void)) {
        db.collection("milks")
            .whereField("idProduct", isEqualTo: id)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching product: \(error)")
                    completion(nil)
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("No product found with idProduct: \(id)")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                    let milk = try JSONDecoder().decode(DataMilk.self, from: jsonData)
                    completion(milk)
                } catch {
                    print("Decode error: \(error)")
                    completion(nil)
                }
            }
    }
    
    func updateUserAddress(uid: String, newAddress: String, completion: ((Error?) -> Void)? = nil) {
        let db = Firestore.firestore()
        let userRef = db.collection("usernew").document(uid)
        
        userRef.updateData([
            "address": FieldValue.arrayUnion([newAddress])
        ]) { error in
            if let error = error {
                print("[HL-LOG] Update address error: \(error.localizedDescription)")
            } else {
                print("[HL-LOG] Address updated successfully.")
            }
            completion?(error)
        }
    }
    
    func fetchUserAddresses(uid: String, completion: @escaping ([String]?, Error?) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("usernew").document(uid)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                if let addressArray = document.data()?["address"] as? [String] {
                    completion(addressArray, nil)
                } else {
                    completion([], nil)
                }
            } else {
                completion(nil, error)
            }
        }
    }
}
