//
//  StringExtensions.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 25.08.2024.
//

import UIKit

extension String {
    func boundingRect(
        maxSize: CGSize,
        font: UIFont,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> CGRect {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        return (self as NSString).boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin],
            attributes: [.font: font, .paragraphStyle: paragraphStyle],
            context: nil
        )
    }
}
