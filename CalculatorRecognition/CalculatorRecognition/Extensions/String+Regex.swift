//
//  String+Regex.swift
//  CalculatorRecognition
//
//  Created by Louise on 4/25/22.
//  Copyright © 2022 Louise Nicolas Namoc. All rights reserved.
//

import Foundation

extension String {
  func matches(for regex: String) -> [String] {
    do {
      let regex = try NSRegularExpression(pattern: regex)
      let results = regex.matches(
        in: self,
        range: NSRange(startIndex..., in: self)
      )
      return results.map {
        String(self[Range($0.range, in: self)!])
      }
    } catch let error {
      print("invalid regex: \(error.localizedDescription)")
      return []
    }
  }
}
