//
//  AccountVC.swift
//  MilkShopProject
//
//  Created by CongDev on 9/5/25.
//

import UIKit
import Firebase

class AccountVC: BaseViewController {
    
    @IBOutlet weak var phoneNumberUserLabel: UILabel!
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var infoUserTableView: UITableView!
    
    private var infoType: [InfoUserType] = InfoUserType.allCases
    private var nameUser = ""
    private var phoneNumberUser = ""
    private var isRole = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView(infoUserTableView, InfoCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserInfo()
    }
    
    private func fetchUserInfo() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let userRef = db.collection("usernew").document(userId)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let phoneNumber = document.data()?["phone"] as? String ?? "Unknown"
                let name = document.data()?["username"] as? String ?? "Unknown"
                DispatchQueue.main.async {
                    self.nameUserLabel.text = name
                    self.phoneNumberUserLabel.text = phoneNumber
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

extension AccountVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: InfoCell.self, for: indexPath)
        cell.configure(item: infoType[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch infoType[indexPath.row] {
        case .changeInfo:
            let vc = ChangeInfoVC()
            vc.callBack = { [weak self] name,phone in
                guard let self = self else { return }
                
                self.nameUserLabel.text = name
                self.phoneNumberUserLabel.text = phone
                Global.isDimissBottomSheet = false
            }
            self.openBottomSheet(vc: vc, ratioView: 0.5, corner: 0)
        case .changePassword:
            let vc = ChangePasswordVC()
            self.openBottomSheet(vc: vc, ratioView: 0.5, corner: 0)
        case .address:
            let vc = AddressVC()
            self.push(vc)
            
        default:
            break
        }
    }
}
