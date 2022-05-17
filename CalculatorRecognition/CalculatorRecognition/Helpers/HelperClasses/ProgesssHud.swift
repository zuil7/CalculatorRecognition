//
//  ProgesssHud.swift
//  CalculatorRecognition
//
//  Created by Louise Nicolas Namoc on 8/12/21.
//  Copyright © 2021 Louise Nicolas Namoc. All rights reserved.
//

import Foundation
import JGProgressHUD
import NVActivityIndicatorView

internal let indicatorSize = 60.0
internal let fontSize: CGFloat = 15.0

class ProgressHud {
  static let shared = ProgressHud()
  private var hud: JGProgressHUD!

  func showProgressHud(view: UIView) {
    hud = JGProgressHUD(style: .dark)
    hud.indicatorView = JGProgressHUDRingIndicatorView()
    hud.detailTextLabel.text = "0% Complete"
    hud.textLabel.text = "Downloading"
    hud.show(in: view)
  }


  func dismissProgressHud() {
    hud.textLabel.text = "Success"
    hud.detailTextLabel.text = "Download Completed"
    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
    hud.dismiss(animated: true)
  }

  func show(message: String = "", size: CGFloat = CGFloat(indicatorSize), color: UIColor = .white) {
    NVActivityIndicatorView.DEFAULT_TYPE = .ballClipRotateMultiple
    NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = R.color.darkShadow50()!
    NVActivityIndicatorView.DEFAULT_COLOR = color
    NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: size, height: size)
    NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 0 // in milliseconds
    NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 0 // in milliseconds
    NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE = message
    NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT = UIFont(name: "HelveticaNeue", size: 17.0)!
    NVActivityIndicatorView.DEFAULT_TEXT_COLOR = color

    let activityData = ActivityData()
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
  }

  func dismiss() {
    DispatchQueue.main.async {
      NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
  }
}
