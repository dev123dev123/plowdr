//
//  JobDetailChildController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 12/1/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol JobDetailDelegate {
  func taskChanged(task: Task)
}

class JobDetailChildController: UITableViewController {
  var currentTask: Task!
  var currentDriver: User?
  var delegate: JobDetailDelegate?
  
  @IBOutlet weak var titleJobLabel: UILabel!
  @IBOutlet weak var subtitleJobLabel: UILabel!
  @IBOutlet weak var driverInfoLabel: UILabel!
  
  @IBOutlet weak var vehicleInfoTextView: UITextView!
  
  @IBOutlet weak var callDriverLabel: UILabel!
  @IBOutlet weak var viewInvoiceLabel: UILabel!
  
  @IBOutlet weak var borderView: UIView!
  
  var formatter = DateFormatter()
  var listenerOnChangesOnTaskBy: Any?
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    listenerOnChangesOnTaskBy = Task.listenChangesOnTaskBy(
      taskId: currentTask.id
    ) { (error, task) in
      if let error = error {
        self.showErrorAlert(message: error.localizedDescription)
      } else {
        DispatchQueue.main.async {
          self.currentTask = task!
          self.delegate?.taskChanged(task: task!)
          self.setTaskOnUI(task: task!)
          self.trySettingDriverOnUI(task: task!)
        }
      }
    }
  }
  
  func trySettingDriverOnUI(task currentTask: Task) {
    if let driverId = currentTask.driverId {
      self.vehicleInfoTextView.text = "Loading.."
      SVProgressHUD.show()
      User.getUserFromDatabase(byUserId: driverId) { (user, error) in
        DispatchQueue.main.async {
          SVProgressHUD.popActivity()
          
          if let error = error {
            self.showErrorAlert(message: error.localizedDescription)
          } else {
            self.currentDriver = user
            self.callDriverLabel.isUserInteractionEnabled = true
            self.callDriverLabel.alpha = 1
            
            self.driverInfoLabel.text = "\(user!.firstName) \(user!.lastName)"
            self.vehicleInfoTextView.text = user!.vehicleInfo
          }
        }
      }
    }
  }
  
  func setTaskOnUI(task currentTask: Task) {
    var title = ""
    var subtitle = ""
    
    if currentTask.isNextSnowFall {
      let (t, _) = Strings.UI.TaskState.isNextSnowFall
      title = t
      subtitleJobLabel.isHidden = true
    } else {
      let (t, s) = Task.getTitlesBy(taskState: currentTask.state)
      title = t
      subtitle = s
      titleJobLabel.text = title
      subtitleJobLabel.text = subtitle
      subtitleJobLabel.isHidden = false
      
      switch currentTask.state {
      case .none:
        break
      case .assigned:
        fallthrough
      case .enroute:
        fallthrough
      case .plowing:
        fallthrough
      case .completed:
        viewInvoiceLabel.isUserInteractionEnabled = true
        viewInvoiceLabel.alpha = 1
      }
      
      if currentTask.state == .completed {
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: currentTask.dateSelected)
        
        formatter.dateFormat = "d"
        let day = formatter.string(from: currentTask.dateSelected)
        
        setLabelText(month: month, day: day)
        subtitleJobLabel.text = s
      } else if currentTask.state == .plowing {
        subtitleJobLabel.isHidden = true
      }
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    Task.unlistenChangesOnTaskBy(listener: listenerOnChangesOnTaskBy)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    
    setupViews()
    
    borderView.layer.borderWidth = 5
    borderView.layer.borderColor = UIColor.white.cgColor
    subtitleJobLabel.isHidden = false
    
    callDriverLabel.isUserInteractionEnabled = false
    callDriverLabel.alpha = 0.5
    
    viewInvoiceLabel.isUserInteractionEnabled = false
    viewInvoiceLabel.alpha = 0.5
    self.vehicleInfoTextView.text = "N/A"
    
    setTaskOnUI(task: currentTask)
    trySettingDriverOnUI(task: currentTask)

    borderView.layer.borderColor = UIColor.white.cgColor
    borderView.layer.borderWidth = 5
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.JobDetailChildToInvoiceDetail {
      let destinationVC = segue.destination as? InvoiceDetailController
      destinationVC?.currentTask = currentTask
    }
  }
  
  func setLabelText(
    month: String,
    day: String
    ) {
    let monthFont = UIFont(name: "HiraMaruProN-W4", size: 20)!
    let dayFont = UIFont(name: "HiraMaruProN-W4", size: 33)!
    
    let monthDictionary = [
      NSAttributedStringKey.font: monthFont
    ]
    let dayDictionary = [
      NSAttributedStringKey.font: dayFont
    ]
    
    let monthAttributedString = NSMutableAttributedString(string: month, attributes: monthDictionary)
    let dayAttributedString = NSMutableAttributedString(string: day, attributes: dayDictionary)
    
    monthAttributedString.append(dayAttributedString)
    
    titleJobLabel.attributedText = monthAttributedString
  }
  
  func setupViews() {
    callDriverLabel.layer.cornerRadius = 5.0
    callDriverLabel.layer.masksToBounds = true
    viewInvoiceLabel.layer.cornerRadius = 5.0
    viewInvoiceLabel.layer.masksToBounds = true
    
    let callDriverTapGesture = UITapGestureRecognizer(target: self, action: #selector(callDriverLabelTapped))
    callDriverTapGesture.numberOfTapsRequired = 1
    callDriverTapGesture.numberOfTouchesRequired = 1
    callDriverLabel.isUserInteractionEnabled = true
    callDriverLabel.addGestureRecognizer(callDriverTapGesture)
    
    let viewInvoiceTapGesture = UITapGestureRecognizer(target: self, action: #selector(viewInvoiceLabelTapped))
    viewInvoiceTapGesture.numberOfTapsRequired = 1
    viewInvoiceTapGesture.numberOfTouchesRequired = 1
    
    viewInvoiceLabel.isUserInteractionEnabled = false
    viewInvoiceLabel.addGestureRecognizer(viewInvoiceTapGesture)
    
  }
  
  @objc func callDriverLabelTapped() {
    makePhoneCall()
  }
  
  @objc func viewInvoiceLabelTapped() {
    performSegue(withIdentifier: StoryboardSegues.JobDetailChildToInvoiceDetail, sender: nil)
  }
  
  func makePhoneCall() {
    let number = currentDriver!.mobile
    let application = UIApplication.shared
    
    if let phoneCallURL = URL(string: "tel:\(number)") {
      if application.canOpenURL(phoneCallURL) {
        application.open(phoneCallURL, options: [:], completionHandler: { (finished) in
          print(finished)
        })
      }
    }
    
  }

}








































