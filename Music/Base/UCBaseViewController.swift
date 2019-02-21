//
//  UCBaseViewController.swift
//  UCash
//
//  Created by Khiem on 2018-11-09.
//  Copyright © 2018 SuSoft. All rights reserved.
//

import Foundation
import UIKit
class UCBaseViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var isTransParentBar:Bool = true
    var isSetupNavigation = true
    var isShowMenu:Bool = false
    var isShowWhiteMenu:Bool = false
    var isShowBackButton:Bool = false
    var isShowNoti:Bool = false
    var colorTitle = UIColor.white
    
    var screenName:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
        }
        self.initData()
        self.initUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        if isSetupNavigation{
            if self.isShowBackButton {
                let imgLeft = UIImage.init(named: "ic_back")
                self.LeftBarButtonWithImage(imgLeft!)
            }
            if self.isShowMenu {
                let imgLeft = UIImage.init(named: "ic_menu_gray")
                self.LeftBarButtonWithImage(imgLeft!)
            }
            if self.isShowWhiteMenu {
                let imgLeft = UIImage.init(named: "ic_menu_white")
                self.LeftBarButtonWithImage(imgLeft!)
            }
            if self.isShowNoti {
                let imgNoti = UIImage.init(named: "ic_mail")
                self.setRightNavButton(withImage: imgNoti!)
            }
            if self.isTransParentBar {
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
                self.navigationController?.navigationBar.isTranslucent = true
                self.navigationController?.view.backgroundColor = UIColor.clear
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : colorTitle]

            }
            else
            {
//                self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
//                self.navigationController?.navigationBar.tintColor = .white
//                self.navigationController?.navigationBar.backgroundColor = .clear
//                self.navigationController?.navigationBar.isTranslucent = false
//                self.navigationController?.navigationBar.barTintColor = NAVIGATION_COLOR
//                self.navigationController?.view.backgroundColor = UIColor.clear
//                self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(named: "topbar"), for: UIBarMetrics.default)
            }
        }
    }
    
    
    
    func initData()
    {
        
    }
    func initUI()
    {
        
    }
    
    public func setRightNavButton (withImage image: UIImage, tintColor: UIColor = .white, imageInsets: UIEdgeInsets = .zero) {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.tintColor = tintColor
        button.frame = CGRect(x: -10, y: 0, width: 44, height: 44)
        button.imageEdgeInsets = imageInsets
        button.addTarget(self, action: #selector(self.onPressRightNavButton), for: .touchUpInside)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    @objc func onPressRightNavButton () {
    }
    
    
    public func LeftBarButtonWithImage(_ buttonImage: UIImage) {
        let btnLeft = UIButton(type: .custom)
        btnLeft.setImage(buttonImage, for: .normal)
        btnLeft.frame = CGRect(x: -10, y: 0, width: 50, height: 50)
        btnLeft.addTarget(self, action: #selector(self.tapLeft), for: .touchUpInside)
        btnLeft.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        let leftButton = UIBarButtonItem(customView: btnLeft)
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func tapLeft() {
        if self.isShowBackButton
        {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func setHeadView(color:UIColor,image:String) {
        
    }
}
