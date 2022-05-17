//
//  ImagePicker.swift
//  CalculatorRecognition
//
//  Created by Louise on 4/25/22.
//  Copyright © 2022 Louise Nicolas Namoc. All rights reserved.
//

import Foundation
import MobileCoreServices
import Photos
import UIKit

enum AccessType {
  case camera
  case library
}

protocol ImagePickerPresenter {
  var imagePicker: UIImagePickerController { get set }
}

extension ImagePickerPresenter where Self: UIViewController {
  func presentPickerOptionsSheet(_ type: AccessType? = nil, includeVideosIfPossible: Bool = false) {
    let isCameraSupported = UIImagePickerController.isSourceTypeAvailable(.camera)
    if isCameraSupported {
      let sheet = imagePickerActionsheet(
        type: type,
        includeVideosIfPossible,
        isCameraSupported: isCameraSupported
      )
      present(sheet, animated: true, completion: nil)
    } else {
      presentPhotoLibrary(includeVideosIfPossible)
    }
  }

  func presentPhotoLibrary(_ includeVideosIfPossible: Bool = false) {
    let status = PHPhotoLibrary.authorizationStatus()
    guard status != .authorized else {
      if status == .authorized {
        launchedPhotoLibrary(includeVideosIfPossible)
      }
      return
    }
    PHPhotoLibrary.requestAuthorization { [weak self] authStatus in
      DispatchQueue.main.async {
        guard let s = self else { return }
        if authStatus == .denied {
          s.presentAlertWithTitle(title: S.errorText(), message: S.permissionDeniedText())

        } else if authStatus == .authorized {
          s.configurePickerForPhotoLibrary()
          s.presentImagePicker()
        }
      }
    }
  }

  func presentPhotoCaptureScreen() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      configurePickerForPhotoCapture()
      presentImagePicker()
    } else {
      debugPrint("Warning: Device doesn't have camera.")
    }
  }

  func presentVideoCaptureScreen() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      configurePickerForVideoCapture()
      presentImagePicker()
    } else {
      debugPrint("Warning: Device doesn't have camera.")
    }
  }

  func presentImagePicker() {
    if #available(iOS 13.0, *) {
      imagePicker.isModalInPresentation = true
      imagePicker.modalPresentationStyle = .fullScreen
    }
    present(imagePicker, animated: true, completion: {
      self.imagePicker.navigationBar.topItem?.rightBarButtonItem?.tintColor = .black
    })
  }

  private func imagePickerActionsheet(
    type: AccessType? = nil,
    _ includeVideosIfPossible: Bool,
    isCameraSupported: Bool
  ) -> UIAlertController {
    let style: UIAlertController.Style = UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
    let menu = UIAlertController(title: nil, message: nil, preferredStyle: style)

    menu.addAction(UIAlertAction(title: S.cancel(), style: .cancel, handler: nil))

    switch type {
    case .camera:
      if isCameraSupported {
        menu.addAction(
          UIAlertAction(title: S.imagePickerTakephoto(), style: .default) { (_) -> Void in
            self.configurePickerForPhotoCapture()
            self.presentImagePicker()
          })
      }
    case .library:
      menu.addAction(
        UIAlertAction(title: S.imagePickerChooselibrary(), style: .default) { (_) -> Void in
          self.configurePickerForPhotoLibrary(includeVideosIfPossible)
        })
    default:
      if isCameraSupported {
        menu.addAction(
          UIAlertAction(title: S.imagePickerTakephoto(), style: .default) { (_) -> Void in
            self.configurePickerForPhotoCapture()
            self.presentImagePicker()
          })
      }

      menu.addAction(
        UIAlertAction(title: S.imagePickerChooselibrary(), style: .default) { (_) -> Void in
          self.configurePickerForPhotoLibrary(includeVideosIfPossible)
        })
    }

    menu.view.tintColor = .darkGray
    return menu
  }

  private func configurePickerForVideoCapture() {
    imagePicker.sourceType = .camera
    imagePicker.cameraDevice = .rear
    imagePicker.mediaTypes = [kUTTypeMovie as String]
    imagePicker.cameraCaptureMode = .video
    imagePicker.allowsEditing = true
    imagePicker.videoQuality = .typeHigh
  }

  private func configurePickerForPhotoCapture() {
    imagePicker.sourceType = .camera
    imagePicker.cameraDevice = .rear
    imagePicker.allowsEditing = true
  }

  private func configurePickerForPhotoLibrary(_ includeVideosIfPossible: Bool = false) {
    let status = PHPhotoLibrary.authorizationStatus()
    print(status)
    guard status != .authorized else {
      if status == .authorized {
        launchedPhotoLibrary(includeVideosIfPossible)
      }
      return
    }
    PHPhotoLibrary.requestAuthorization { [weak self] authStatus in
      guard let s = self else { return }
      DispatchQueue.main.async {
        if authStatus == .denied {
          s.presentAlertWithTitle(title: S.errorText(), message: S.permissionDeniedText())
        } else if authStatus == .authorized {
          s.launchedPhotoLibrary(includeVideosIfPossible)
        }
      }
    }
  }

  private func launchedPhotoLibrary(_ includeVideosIfPossible: Bool) {
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
      imagePicker.sourceType = .photoLibrary
      imagePicker.allowsEditing = true
      if includeVideosIfPossible {
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePicker.videoQuality = .typeMedium
      } else {
        imagePicker.mediaTypes = [kUTTypeImage as String]
        presentImagePicker()
      }
    }
  }

  private func presentAlertWithTitle(
    title: String,
    message: String
  ) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: S.ok(), style: .default) { _ in }

    alertController.addAction(okAction)
    alertController.view.tintColor = .black

    present(alertController, animated: true, completion: nil)
  }
}
