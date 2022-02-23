//
//  CustomCollectionViewCell.swift
//  Life Randomizer
//
//  Created by Александр Муратов on 22.02.2022.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 48, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "Result Background Color")
        contentView.addSubview(resultLabel)
        contentView.layer.cornerRadius = 18
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        resultLabel.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
    }
    
    public func configure(label: String) {
        resultLabel.text = label
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resultLabel.text = nil
    }
}
