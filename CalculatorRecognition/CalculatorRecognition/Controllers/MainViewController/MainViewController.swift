//
//  MainViewController.swift
//  CalculatorRecognition
//
//  Created by Louise Nicolas Namoc on 8/12/21.
//  Copyright © 2021 Louise Nicolas Namoc. All rights reserved.
//

import Combine
import UIKit
import UniformTypeIdentifiers

class MainViewController: ViewController {
  var viewModel: MainViewViewModelProtocol = MainViewViewModel()

  var imagePicker = UIImagePickerController()
  private var cancellables: Set<AnyCancellable> = []
  @IBOutlet private(set) var expressionTitleLabel: UILabel!
  @IBOutlet private(set) var resultTitleLabel: UILabel!

  @IBOutlet private(set) var expressionLabel: UILabel!
  @IBOutlet private(set) var resultLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
}

private extension MainViewController {
  func setup() {
    setupNavigationBar()
    setupRightBarItem()
    setupImagePicker()
    bind()
  }

  func bind() {
    viewModel.result.sink { [weak self] result in
      guard let self = self else { return }
      self.resultLabel.text = result.description
    }.store(in: &cancellables)
  }

  func setupNavigationBar() {
    navigationItem.title = "Calculator Recognizer"

    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = viewModel.themeColor
    appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
  }

  func setupRightBarItem() {
    let rightButton = UIBarButtonItem(
      title: "Upload",
      style: .plain,
      target: self,
      action: #selector(cameraButtonTapped(_:))
    )

    rightButton.tintColor = .black
    navigationItem.rightBarButtonItem = rightButton
  }

  func setupImagePicker() {
    imagePicker = UIImagePickerController()
    imagePicker.delegate = self
  }
}

private extension MainViewController {
  @objc
  func cameraButtonTapped(_ sender: AnyObject) {
    switch viewModel.flavour {
    case .appredcameraroll:
      presentPickerOptionsSheet(.library)
    case .appgreenfilesystem:
      openFileSystem()
    case .appredbuiltincamera:
      presentPickerOptionsSheet(.camera)
    case .appgreencameraroll:
      presentPickerOptionsSheet(.library)
    }
  }
}

private extension MainViewController {
  func populateValues() {
    resultTitleLabel.text = S.resultTitle()
  }

  func openFileSystem() {
//    let supportedTypes: [UTType] = [UTType.image]

    let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.image", "public.jpeg", "public.png"], in: .import)
    documentPicker.delegate = self
    documentPicker.allowsMultipleSelection = false
//    documentPicker.modalPresentationStyle = .formSheet
    present(documentPicker, animated: true)
//    let vc = R.storyboard.main.documentBrowserViewController()!
//    vc.modalPresentationStyle = .fullScreen
//    present(vc, animated: true, completion: nil)
  }
}

// Handlers
private extension MainViewController {
  func onHandleTextRecognition() -> DoubleResult<Bool, String?> {
    return { [weak self] status, _ in
      guard let self = self else { return }
      self.dismissHud()
      self.expressionLabel.text = self.viewModel.text
      if status {
        self.populateValues()
      } else {
        self.expressionTitleLabel.text = S.textDetectedTitle()
        self.resultTitleLabel.text = S.noresultTitle()
      }
    }
  }
}

extension MainViewController: ImagePickerPresenter, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
    viewModel.readImage(
      image: image,
      onCompletion: onHandleTextRecognition()
    )
    dismiss(animated: true)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
}

extension MainViewController: UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let url = urls.first else {
      return
    }
    defer {
      DispatchQueue.main.async {
        url.stopAccessingSecurityScopedResource()
      }
    }

    guard let image = UIImage(contentsOfFile: url.path) else { return }

    controller.dismiss(animated: false, completion: {
      self.showHud(message: "Analyzing Image")
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
        self.viewModel.readImage(
          image: image,
          onCompletion: self.onHandleTextRecognition()
        )
      }
    })
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    controller.dismiss(animated: true)
  }
}
