//
//  MainViewViewModel.swift
//  CalculatorRecognition
//
//  Created by Louise on 4/25/22.
//  Copyright © 2022 Louise Nicolas Namoc. All rights reserved.
//

import Combine
import Foundation
import UIKit
import Vision

let pattern = "([0-9]+[\\+\\-\\*\\/]{1}[0-9])"
let symbols = "([\\+\\-\\*\\/]{1})"

enum Flavour {
  case appredcameraroll
  case appredbuiltincamera
  case appgreenfilesystem
  case appgreencameraroll
}

class MainViewViewModel: MainViewViewModelProtocol {
//  typealias Img = UIImage

//  var onSomeCallbackEvent: VoidResult?
//
  private var textWord: String = ""
  @Published var resultSolver: Int = 0
}

// MARK: - Methods

extension MainViewViewModel {
  func readImage(
    image: UIImage,
    onCompletion: @escaping DoubleResult<Bool, String?>
  ) {
    guard let cgImage = image.cgImage else { return }
    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

    let request = VNRecognizeTextRequest { [weak self] request, error in
      guard let self = self else { return }
      guard let observations = request.results as? [VNRecognizedTextObservation],
            error == nil else {
        onCompletion(false, nil)
        return
      }
      let text = observations.compactMap({
        $0.topCandidates(1).first?.string
      }).joined(separator: ", ")
      guard let arrayExpression = text.matches(for: pattern).first else { return }
      self.textWord = arrayExpression
      guard let operation = arrayExpression.matches(for: symbols).first else { return }
      let arguments = arrayExpression.components(separatedBy: operation)
      debugPrint(">> \(arguments)")

      if let value1 = arguments.first,
         let value2 = arguments.last,
         let intVal1 = Int(value1.trimmingCharacters(in: .whitespacesAndNewlines)),
         let intVal2 = Int(value2.trimmingCharacters(in: .whitespacesAndNewlines)) {
        self.resultSolver = self.expressionSolver(
          a: intVal1,
          b: intVal2,
          operatorSymbol: operation
        )
        onCompletion(true, nil)
      } else {
        onCompletion(false, nil)
      }
    }
    request.recognitionLevel = VNRequestTextRecognitionLevel.accurate

    try? handler.perform([request])
  }

  func expressionSolver<T: Numeric & BinaryInteger>(
    a: T,
    b: T,
    operatorSymbol: String
  ) -> T {
    var total: T = 0
    switch operatorSymbol {
    case "+":
      total = a + b
    case "-":
      total = a - b
    case "/":
      total = a / b
    case "*":
      total = a * b
    default:
      break
    }
    return total
  }
}

// MARK: - Getters

extension MainViewViewModel {
  var text: String { textWord }
  var result: Published<Int>.Publisher { $resultSolver }

  var themeColor: UIColor {
    switch ConfigProvider.appTheme {
    case "red":
      return UIColor.red
    default:
      return UIColor.green
    }
  }

  var flavour: Flavour {
    switch ConfigProvider.appFlavour {
    case "appredcameraroll":
      return .appgreencameraroll
    case "appgreenfilesystem":
      return .appgreenfilesystem
    case "appredbuiltincamera":
      return .appredbuiltincamera
    default:
      return .appgreencameraroll
    }
  }
}
