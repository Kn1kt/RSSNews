//
//  RSSPointCreator.swift
//  RSSNews
//
//  Created by Nikita Konashenko on 23.09.2020.
//

import UIKit

class RSSPointCreator: NSObject, RSSPointCreatorProtocol {
  
  var doneAction: UIAlertAction?
  var rssPointURL: URL?
  
  func getRSSPoint(for recievier: UIViewController, completionHandler: @escaping (RSSPointProtocol?) -> Void) {
    showTextEntryAlert(for: recievier, completionHandler: completionHandler)
  }
}

// MARK: Alert for Getting RSS Point
extension RSSPointCreator {
  
  private func showTextEntryAlert(for recievier: UIViewController, completionHandler: @escaping (RSSPointProtocol?) -> Void) {
    let title = "Adding New RSS Point"
    let message = "Just type URL for your RSS Point."
    let cancelButtonTitle = "Cancel"
    let otherButtonTitle = "Add"
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alertController.addTextField { texField in
      texField.delegate = self
    }
    
    let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { [weak self] _ in
      print("The \"Text Entry\" alert's cancel action occurred.")
      
      self?.doneAction = nil
      completionHandler(nil)
    }
    
    let doneAction = UIAlertAction(title: otherButtonTitle, style: .default) { [weak self] _ in
      print("The \"Text Entry\" alert's other action occurred.")
      
      self?.doneAction = nil
      if let url = self?.rssPointURL {
        let rssPoint = RSSPointCellData(url: url, isActive: false)
        completionHandler(rssPoint)
        
      } else {
        completionHandler(nil)
      }
    }
    
    doneAction.isEnabled = false
    self.doneAction = doneAction
    
    alertController.addAction(cancelAction)
    alertController.addAction(doneAction)
    
    recievier.present(alertController, animated: true, completion: nil)
  }
}

// MARK: - Text Field Delegate
extension RSSPointCreator: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    guard let text = textField.text,
          let textRange = Range(range, in: text) else { return true }
    
    let updatedText = text.replacingCharacters(in: textRange, with: string)
    
    if let link = updatedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
      let url = URL(string: link) {
      doneAction?.isEnabled = true
      rssPointURL = url
      
    } else {
      doneAction?.isEnabled = false
      rssPointURL = nil
    }
    
    return true
  }
}
