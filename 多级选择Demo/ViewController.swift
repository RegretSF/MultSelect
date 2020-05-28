//
//  ViewController.swift
//  多级选择Demo
//
//  Created by pony on 2020/5/26.
//  Copyright © 2020 pony. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private lazy var multSelectView = FZMultSelectContainerView(frame: view.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(multSelectView)
        loadData()
    }
    
    // MARK: - 加载数据
    private func loadData() {
        let result = [["title": "一级一项","id": "0", "childer": [["title": "二级一项","id": "11"],
                                                                 ["title": "二级二项","id": "12"],
                                                                 ["title": "二级三项","id": "13"]]],
                      ["title": "一级二项","id": "1", "childer": [["title": "二级一项","id": "21"],
                                                                 ["title": "二级二项","id": "22"],
                                                                 ["title": "二级三项","id": "23"]]],
                      ["title": "一级三项","id": "2", "childer": [["title": "二级一项"],
                                                                 ["title": "二级二项"],
                                                                 ["title": "二级三项"]]],
                      ["title": "一级四项","id": "3", "childer": [["title": "二级一项"],
                                                                 ["title": "二级二项"],
                                                                 ["title": "二级三项"]]],
                      ["title": "一级五项","id": "4", "childer": [["title": "二级一项"],
                                                                 ["title": "二级二项"],
                                                                 ["title": "二级三项"]]]]
        
        let multModels = result.kj.modelArray(type: FZMultModel.self) as? [FZMultModel]
        
        multSelectView.multModels = multModels

    }

}

