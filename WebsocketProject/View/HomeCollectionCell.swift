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
    
    var country: CollectionItemViewModel! {
        didSet {
            nameButton.setTitle(country.name, for: .normal)
            casesButton.setTitle(country.cases, for: .normal)
            deathButton.setTitle(country.deaths, for: .normal)
            nameButton.tintColor = adaptiveColor()
            contentView.superview?.backgroundColor = country.cellBgColor
        }
    }

    let nameButton: MDCButton     = MDCButton()
    let casesButton: MDCButton    = MDCButton()
    let deathButton: MDCButton    = MDCButton()

    let containerScheme           = MDCContainerScheme()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.layer.cornerRadius         = 8
        self.applyTheme(withScheme: containerScheme)
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.frame = CGRect(
            x: frame.minX,
            y: frame.minY,
            width: self.intrinsicContentSize.width,
            height: self.intrinsicContentSize.height)
        
        nameButton.applyOutlinedTheme(withScheme: containerScheme)
        nameButton.setTitleColor(.systemBlue, for: UIControl.State.normal)
        nameButton.isUserInteractionEnabled   = false
        nameButton.adjustsFontForContentSizeCategoryWhenScaledFontIsUnavailable = true
        nameButton.titleLabel?.font           = UIFont(name: "maximum", size: 3000.0)
        nameButton.contentHorizontalAlignment = .left
        nameButton.titleLabel?.numberOfLines  = 0
        nameButton.titleLabel?.lineBreakMode  = NSLineBreakMode.byWordWrapping
        
        casesButton.applyOutlinedTheme(withScheme: containerScheme)
        casesButton.setTitleColor(adaptiveColor(), for: UIControl.State.normal)
        casesButton.isUserInteractionEnabled   = false
        casesButton.titleLabel?.font           = containerScheme.typographyScheme.body2
        casesButton.contentHorizontalAlignment = .left
        casesButton.titleLabel?.numberOfLines  = 0
        casesButton.titleLabel?.lineBreakMode  = NSLineBreakMode.byWordWrapping
        
        
        deathButton.applyOutlinedTheme(withScheme: containerScheme)
        deathButton.setTitleColor(adaptiveColor(), for: UIControl.State.normal)
        deathButton.isUserInteractionEnabled   = false
        deathButton.titleLabel?.font           = containerScheme.typographyScheme.body2
        deathButton.contentHorizontalAlignment = .left
        deathButton.titleLabel?.numberOfLines  = 0
        deathButton.titleLabel?.lineBreakMode  = NSLineBreakMode.byWordWrapping

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if nameButton.superview == nil { addSubview(nameButton) }
        if casesButton.superview == nil { addSubview(casesButton) }
        if deathButton.superview == nil { addSubview(deathButton) }

        nameButton.sizeToFit()
        casesButton.sizeToFit()
        deathButton.sizeToFit()

        
        nameButton.frame = CGRect(
            x: 6,
            y: 6,
            width: frame.width-12,
            height: 48)
        
        casesButton.frame = CGRect(
            x: nameButton.frame.minX,
            y: nameButton.frame.maxY+6,
            width: (frame.width / 2)-9,
            height: 48)
        
        deathButton.frame = CGRect(
            x: casesButton.frame.maxX+6,
            y: nameButton.frame.maxY+6,
            width: (frame.width / 2)-9,
            height: 48)
    }
    
    static let identifier = "collectionItem"
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
