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
    let cardButton2: MDCButton    = MDCButton()
    let containerScheme           = MDCContainerScheme()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCard() {
        cardButton1.applyTextTheme(withScheme: containerScheme)
        cardButton2.applyTextTheme(withScheme: containerScheme)
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
        if cardButton2.superview == nil { addSubview(cardButton2) }
        cardButton1.sizeToFit()
        cardButton2.sizeToFit()
        cardButton1.frame = CGRect(
            x: 3,
            y: 3,
            width: frame.width,
            height: cardButton1.frame.height)
        cardButton2.frame = CGRect(
            x: 8,
            y: cardButton1.frame.maxY + 8,
            width: cardButton2.frame.width,
            height: cardButton2.frame.height)
    }
    
    static let identifier = "collectionItem"
}
