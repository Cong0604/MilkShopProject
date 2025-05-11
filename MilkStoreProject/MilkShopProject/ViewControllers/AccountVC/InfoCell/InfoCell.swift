//
//  InfoCell.swift
//  MilkShopProject
//
//  Created by CongDev on 9/5/25.
//

import UIKit

enum InfoUserType: Int, CaseIterable  {
    case changeInfo
    case changePassword
    case order
    case cart
    case address
    case contact
    case logout
    
    var iconName: UIImage? {
        switch self {
        case .changeInfo:
            return .icUserAccount
        case .changePassword:
            return .icChangePw
        case .order:
            return .icOrder
        case .cart:
            return .icCart
        case .logout:
            return .icLogout
        case .address:
            return .icAddress
        case .contact:
            return .icContact
        }
    }
    
    var name: String {
        switch self {
        case .changeInfo:
            return "Đổi thông tin"
        case .changePassword:
            return "Đổi mật khẩu"
        case .order:
            return "Đơn hàng"
        case .cart:
            return "Giỏ hàng"
        case .logout:
            return "Đăng xuất"
        case .address:
            return "Địa chỉ"
        case .contact:
            return "Liên hệ"
        }
    }
}


class InfoCell: UITableViewCell {

    @IBOutlet weak var nameInfoLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: InfoUserType) {
        self.infoImageView.image = item.iconName
        self.nameInfoLabel.text = item.name
    }
}
