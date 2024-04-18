//
//  WebPageVC.swift
//  ICan
//
//  Created by Manuka Dewanarayana on 2023-11-27.
//  Copyright © 2023 dzl. All rights reserved.
//

import UIKit

class WebPageVC: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    @objc var pageTitle: String?
    @objc var isChat: Bool = false as Bool
    @objc var isPay: Bool = false as Bool
    @objc var isCommon: Bool = false as Bool
    @objc var isProperty: Bool = false as Bool
    @objc var isCnt: Bool = false as Bool
    @objc var isDynamicMessage: Bool = false as Bool
    @objc var chatUrlString: String?
    @objc var payUrlString: String?
    @objc var walletUrlString: String?
    @objc var dynamicMessageURL: String?
    @objc var htmlString: String?
    @objc var stringUrl: String?
    @objc var userInfoManager = UserInfoManager.self;
    @objc var appDelegate = AppDelegate.self;
    @objc let c2cUserManager = C2CUserManager.self;
    
    @objc dynamic var closeButtonHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_nav_back_black"), style: .plain, target: self, action: #selector(backButtonPressed(_:)))

        if self.isProperty {
            self.stringUrl = "https://properties.icanlk.com/#/"
            self.title = "iCan Property"
        } else if self.isCnt {
            let token = userInfoManager.shared().token
            let c2cToken = C2CUserManager.shared().token
            let baseUrl = "https://icanpay.app/home?"
            let strToken = "token="
            let strC2cToken = "&c2cToken="
            let formattedString = "\(baseUrl)\(strToken)\(token ?? "")\(strC2cToken)\(c2cToken ?? "")"
            self.stringUrl = formattedString
            self.title = "CNT"
        } else if self.isCommon {
            self.stringUrl = self.walletUrlString
            self.title = ""
        } else if self.isPay {
            self.stringUrl = self.payUrlString
            self.title = ""
        } else if self.isDynamicMessage {
            self.title = ""
            if let dynamicMessageURL = self.dynamicMessageURL {
                self.stringUrl = dynamicMessageURL
            } else {
                self.webView?.loadHTMLString(self.htmlString ?? "", baseURL: nil)
                return
            }
        } else {
            if !self.isChat {
                let languageCode = Locale.preferredLanguages.first ?? ""
                let countryCodeStr = userInfoManager.shared().countriesCode
                self.stringUrl = "https://mall.icanlk.com/?country=\(countryCodeStr)&&language=\(languageCode)"
            } else {
                self.title = ""
                self.stringUrl = self.chatUrlString
            }
        }

        if let url = URL(string: self.stringUrl ?? "") {
            let request = URLRequest(url: url)
            self.webView?.loadRequest(request)
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        } else if isChat || isDynamicMessage || isCommon {
            navigationController?.popViewController(animated: true)
        } else if isPay {
            closeButtonHandler?()
            navigationController?.popViewController(animated: true)
        } else {
            // Perform any other actions or handle back button press as needed
            self.appDelegate.shared().curNav!.popToRootViewController(animated: false)
        }
    }
}
