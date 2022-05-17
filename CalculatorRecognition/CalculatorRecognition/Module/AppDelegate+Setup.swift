//
//  AppDelegate+Setup.swift
//  CalculatorRecognition
//
//  Created by Louise on 2/7/22.
//  Copyright © 2022 Louise Nicolas Namoc. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

extension AppDelegate {
  func setup() {
    IQKeyboardManager.shared.enable = true
    IQKeyboardManager.shared.shouldResignOnTouchOutside = true
  }
}
