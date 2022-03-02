//
//  CollectionItem.swift
//  WebsocketProject
//
//  Created by 宇宣 Chen on 2022/2/25.
//
import UIKit
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialCards_Theming
import MaterialComponents.MaterialContainerScheme

class HomeCollectionCell: MDCCardCollectionCell {
    
    var country: CountryViewModel! {
        didSet {
            cardButton1.setTitle(country.name, for: .normal)
            contentView.superview?.backgroundColor = country.color
        }
    }

    let cardButton1: MDCButton    = MDCButton()
    let containerScheme           = MDCContainerScheme()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCard() {
        
        
        cardButton1.applyOutlinedTheme(withScheme: containerScheme)
        cardButton1.setTitleColor(.systemIndigo, for: UIControl.State.normal)
        cardButton1.titleLabel?.font = containerScheme.typographyScheme.body2
        cardButton1.contentHorizontalAlignment = .left
        cardButton1.titleLabel?.numberOfLines = 0
        cardButton1.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentView.layer.cornerRadius = 8
        self.applyTheme(withScheme: containerScheme)
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.frame = CGRect(
            x: frame.minX,
            y: frame.minY,
            width: self.intrinsicContentSize.width,
            height: self.intrinsicContentSize.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if cardButton1.superview == nil { addSubview(cardButton1) }
        
        cardButton1.sizeToFit()
        
        cardButton1.frame = CGRect(
            x: 6,
            y: 6,
            width: frame.width-12,
            height: 48)
    }
    
    static let identifier = "collectionItem"
}
