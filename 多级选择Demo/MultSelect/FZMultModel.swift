//
//  FZMultModel.swift
//  多级选择Demo
//
//  Created by pony on 2020/5/26.
//  Copyright © 2020 pony. All rights reserved.
//

import KakaJSON

struct FZMultModel: Convertible {
    // id
    var id: Int = 0
    // 父级 id
    var parentId: Int = 0
    /// 标题
    var title: String?
    /// 子列表数据
    var childer: [FZMultModel]?
    
    /// 用于保存当前子列表数组的数组，为了防止做表格的删除插入的操作的时候数据不会出错
    private lazy var currentChilder = [FZMultModel]()

    /// 当为父级的时候,是否为展开状态
    var isSpread: Bool = false {
        didSet {
            // 如果 currentChilder 为空，将子列表数据追加到 currentChilder
            // 先保存起来
            if let childer = childer {
                if currentChilder.count == 0 {
                    for var multModel in childer {
                        multModel.id = id + 1
                        multModel.parentId = id
                        currentChilder.append(multModel)
                    }
                }
            }
            
            childer = isSpread ? currentChilder : nil
        }
    }
    
    /// 是否是选中状态,当为父级时，选中了表示全选
    var isSelected: Bool = false
    
    /// 改变按钮的选中的状态
    /// - Parameters:
    ///   - isSelected: 是否选中
    ///   - currentId: 点击当前视图的 id
    mutating func changeState(_ isSelected: Bool, childId: Int) {
        
        self.isSelected = isSelected
        
        // 点击的是否是父级，如果是，只改变父级的选中状态，子级不变
        if childId > id {
            guard let childer = childer else {
                return
            }
            
            // 如果子级全部选中，当前的状态为选中状态
            var selectRows = 0
            for multModel in childer {
                if multModel.isSelected == true {
                    selectRows += 1
                }
            }
            
            // 删除当前子集，在展开收起的时候会重新赋值m，刷新 UI
            currentChilder.removeAll()

            if selectRows == childer.count {
                self.isSelected = true
            }
            
            return
        }
        
        // 遍历子列表数据，将子列表的数据设置为选中状态
        var idx = 0
        for var multModel in currentChilder {
            
            multModel.isSelected = isSelected
            
            multModel.isSpread = multModel.isSpread
            
            currentChilder[idx] = multModel
            
            idx += 1
        }
        
        // 设置这个属性的目的是更新当前子列表数组
        isSpread = isSpread
    }
}
