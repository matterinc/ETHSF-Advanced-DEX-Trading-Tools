//
//  SettingViewController.swift
//  loopr-ios
//
//  Created by Xiao Dou Dou on 2/3/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingsTableView: UITableView!
    
    let sectionTitles = [LocalizedString("User Preferences", comment: ""), LocalizedString("Trading", comment: ""), LocalizedString("Security", comment: ""), LocalizedString("About", comment: "")]
    let sectionRows = [1, 4, 2, 1]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = LocalizedString("Settings", comment: "")
        
        view.theme_backgroundColor = ColorPicker.backgroundColor
        settingsTableView.separatorStyle = .none
        settingsTableView.tableFooterView = UIView()
        settingsTableView.delaysContentTouches = false
        settingsTableView.theme_backgroundColor = ColorPicker.backgroundColor
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 10))
        headerView.theme_backgroundColor = ColorPicker.backgroundColor
        settingsTableView.tableHeaderView = headerView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsTableView.reloadData()
        self.navigationItem.title = LocalizedString("Settings", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Table view configuration
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return partnerSectionForCell(indexPath: indexPath)
        case 1:
            return userPreferencesSectionForCell(indexPath: indexPath)
        case 2:
            return tradingSectionForCell(indexPath: indexPath)
        case 3:
            return aboutSectionForCell(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                print("Setting partner")
                let viewController = SettingPartnerViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        case 1:
            switch indexPath.row {
            case 0:
                print("Setting wallet")
                let viewController = SettingManageWalletViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            case 1:
                print("Setting currency")
                let viewController = SettingCurrencyViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            case 2:
                print("Setting language")
                let viewController = SettingLanguageViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            case 3:
                print("Touch id")
                if !AuthenticationDataManager.shared.devicePasscodeEnabled() {
                    let title: String
                    if BiometricType.get() == .touchID {
                        title = LocalizedString("Please turn on Touch ID in settings", comment: "")
                    } else {
                        title = LocalizedString("Please turn on Face ID in settings", comment: "")
                    }
                    let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: LocalizedString("OK", comment: ""), style: .default, handler: { _ in
                        
                    }))
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                print("contract version")
                let viewController = DisplayContractVersionViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            case 1:
                print("LRC Fee ratio")
                let viewController = SettingLRCFeeRatioViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            case 2:
                // TODO: Trade FAQ is not ready.
                print("Trade FAQ")
                let viewController = TradeFAQViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            default:
                break
            }
        case 3:
            // About
            switch indexPath.row {
            default:
                break
            }
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            if BiometricType.get() == .none {
                return 3
            } else {
                return 4
            }
        } else {
            return sectionRows[section]
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: UIView
        if section == 1 {
            headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 48))
            headerView.theme_backgroundColor = ColorPicker.backgroundColor
            let infoLabel = UILabel(frame: CGRect(x: 23, y: 16, width: headerView.width - 23*2, height: 16))
            infoLabel.text = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.address
            infoLabel.font = FontConfigManager.shared.getRegularFont(size: 12)
            infoLabel.theme_textColor = GlobalPicker.textLightColor
            infoLabel.lineBreakMode = .byTruncatingMiddle
            headerView.addSubview(infoLabel)
        } else {
            headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
            headerView.theme_backgroundColor = ColorPicker.backgroundColor
        }
        return headerView
    }
    
    // Sections
    func partnerSectionForCell(indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            var cell = settingsTableView.dequeueReusableCell(withIdentifier: SettingStyleTableViewCell.getCellIdentifier()) as? SettingStyleTableViewCell
            if cell == nil {
                let nib = Bundle.main.loadNibNamed("SettingStyleTableViewCell", owner: self, options: nil)
                cell = nib![0] as? SettingStyleTableViewCell
            }
            
            cell?.leftLabel.textColor = .success
            cell?.leftLabel.font = FontConfigManager.shared.getCharactorFont(size: 14)
            cell?.leftLabel.text = LocalizedString("Partner_Slogan", comment: "")
            cell?.rightLabel.isHidden = true
            cell?.disclosureIndicator.isHidden = false
            
            if indexPath.row == 0 {
                cell?.seperateLineUp.isHidden = false
            } else {
                cell?.seperateLineUp.isHidden = true
            }
            
            if indexPath.row == sectionRows[indexPath.section]-1 {
                cell?.trailingSeperateLineDown.constant = 0
            } else {
                cell?.trailingSeperateLineDown.constant = 15
            }
            return cell!
        default:
            return UITableViewCell()
        }
    }
    
    func userPreferencesSectionForCell(indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            var currentWalletName = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.name
            if currentWalletName == nil {
                currentWalletName = ""
            }
            return createDetailTableCell(indexPath: indexPath, title: LocalizedString("Manage Wallets", comment: ""))
        case 1:
            return createDetailTableCell(indexPath: indexPath, title: LocalizedString("Currency", comment: ""))
        case 2:
            return createDetailTableCell(indexPath: indexPath, title: LocalizedString("Language", comment: ""))
        case 3:
            return createSettingPasscodeTableView(indexPath: indexPath)
        default:
            return UITableViewCell()
        }
        
    }

    func tradingSectionForCell(indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return createDetailTableCell(indexPath: indexPath, title: LocalizedString("Contract Version", comment: ""))
        case 1:
            return createDetailTableCell(indexPath: indexPath, title: LocalizedString("LRC Fee Ratio", comment: ""))
        case 2:
            return createDetailTableCell(indexPath: indexPath, title: LocalizedString("Trade FAQ", comment: ""))
        default:
            return UITableViewCell()
        }
    }

    func aboutSectionForCell(indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            var cell = settingsTableView.dequeueReusableCell(withIdentifier: SettingStyleTableViewCell.getCellIdentifier()) as? SettingStyleTableViewCell
            if cell == nil {
                let nib = Bundle.main.loadNibNamed("SettingStyleTableViewCell", owner: self, options: nil)
                cell = nib![0] as? SettingStyleTableViewCell
            }
            cell?.selectionStyle = .none
            cell?.leftLabel.text = title
            cell?.rightLabel.isHidden = false
            cell?.disclosureIndicator.isHidden = true
            if indexPath.row == 0 {
                cell?.seperateLineUp.isHidden = false
            } else {
                cell?.seperateLineUp.isHidden = true
            }
            
            if indexPath.row == sectionRows[indexPath.section]-1 {
                cell?.trailingSeperateLineDown.constant = 0
            } else {
                cell?.trailingSeperateLineDown.constant = 15
            }
            cell?.leftLabel.text = LocalizedString("App Version", comment: "")
            cell?.rightLabel.text = getAppVersion()

            return cell!
        default:
            return UITableViewCell()
        }
    }
    
    // Cell Types
    func createSettingPasscodeTableView(indexPath: IndexPath) -> UITableViewCell {
        var cell = settingsTableView.dequeueReusableCell(withIdentifier: SettingPasscodeTableViewCell.getCellIdentifier()) as? SettingPasscodeTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("SettingPasscodeTableViewCell", owner: self, options: nil)
            cell = nib![0] as? SettingPasscodeTableViewCell
            cell?.selectionStyle = .none
        }

        if indexPath.row == 0 {
            cell?.seperateLineUp.isHidden = false
        } else {
            cell?.seperateLineUp.isHidden = true
        }
        
        if indexPath.row == sectionRows[indexPath.section]-1 {
            cell?.trailingSeperateLineDown.constant = 0
        } else {
            cell?.trailingSeperateLineDown.constant = 15
        }

        return cell!
    }
    
    func createThemeMode(indexPath: IndexPath) -> UITableViewCell {
        var cell = settingsTableView.dequeueReusableCell(withIdentifier: SettingThemeModeTableViewCell.getCellIdentifier()) as? SettingThemeModeTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("SettingThemeModeTableViewCell", owner: self, options: nil)
            cell = nib![0] as? SettingThemeModeTableViewCell
            cell?.selectionStyle = .none
        }

        if indexPath.row == 0 {
            cell?.seperateLineUp.isHidden = false
        } else {
            cell?.seperateLineUp.isHidden = true
        }
        
        if indexPath.row == sectionRows[indexPath.section]-1 {
            cell?.trailingSeperateLineDown.constant = 0
        } else {
            cell?.trailingSeperateLineDown.constant = 15
        }

        return cell!
    }
    
    func createDetailTableCell(indexPath: IndexPath, title: String) -> UITableViewCell {
        var cell = settingsTableView.dequeueReusableCell(withIdentifier: SettingStyleTableViewCell.getCellIdentifier()) as? SettingStyleTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("SettingStyleTableViewCell", owner: self, options: nil)
            cell = nib![0] as? SettingStyleTableViewCell
        }
        
        cell?.leftLabel.text = title
        cell?.rightLabel.isHidden = true
        cell?.disclosureIndicator.isHidden = false

        if indexPath.row == 0 {
            cell?.seperateLineUp.isHidden = false
        } else {
            cell?.seperateLineUp.isHidden = true
        }
        
        if indexPath.row == sectionRows[indexPath.section]-1 {
            cell?.trailingSeperateLineDown.constant = 0
        } else {
            cell?.trailingSeperateLineDown.constant = 15
        }
        
        return cell!
    }
    
    func createBasicTableCell(title: String, detailTitle: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: title)
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.textLabel?.text = title
        cell.textLabel?.font = FontConfigManager.shared.getMediumFont(size: 14)
        cell.textLabel?.textColor = Themes.isDark() ? UIColor.white : UIColor.dark2
        cell.detailTextLabel?.text = detailTitle
        cell.detailTextLabel?.font = FontConfigManager.shared.getRegularFont(size: 14)
        cell.textLabel?.textColor = Themes.isDark() ? UIColor.white : UIColor.dark2
        cell.backgroundColor = Themes.isDark() ? UIColor.dark2 : UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 48
        } else {
            return 10
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
    func getAppVersion() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
        return version + " (" + build + ")"
    }
}
