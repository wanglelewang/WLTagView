//
//  WLTagView.swift
//  WL
//
//  Created by 2345 on 2019/5/27.
//  Copyright © 2019 yoser. All rights reserved.
//  标签视图--代码  最左间距为0

//eg:
//      let view = WLTagView(40, true, 5, 5, 20, CGRectFromString("{{50,300},{200,30}}"))   多行折叠
//      let view1 = WLTagView(-1, false, 5, 5, 20, CGRectFromString("{{50,100},{200,30}}")) 单行不可滑动
//      let view2 = WLTagView(-1, true, 5, 5, 20, CGRectFromString("{{50,200},{200,30}}"))  单行可滑动

import UIKit

private let openBtnSize: CGSize = CGSize(width: 50, height: 15)

class WLTagView: UIView {
    
    ///初始化直接展开样式的 不存在折叠按钮
    @objc @discardableResult convenience init(sapceX: CGFloat = 3, spaceY: CGFloat = 3, itemH: CGFloat = 20, frame: CGRect = CGRect.zero) {
        self.init(frame: frame)
        self.sapceX = sapceX
        self.spaceY = spaceY
        self.itemH = itemH
        self.noOpenBtn = true
        self.openBtn.isSelected = true
        self.openBtn.isHidden = true
        self.configUI()
    }
    
    ///初始化带折叠按钮的 limitH 单行设置为-1 itemH多行采用 单行根据间距和高度计算
    @objc @discardableResult convenience init(limitH: CGFloat = -1, signleLineCanScoll: Bool = false, sapceX: CGFloat = 3, spaceY: CGFloat = 3, itemH: CGFloat = 20, frame: CGRect = CGRect.zero) {
        self.init(frame: frame)
        self.limitH = limitH
        self.signleLineCanScoll = signleLineCanScoll
        self.sapceX = sapceX
        self.spaceY = spaceY
        self.itemH = itemH
        self.configUI()
    }
    
    ///多行直接展开 没有折叠按钮存在
    private(set) var noOpenBtn = false
    private(set) var limitH: CGFloat = -1
    ///单行能否滚动
    private(set) var signleLineCanScoll = false
    private(set) var sapceX: CGFloat = 3
    private(set) var spaceY: CGFloat = 3
    ///多行使用 单行会根据高度和间距计算
    private(set) var itemH: CGFloat = 20
    ///用于记录多行总高 实现展开功能
    private var totalH: CGFloat = 0
    ///记录折叠隐藏的item
    private var hideItems:[WLTagItem] = []
    ///记录tagItem
    private var tagItems:[WLTagItem] = []
    ///设置标签
    @objc open var tags:[WLTagItemModel] = [] {
        didSet {
            self.updateTags()
        }
    }
    
    ///item点击回调
    @objc open var tagItemClickBlk: ((_ itemModel: WLTagItemModel,_ tagView: WLTagView,_ itemIndex: Int)->Void)?
    ///折叠或者展开 1展开 0 折叠
    @objc open var openOrCloseBlk: ((_ tagView: WLTagView,_ yn: Int)->Void)?
    
    private func configUI() {
        self.clipsToBounds = true
        self.addSubview(self.contentSV)
        self.addSubview(self.openBtn)
    }
    
