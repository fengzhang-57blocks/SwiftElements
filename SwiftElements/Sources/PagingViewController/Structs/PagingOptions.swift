//
//  PagingOptions.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public struct PagingOptions {
  public var menuPosition: PagingMenuPosition
	
  public var pageScrollDirection: PageScrollDirection
	
  public var menuTransitionBehaviour: PagingMenuTransitionBehaviour
  
  public var itemSize: PagingItemSize
  public var itemSpacing: CGFloat
  public var estimatedItemWidth: CGFloat {
    switch itemSize {
    case let .fixed(width, _):
      return width
    case let .selfSizing(estimatedWidth, _):
      return estimatedWidth
    }
  }
	
	public var insets: UIEdgeInsets
	public var menuHeight: CGFloat {
		return itemSize.height + insets.top + insets.bottom
	}
	
	public var indicatorClass: PagingIndicatorView.Type
  public var indicatorOptions: PagingIndicatorOptions
  public var indicatorColor: UIColor
  
  public var borderClass: PagingBorderView.Type
  public var borderOptions: PagingBorderOptions
  public var borderColor: UIColor
	
	public init(
    menuPosition: PagingMenuPosition = .top,
		pageScrollDirection: PageScrollDirection = .horizontal,
		menuTransitionBehaviour: PagingMenuTransitionBehaviour = .scrollAlongside,
    itemSize: PagingItemSize = .fixed(width: 50, height: 50),
    itemSpacing: CGFloat = 0,
		insets: UIEdgeInsets = .zero,
		indicatorClass: PagingIndicatorView.Type = PagingIndicatorView.self,
    indicatorOptions: PagingIndicatorOptions = .visible(height: 3, spacing: .zero, insets: .zero, zIndex: Int.max),
		indicatorColor: UIColor = .systemBlue,
    
    borderClass: PagingBorderView.Type = PagingBorderView.self,
    borderOptions: PagingBorderOptions = .visible(height: 1, insets: .zero, zIndex: Int.max - 1),
    borderColor: UIColor = UIColor(white: 0.9, alpha: 1)
	) {
		self.menuPosition = menuPosition
		self.pageScrollDirection = pageScrollDirection
		
    self.menuTransitionBehaviour = menuTransitionBehaviour
    self.itemSpacing = itemSpacing
    self.itemSize = itemSize
		
		self.insets = insets
		
		self.indicatorClass = indicatorClass
    self.indicatorOptions = indicatorOptions
		self.indicatorColor = indicatorColor
    
    self.borderClass = borderClass
    self.borderOptions = borderOptions
    self.borderColor = borderColor
	}
}
