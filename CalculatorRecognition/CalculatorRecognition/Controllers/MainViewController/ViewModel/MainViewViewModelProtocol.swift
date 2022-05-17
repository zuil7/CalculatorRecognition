//
//  MainViewViewModelProtocol.swift
//  CalculatorRecognition
//
//  Created by Louise on 4/25/22.
//  Copyright © 2022 Louise Nicolas Namoc. All rights reserved.
//

import Foundation
import UIKit

protocol MainViewViewModelProtocol {
  var text: String { get }
  var themeColor: UIColor { get }
  var flavour: Flavour { get }

  var result: Published<Int>.Publisher { get }

  func readImage(
    image: UIImage,
    onCompletion: @escaping DoubleResult<Bool, String?>
  )
}
