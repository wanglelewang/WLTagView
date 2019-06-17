//
//  WLTagItemModel.swift
//  WL
//
//  Created by 2345 on 2019/5/27.
//  Copyright © 2019 yoser. All rights reserved.
//

import UIKit

class WLTagItemModel: NSObject {
    
    ///标签文字
    @objc open var tagText: String?
    ///标签字体
    @objc open var tagFont: UIFont? = UIFont.systemFont(ofSize: 12)
    ///标签正常文字颜色
    @objc open var tagTextNormalColor: UIColor?
    ///标签选中文字颜色
    @objc open var tagTextSelectedColor: UIColor?
    ///标签正常背景色
    @objc open var tagNormalBgColor: UIColor?
    ///标签选中背景色
    @objc open var tagSelectedBgColor: UIColor?
    ///标签正常图片
    @objc open var tagNormalImage: UIImage?
    ///标签选中图片
    @objc open var tagSelectedImage: UIImage?
    ///标签正常背景图片
    @objc open var tagNormalBgImage: UIImage?
    ///标签选中背景图片
    @objc open var tagSelectedBgImage: UIImage?
    ///标签圆角
    @objc open var tagCornerRadius: CGFloat = 2
    ///标签image leftPadding
    @objc open var tagImageLeftPadding: CGFloat = 5
    ///是否选中
    open var tagIsSelected: Bool? = false
    ///兼容OC是否选中
    @objc open var ocTagIsSelected: Int {
        set{
            self.tagIsSelected = (newValue == 1 ? true : false)
        }
        get {
            return (self.tagIsSelected ?? false) ? 1: 0
        }
    }
    

}
