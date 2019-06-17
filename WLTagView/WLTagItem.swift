//
//  WLTagItem.swift
//  WL
//
//  Created by 2345 on 2019/5/27.
//  Copyright © 2019 yoser. All rights reserved.
//

import UIKit

class WLTagItem: UIButton {

    
    convenience init(_ itemModel: WLTagItemModel?) {
        self.init()
        self.adjustsImageWhenHighlighted = false
        self.itemModel = itemModel
    }
    
    open var itemClickBlk: ((_ itemModel: WLTagItemModel)->Void)?
    
    @objc private func itemClick(sender: WLTagItem) {
        sender.isSelected = !sender.isSelected
        self.itemModel?.tagIsSelected = !(self.itemModel?.tagIsSelected ?? true)
        self.itemClickBlk?(self.itemModel ?? WLTagItemModel())
        if let _ = self.itemModel?.tagNormalBgImage {} else {
            if sender.isSelected == false, let _ = self.itemModel?.tagNormalBgColor {
                self.backgroundColor = self.itemModel?.tagNormalBgColor
            }
        }
        
        if let _ = self.itemModel?.tagSelectedBgImage {} else {
            if sender.isSelected == true, let _ = self.itemModel?.tagSelectedBgColor {
                self.backgroundColor = self.itemModel?.tagSelectedBgColor
            }
        }
    }
    
    open var itemModel: WLTagItemModel? {
        willSet {
            if self.itemModel == newValue {
                return
            }
            self.configStype(newValue)
        }
    }
    
    
    private func configStype(_ itemModel: WLTagItemModel?) {
        self.titleLabel?.font = itemModel?.tagFont
        self.setTitle(itemModel?.tagText, for: .normal)
        self.setTitleColor(itemModel?.tagTextNormalColor, for: .normal)
        self.setTitleColor(itemModel?.tagTextSelectedColor, for: .selected)
        self.setImage(itemModel?.tagNormalImage, for: .normal)
        self.setImage(itemModel?.tagSelectedImage, for: .selected)
        self.layer.cornerRadius = itemModel?.tagCornerRadius ?? 0
        self.setBackgroundImage(itemModel?.tagNormalBgImage, for: .normal)
        self.backgroundColor = itemModel?.tagNormalBgColor
        self.setBackgroundImage(itemModel?.tagSelectedBgImage, for: .selected)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: itemModel?.tagImageLeftPadding ?? 0, bottom: 0, right: 0)
        self.removeTarget(self, action: #selector(itemClick), for: .touchUpInside)
        self.addTarget(self, action: #selector(itemClick), for: .touchUpInside)
        self.isSelected = itemModel?.tagIsSelected ?? false
        self.sizeToFit()
    }
    


}
