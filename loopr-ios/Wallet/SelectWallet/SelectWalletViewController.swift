//
//  SelectWalletViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 2/18/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SelectWalletViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var walletTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Switch Wallet"
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(self.pressAddButton(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        walletTableView.delegate = self
        walletTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func pressAddButton(_ button: UIBarButtonItem) {
        let setupViewController: SetupNavigationController? = SetupNavigationController(nibName: nil, bundle: nil)
        self.present(setupViewController!, animated: true) {
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WalletDataManager.shared.getWallets().count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SelectWalletTableViewCell.getHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SelectWalletTableViewCell.getCellIdentifier()) as? SelectWalletTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("SelectWalletTableViewCell", owner: self, options: nil)
            cell = nib![0] as? SelectWalletTableViewCell
        }
        
        // Configure the cell...
        cell?.wallet = WalletDataManager.shared.getWallets()[indexPath.row]
        cell?.update()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}