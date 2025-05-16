//
//  ForgotPasswordVC.swift
//  MilkShopProject
//
//  Created by CongDev on 15/5/25.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordVC: BaseViewController {

    @IBOutlet weak var numberPhoneTF: UITextField!
    private var verificationID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTap()
    }
    
    override func setupUI() {
        numberPhoneTF.delegate = self
        numberPhoneTF.keyboardType = .phonePad
    }
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        // Xóa tất cả ký tự không phải số
        let numbers = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        // Nếu số điện thoại bắt đầu bằng 0, thay thế bằng +84
        if numbers.hasPrefix("0") {
            return "+84" + String(numbers.dropFirst())
        }
        
        // Nếu số điện thoại không có mã quốc gia, thêm +84
        if !numbers.hasPrefix("+") {
            return "+84" + numbers
        }
        
        return numbers
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        self.back()
    }
    
    @IBAction func didTapContinueButton(_ sender: Any) {
        guard let phoneNumber = numberPhoneTF.text, !phoneNumber.isEmpty else {
            showAlert(title: "Thông báo", message: "Vui lòng nhập số điện thoại")
            return
        }
        
        // Format số điện thoại
        let formattedPhoneNumber = formatPhoneNumber(phoneNumber)
        print("Formatted phone number: \(formattedPhoneNumber)")
        
        // Kiểm tra số điện thoại trong Firestore
        let db = Firestore.firestore()
        db.collection("usernew").whereField("phone", isEqualTo: phoneNumber).getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Lỗi", message: error.localizedDescription)
                return
            }
            
            if let snapshot = snapshot, !snapshot.documents.isEmpty {
                // Số điện thoại tồn tại, gửi mã OTP
                PhoneAuthProvider.provider().verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { [weak self] (verificationID, error) in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Error sending OTP: \(error.localizedDescription)")
                        self.showAlert(title: "Lỗi", message: error.localizedDescription)
                        return
                    }
                    
                    if let verificationID = verificationID {
                        self.verificationID = verificationID
                        let vc = AuthenPhoneNumberVC()
                        vc.verificationID = verificationID
                        vc.phoneNumber = phoneNumber
                        self.push(vc)
                    }
                }
            } else {
                self.showAlert(title: "Thông báo", message: "Số điện thoại không tồn tại trong hệ thống")
            }
        }
    }
}

extension ForgotPasswordVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 10
    }
}

extension ForgotPasswordVC {
    @objc func hideKeyboardWhenTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
