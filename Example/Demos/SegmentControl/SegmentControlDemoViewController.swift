//
//  SegmentControlDemoViewController.swift
//  Elements
//
//  Created by 57block on 2023/1/6.
//

import UIKit

class SegmentControlDemoViewController: BaseViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
		
		let s1Segments = makeSegments(["C", "Objective-C", "Swift", "Go"])
		let s1 = makeSegmentControl(s1Segments, style: .indicator, alignment: .centered)
		s1.bounds.size = CGSize(width: view.bounds.width, height: 50)
		navigationItem.titleView = s1
		s1.delegate = self
		s1.reloadData()
		

		let s2Segments = makeSegments(["C", "Objective-C", "Swift", "Go"])
		let s2 = makeSegmentControl(s2Segments, style: .indicator, alignment: .equalization)
		s2.bounds.size = CGSize(width: view.bounds.width, height: 50)
		s2.delegate = self
		view.addSubview(s2)
		s2.translatesAutoresizingMaskIntoConstraints = false
		s2.reloadData()

		NSLayoutConstraint.activate([
			s2.heightAnchor.constraint(equalToConstant: 50),
			s2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			s2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			s2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
		])

		let s3Segments = makeSegments(["C", "Objective-C", "Swift", "Go", "Python", "Javascript", "HTML", "CSS", "ES6"])
		let s3 = makeSegmentControl(s3Segments, style: .oval, alignment: .tiled)
		s3.bounds.size = CGSize(width: view.bounds.width, height: 50)
		s3.delegate = self
		view.addSubview(s3)
		s3.translatesAutoresizingMaskIntoConstraints = false
		s3.reloadData()

		NSLayoutConstraint.activate([
			s3.heightAnchor.constraint(equalToConstant: 50),
			s3.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			s3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			s3.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100)
		])
	}
	
	func makeSegments(_ titles: [String]) -> [Segment] {
		return titles.enumerated().map { index, title in
			Segment(
				title: NSAttributedString(
					string: title,
					attributes: [
						.font: UIFont.systemFont(ofSize: 15, weight: .medium),
					]
				),
				isSelected: index == 0)
		}
	}

	func makeSegmentControl(
		_ segments: [Segment],
		style: SegmentControl.Style,
		alignment: SegmentControl.Alignment) -> SegmentControl {
			let s = SegmentControl(segments: segments)
			s.style = style
			s.alignment = alignment

			var layout = SegmentControl.Layout()
			if style == .indicator {
				layout.itemSpacing = 0
        layout.indicatorWidth = .fixed(20)
			} else {
				layout.selectedTitleColor = .white
				layout.selectedBackgroundColor = .systemBlue
			}
			s.layout = layout

			return s
	}
}

extension SegmentControlDemoViewController: SegmentControlDelegate {
	func segmentControl(_ segmentControl: SegmentControl, didSelect segment: Segment, at index: Int) {
		print(segment.title.string)
	}
}
