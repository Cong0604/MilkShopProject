//
//  DetailOrderVC.swift
//  MilkShopProject
//
//  Created by CongDev on 11/5/25.
//

import UIKit

class DetailOrderVC: BaseViewController {

    @IBOutlet weak var detailOrderTableView: UITableView!
    @IBOutlet weak var ctnHeightTableView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView(detailOrderTableView, OrderCell.self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.ctnHeightTableView.constant = self.detailOrderTableView.contentSize.height
        }
    }
}

extension DetailOrderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: OrderCell.self, for: indexPath)
//        cell.configure(with: selectedCartItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
