//
//  PagingTitleCell.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/10.
//

import UIKit

open class PagingTitleCell: PagingCell {
  public let titleLabel: UILabel = UILabel()
  
  public private(set) var options: PagingOptions?
  
  private lazy var horizontalConstaints: [NSLayoutConstraint] = {
    return NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[titleLabel]|",
      metrics: nil,
      views: [
        "titleLabel": titleLabel
      ]
    )
  }()
  
  private lazy var verticalConstaints: [NSLayoutConstraint] = {
    return NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[titleLabel]|",
      metrics: nil,
      views: [
        "titleLabel": titleLabel
      ]
    )
  }()
  
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
		configure()
  }
  
  open func configure() {
    titleLabel.textAlignment = .center
    contentView.addSubview(titleLabel)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addConstraints(horizontalConstaints)
    contentView.addConstraints(verticalConstaints)
  }
  
	open override func setItem(_ item: PagingItem, selected: Bool, options: PagingOptions) {
    self.options = options
    
		if let indexItem = item as? PagingIndexItem {
			titleLabel.text = "\(indexItem.title)"
		}
    
    if selected {
      titleLabel.font = options.selectedFont
      titleLabel.textColor = options.selectedTextColor
      backgroundColor = options.selectedBackgroundColor
    } else {
      titleLabel.font = options.font
      titleLabel.textColor = options.textColor
      backgroundColor = options.backgroundColor
    }
    
    horizontalConstaints.forEach {
      switch $0.firstAttribute {
      case .leading:
        $0.constant = options.itemLabelInsets.left
      case .trailing:
        $0.constant = options.itemLabelInsets.right
      default:
        break
      }
    }
	}
	
	open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
    
    guard let attr = layoutAttributes as? PagingCellLayoutAttributes,
          let options = options else {
      return
    }
    
    titleLabel.textColor = UIColor.interpolate(
      from: options.textColor,
      to: options.selectedTextColor,
      percentage: attr.progress
    )
    
    backgroundColor = UIColor.interpolate(
      from: options.backgroundColor,
      to: options.selectedBackgroundColor,
      percentage: attr.progress
    )
	}
}
