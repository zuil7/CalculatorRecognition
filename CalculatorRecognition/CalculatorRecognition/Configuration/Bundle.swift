//
//  Bundle.swift
//  CalculatorRecognition
//
//  Created by Louise on 5/10/22.
//  Copyright © 2022 Louise Nicolas Namoc. All rights reserved.
//

import Foundation

extension Bundle {
  var bundleID: String {
    return infoDictionary?["CFBundleIdentifier"] as? String ?? ""
  }

  var appName: String {
    return infoDictionary?["CFBundleName"] as? String ?? ""
  }
}
