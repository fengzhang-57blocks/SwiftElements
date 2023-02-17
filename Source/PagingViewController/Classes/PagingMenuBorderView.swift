//
//  PagingMenuBorderView.swift
//  SwiftElements
//
//  Created by 57block on 2023/2/17.
//

import UIKit

open class PagingMenuBorderView: UICollectionReusableView {
	open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
		if let attrs = layoutAttributes as? PagingMenuBorderLayoutAttributes {
			backgroundColor = attrs.backgroundColor
		}
	}
}
