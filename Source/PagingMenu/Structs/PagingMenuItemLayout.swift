//
//  PagingMenuItemLayout.swift
//  SwiftElements
//
//  Created by feng.zhang on 2023/2/9.
//

import UIKit

public struct PagingMenuItemLayout {
  let frame: CGRect
  
  init(frame: CGRect) {
    self.frame = frame
  }
}

extension PagingMenuItemLayout {
  var x: CGFloat {
    return frame.origin.x
  }
  
  var width: CGFloat {
    return frame.size.width
  }
}
