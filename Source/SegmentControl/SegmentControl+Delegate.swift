//
//  SegmentControl+Delegate.swift
//  Elements
//
//  Created by feng.zhang on 2023/1/5.
//

import UIKit

protocol SegmentControlDelegate {
  func segmentControl(_ segmentControl: SegmentControl, didSelect segment: Segment, at index: Int)
  func segmentControl(
    _ segmentControl: SegmentControl,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt index: Int) -> CGSize
  func minimumInteritemSpacingForSegmentControl(_ segmentControl: SegmentControl, layout collectionViewLayout: UICollectionViewLayout) -> CGFloat
}

extension SegmentControlDelegate {
  func segmentControl(_ segmentControl: SegmentControl, didSelect segment: Segment, at index: Int) {
    // do nothing
  }
  
  func segmentControl(
    _ segmentControl: SegmentControl,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt index: Int) -> CGSize {
      return .zero
    }
  
  func minimumInteritemSpacingForSegmentControl(_ segmentControl: SegmentControl, layout collectionViewLayout: UICollectionViewLayout) -> CGFloat {
    return .zero
  }
}