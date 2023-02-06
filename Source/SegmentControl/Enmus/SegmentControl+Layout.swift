//
//  Layout.swift
//  Elements
//
//  Created by 57block on 2023/1/4.
//

import UIKit

public extension SegmentControl {
	struct Layout {
		public var itemSpacing: CGFloat
		public var contentInsets: UIEdgeInsets
		
		public var titleColor: UIColor
		public var selectedTitleColor: UIColor
    
		public var backgroundColor: UIColor
		public var selectedBackgroundColor: UIColor
		
		// Only works when style is indicator
		public var indicatorColor: UIColor
		public var indicatorSize: Layout.IndicatorSize
		
		// Only works when style is oval
		public var borderWidth: CGFloat
		public var borderColor: UIColor
		
		public var isRepeatTouchEnabled: Bool
    
		public init(
			itemSpacing: CGFloat = 8,
			contentInsets: UIEdgeInsets = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12),
			titleInsets: UIEdgeInsets = .zero,
      titleColor: UIColor = .systemBlue,
      selectedTitleColor: UIColor = .systemBlue,
      backgroundColor: UIColor = .white,
      selectedBackgroundColor: UIColor = .white,
      indicatorColor: UIColor = .systemBlue,
			indicatorSize: Layout.IndicatorSize = .init(width: .equal, height: 3),
      borderWidth: CGFloat = 2,
			borderColor: UIColor = .systemBlue,
			isRepeatTouchEnabled: Bool = false
		) {
			self.itemSpacing = itemSpacing
      self.contentInsets = contentInsets
      self.titleColor = titleColor
      self.selectedTitleColor = selectedTitleColor
      self.backgroundColor = backgroundColor
      self.selectedBackgroundColor = selectedBackgroundColor
      self.indicatorColor = indicatorColor
      self.indicatorSize = indicatorSize
      self.borderWidth = borderWidth
      self.borderColor = borderColor
			self.isRepeatTouchEnabled = isRepeatTouchEnabled
		}
	}
}

public extension SegmentControl.Layout {
	enum IndicatorSizeBehaviour {
		case equal
		case fixed(CGFloat)
	}
	
	struct IndicatorSize {
		public var width: IndicatorSizeBehaviour
		public var height: CGFloat
		
		public init(width: IndicatorSizeBehaviour, height: CGFloat) {
			self.width = width
			self.height = height
		}
	}
}