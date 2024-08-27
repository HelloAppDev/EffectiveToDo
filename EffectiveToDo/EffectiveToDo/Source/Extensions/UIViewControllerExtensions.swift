//
//  UIViewControllerExtensions.swift
//  EffectiveToDo
//
//  Created by Мария Изюменко on 27.08.2024.
//

import UIKit

extension UIViewController {
    func hideKeyBoardOnTap() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
