//
//  ConfigProvider.swift
//  CalculatorRecognition
//
//  Created by Louise on 5/10/22.
//  Copyright © 2022 Louise Nicolas Namoc. All rights reserved.
//

import Foundation

enum ConfigKey: String {
  case appTheme = "AppTheme"
  case appFlavour = "AppFlavour"
}

private func bundleOption(_ key: String) -> Any? {
  return Bundle.main.object(forInfoDictionaryKey: key)
}

private func stringBundleOption(key: ConfigKey) -> String? {
  return bundleOption(key.rawValue) as? String
}

struct ConfigProvider {
  static let appTheme: String = {
    stringBundleOption(key: .appTheme) ?? ""
  }()

  static let appFlavour: String = {
    stringBundleOption(key: .appFlavour) ?? ""
  }()
}
