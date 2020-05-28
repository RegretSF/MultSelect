//
//  FZMultSelectView.swift
//  多级选择Demo
//
//  Created by pony on 2020/5/26.
//  Copyright © 2020 pony. All rights reserved.
//

import UIKit

class FZMultSelectContainerView: UIView {
    /// 表格视图
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    /// 列表模型数组
    private lazy var multModelArr = [FZMultModel]()
    
    // MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - setter
    var multModels: [FZMultModel]? {
        didSet {
            
            guard let multModels = multModels else {
                return
            }
            
            for var multModel in multModels {
                // 先对这个属性赋一次值，在属性里，将当前的子列表数据先保存起来
                multModel.isSpread = false
                multModel.isSelected = false
                // 追加到数组
                multModelArr.append(multModel)
            }
            
            // 刷新表格
            tableView.reloadData()
        }
    }
}

// MARK: - 设置 UI 界面
extension FZMultSelectContainerView {
    private func setupUI() {
        // 设置属性
        backgroundColor = .white
        
        // 设置代理
        tableView.dataSource = self
        tableView.delegate = self
        
        // 注册 cell
        tableView.register(FZMultSelectCell.self, forCellReuseIdentifier: selectCellId)
        tableView.register(FZMultSelectHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: selectHeaderId)
        
        // 添加到视图
        self.addSubview(tableView)
        // 自动布局
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: tableView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .top,
                                              multiplier: 1.0,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: tableView,
                                              attribute: .left,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .left,
                                              multiplier: 1.0,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: tableView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: tableView,
                                              attribute: .right,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .right,
                                              multiplier: 1.0,
                                              constant: 0))
    }
}

// MARK: - FZMultSelectHeaderFooterViewDelegate
extension FZMultSelectContainerView: FZMultSelectHeaderFooterViewDelegate {
    func multSelectHeaderFooterView(_ headerFooterView: FZMultSelectHeaderFooterView,
                                    multModel: FZMultModel,
                                    section: Int,
                                    type: String) {
        // 替换数组里的模型
        multModelArr[section] = multModel
        
        // 刷新当前组
        tableView.reloadSections(IndexSet(integer: section), with: .none)
        
    }
}

// MARK: - FZMultSelectCellDelegate
extension FZMultSelectContainerView: FZMultSelectCellDelegate {
    func multSelectCell(_ cell: FZMultSelectCell, multModel: FZMultModel, indexPath: IndexPath) {
        var tmpModel = multModelArr[indexPath.section]
        
        // 替换数组里的模型
        tmpModel.childer?[indexPath.row] = multModel
        
        // 取消 section 中的选择状态
        tmpModel.changeState(false, childId: multModel.id)
        
        multModelArr[indexPath.section] = tmpModel
        
        // 刷新当前组
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
    }
}

// MARK: - 表格数据源和代理方法 ，
extension FZMultSelectContainerView: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return multModelArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return multModelArr[section].childer?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: selectCellId, for: indexPath) as! FZMultSelectCell
        cell.multModel = multModelArr[indexPath.section].childer?[indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    // MARK: - UITableViewDelegate
    // 设置头/尾视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = FZMultSelectHeaderFooterView()
        v.section = section
        v.delegate = self
        v.multModel = multModelArr[section]
        return v
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // 设置 height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
}

// MARK: - cell/HeaderFooter Identifier
private let selectCellId = "selectCellId"   // cell
private let selectHeaderId = "selectHeaderId"   // 头视图
