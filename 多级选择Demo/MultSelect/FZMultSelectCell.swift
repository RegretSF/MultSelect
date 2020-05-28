//
//  FZMultSelectCell.swift
//  多级选择Demo
//
//  Created by pony on 2020/5/26.
//  Copyright © 2020 pony. All rights reserved.
//

import UIKit

protocol FZMultSelectCellDelegate: NSObjectProtocol {
    /// 点击 cell 选中按钮
    /// - Parameters:
    ///   - cell: FZMultSelectCell
    ///   - multModel: multModel
    ///   - indexPath: indexPath
    func multSelectCell(_ cell: FZMultSelectCell, multModel: FZMultModel, indexPath: IndexPath)
}

class FZMultSelectCell: UITableViewCell {
    // MARK: - 控件属性
    private lazy var titleLabel = UILabel()
    /// 选中按钮
    private lazy var selectButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "weixuanzhong"), for: .normal)
        btn.setImage(UIImage(named: "xuanzhong"), for: .selected)
        btn.sizeToFit()
        return btn
    }()
    
    /// 索引
    var indexPath: IndexPath?
    /// 代理
    weak var delegate: FZMultSelectCellDelegate?
    
    // MARK: - 初始化
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - 监听方法
    @objc private func selected() {
        
        guard var multModel = multModel else {
            return
        }
        
        // 改变模型里的状态
        multModel.isSelected = !multModel.isSelected
        
        // 通知代理
        delegate?.multSelectCell(self, multModel: multModel, indexPath: indexPath ?? IndexPath())
    }
    
    // MARK: - setter
    var multModel: FZMultModel? {
        didSet{
            // 守护
            guard let multModel = multModel else {
                return
            }
            
            // 设置 title
            titleLabel.text = multModel.title
            
            // 设置按钮的选中
            selectButton.isSelected = multModel.isSelected
        }
    }
}

// MARK: - 设置 UI 界面
extension FZMultSelectCell {
    private func setupUI() {
        // 添加监听方法
        // 选择按钮
        selectButton.addTarget(self, action: #selector(selected), for: .touchUpInside)
        
        // 添加控件
        contentView.addSubview(titleLabel)
        contentView.addSubview(selectButton)
        
        // 自动布局
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 2.取消 autoresizing
        for v in contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 自动布局
        setupConstraints()
    }
    
    /// 自动布局
    private func setupConstraints() {
        let margin: CGFloat = 30
        
        // 标题
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel,
                                                     attribute: .left,
                                                     relatedBy: .equal,
                                                     toItem: contentView,
                                                     attribute: .left,
                                                     multiplier: 1.0,
                                                     constant: margin))
        contentView.addConstraint(NSLayoutConstraint(item: titleLabel,
                                                     attribute: .centerY,
                                                     relatedBy: .equal,
                                                     toItem: contentView,
                                                     attribute: .centerY,
                                                     multiplier: 1.0,
                                                     constant: 0))
        
        // 选中按钮
        contentView.addConstraint(NSLayoutConstraint(item: selectButton,
                                                     attribute: .right,
                                                     relatedBy: .equal,
                                                     toItem: contentView,
                                                     attribute: .right,
                                                     multiplier: 1.0,
                                                     constant: -margin))
        contentView.addConstraint(NSLayoutConstraint(item: selectButton,
                                                     attribute: .centerY,
                                                     relatedBy: .equal,
                                                     toItem: contentView,
                                                     attribute: .centerY,
                                                     multiplier: 1.0,
                                                     constant: 0))
    }
}
