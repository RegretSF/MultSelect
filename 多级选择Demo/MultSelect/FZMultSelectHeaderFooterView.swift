//
//  FZMultSelectHeaderFooterView.swift
//  多级选择Demo
//
//  Created by pony on 2020/5/26.
//  Copyright © 2020 pony. All rights reserved.
//

import UIKit

protocol FZMultSelectHeaderFooterViewDelegate: NSObjectProtocol {
    
    /// 选中的 header/Footer
    /// - Parameters:
    ///   - headerFooterView: headerFooterView
    ///   - multModel: 模型
    func multSelectHeaderFooterView(_ headerFooterView: FZMultSelectHeaderFooterView, multModel: FZMultModel, section: Int, type: String)
}

class FZMultSelectHeaderFooterView: UITableViewHeaderFooterView {
    // MARK: - 控件属性
    /// 标题
    private lazy var titleLabel = UILabel()
    /// 展开收起的图像
    private lazy var arrowIconView = UIImageView(image: UIImage(named: "you-"))
    /// 分隔线
    private lazy var separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    /// 选中按钮
    private lazy var selectButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "weixuanzhong"), for: .normal)
        btn.setImage(UIImage(named: "xuanzhong"), for: .selected)
        btn.sizeToFit()
        return btn
    }()
    
    
    /// 代理
    weak var delegate: FZMultSelectHeaderFooterViewDelegate?
    ///
    var section: Int = 0
    
    // MARK: - 初始化
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - 监听方法
    @objc private func spread() {
        
        guard var multModel = multModel else {
            return
        }
        
        // 改变模型里的状态
        multModel.isSpread = !multModel.isSpread
        
        // 通知代理
        delegate?.multSelectHeaderFooterView(self, multModel: multModel, section: section, type: "spread")
    }
    
    @objc private func selected() {
        
        guard var multModel = multModel else {
            return
        }
        
        // 改变模型里的状态
        multModel.changeState(!multModel.isSelected, childId: multModel.id)
        
        // 通知代理
        delegate?.multSelectHeaderFooterView(self, multModel: multModel, section: section, type: "allSelect")
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
            
            // 改变箭头按钮的方向
            let transform: CGAffineTransform = multModel.isSpread ?
                CGAffineTransform(rotationAngle: CGFloat(.pi / 2 + 0.001)) :
                .identity
            self.arrowIconView.transform = transform
        }
    }
}

// MARK: - 设置 UI 界面
extension FZMultSelectHeaderFooterView {
    private func setupUI() {
        contentView.backgroundColor = .white
        
        // 添加监听方法
        // 选择按钮
        selectButton.addTarget(self, action: #selector(selected), for: .touchUpInside)
        // 图像
        arrowIconView.isUserInteractionEnabled = true
        arrowIconView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spread)))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spread)))
        
        // 添加控件
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowIconView)
        contentView.addSubview(selectButton)
        contentView.addSubview(separatorLine)
        
        // 2.取消 autoresizing
        for v in contentView.subviews {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 自动布局
        setupConstraints()
    }
    
    /// 自动布局
    private func setupConstraints() {
        let margin: CGFloat = 15
        
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
        
        // 展开收起的图像
        contentView.addConstraint(NSLayoutConstraint(item: arrowIconView,
                                                     attribute: .right,
                                                     relatedBy: .equal,
                                                     toItem: contentView,
                                                     attribute: .right,
                                                     multiplier: 1.0,
                                                     constant: -margin))
        contentView.addConstraint(NSLayoutConstraint(item: arrowIconView,
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
                                                     toItem: arrowIconView,
                                                     attribute: .left,
                                                     multiplier: 1.0,
                                                     constant: -margin - 5))
        contentView.addConstraint(NSLayoutConstraint(item: selectButton,
                                                     attribute: .centerY,
                                                     relatedBy: .equal,
                                                     toItem: contentView,
                                                     attribute: .centerY,
                                                     multiplier: 1.0,
                                                     constant: 0))
        
        // 分隔线
        contentView.addConstraint(NSLayoutConstraint(item: separatorLine,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: contentView,
                                                     attribute: .width,
                                                     multiplier: 1.0,
                                                     constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLine,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: contentView,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLine,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1.0,
                                                     constant: 1))
        
    }
}
