//
//  UIEdgeInsetsExtensions.swift
//  Elements
//
//  Created by feng.zhang on 2023/1/4.
//

import UIKit

extension UIEdgeInsets {
	var horizontal: CGFloat {
		return self.left + self.right
	}
	
  init(horizontal: CGFloat) {
    self.init(top: 0, left: horizontal, bottom: 0, right: horizontal)
  }
}