    private func updateTags() {
        self.openBtn.isHidden = true
        //没有标签隐藏视图
        if self.tags.count < 1 {
            self.contentSV.isHidden = true
            return
        }
        self.contentSV.isHidden = false
        self.contentSV.subviews.forEach({$0.isHidden = true})
        self.tagItems.removeAll()
        for (index,tagItemModel) in self.tags.enumerated() {
            var item: WLTagItem?
            if let t = self.contentSV.viewWithTag(index+100) as? WLTagItem {//
                item = t
            }else {
                item = WLTagItem()
                self.contentSV.addSubview(item!)
            }
            item!.tag = (100 + index)
            item!.itemModel = tagItemModel
            item!.itemClickBlk = { [unowned self,weak item](itemModel) in
                if let strongItem = item {
                    self.tagItemClickBlk?(itemModel,self,strongItem.tag)
                }
            }
            item!.isSelected = tagItemModel.tagIsSelected ?? false
            item?.isHidden = false
            self.tagItems.append(item!)
        }
        
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var itemX: CGFloat = 0
        if self.limitH == -1 ,self.noOpenBtn == false {//单行
            self.contentSV.frame = self.bounds
            let itemh: CGFloat = (self.bounds.size.height - self.spaceY*2)
            //布局item
            for (item) in self.tagItems {
                item.frame = CGRect(x: itemX, y: self.spaceY, width: item.bounds.size.width, height: itemh)
                //下一个item的X
                itemX = (itemX + item.bounds.size.width + self.sapceX)
                //超过宽度的item隐藏
                if self.signleLineCanScoll == false, (self.bounds.size.width+self.sapceX) < itemX {
                    item.isHidden = true
                }
            }
            self.contentSV.contentSize = self.signleLineCanScoll ? CGSize(width: itemX, height: self.bounds.size.height):self.bounds.size
            
        }else {// noOpenBtn == false 可能有展开按钮 取决于标签能否放的下
            let viewW: CGFloat = self.bounds.size.width
            var itemY: CGFloat = self.spaceY
            self.hideItems.removeAll()
            //布局item
            for (item) in self.tagItems {
                //超过就换行
                if (itemX + item.bounds.size.width) > viewW {
                    itemX = 0
                    itemY = (itemY + self.itemH + self.spaceY)
                }
                item.frame = CGRect(x: itemX, y: itemY, width: item.bounds.size.width, height: self.itemH)
                //下一个item的X
                itemX = (itemX + item.bounds.size.width + self.sapceX)
                
                //最后一行 挡住展开按钮的item隐藏 其余的因为clipTobounds = true的特性 不用处理
                if self.noOpenBtn == false, (itemY + self.itemH + self.spaceY + self.itemH) >= self.limitH, (itemX + openBtnSize.width) >= viewW  {
                    item.isHidden =  !self.openBtn.isSelected
                    self.hideItems.append(item)
                    self.openBtn.isHidden = false
                }
            }
            //加上最后一行的高度和底部间距
            self.totalH = (itemY + self.itemH + self.spaceY)
            self.updateFrame()
        }
        
    }
    
    @objc private func openClick(sender: UIButton) {
        //选中就是展开 未选中就是折叠
        sender.isSelected = !sender.isSelected
        self.hideItems.forEach({$0.isHidden = !sender.isSelected})
        self.updateFrame()
        self.openOrCloseBlk?(self,sender.isSelected ?1:0)
    }
    
    //更新布局
    private func updateFrame() {
        var tFrame = self.frame
        tFrame.size.height = self.openBtn.isSelected ? max(self.totalH, self.limitH): min(self.totalH, self.limitH)
        self.frame = tFrame
        self.contentSV.frame = self.bounds
        self.openBtn.frame = CGRect(x: tFrame.size.width-openBtnSize.width, y: self.bounds.size.height-openBtnSize.height - self.spaceY, width: openBtnSize.width, height: openBtnSize.height)
    }
    
    ///get
    private let contentSV: UIScrollView = {
        let temp = UIScrollView()
        temp.showsVerticalScrollIndicator = false
        temp.showsHorizontalScrollIndicator = false
        return temp
    }()
    
    public let openBtn: UIButton = {
        let temp = UIButton(type: .custom)
        temp.setTitle("展开", for: .normal)
        temp.setTitle("收起", for: .selected)
        temp.setTitleColor(UIColor.gray, for: .normal)
        temp.adjustsImageWhenHighlighted = false
        temp.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        temp.addTarget(self, action: #selector(openClick), for: .touchUpInside)
        return temp
    }()
    
}

