//
//  ChooseServiceController.swift
//  plowdr
//
//  Created by Wilson Balderrama on 11/16/17.
//  Copyright © 2017 plowdr. All rights reserved.
//

import UIKit

class ChooseJobController: UITableViewController {
  @IBOutlet weak var singleJobCell: UITableViewCell!
  @IBOutlet weak var monthlyJobCell: UITableViewCell!
  @IBOutlet weak var unlimitedJobCell: UITableViewCell!
  
  @IBOutlet weak var singleJobView: UIView!
  @IBOutlet weak var monthlyJobView: UIView!
  @IBOutlet weak var unlimitedJobView: UIView!
  
  var jobType: JobType!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    clearsSelectionOnViewWillAppear = true
    
    singleJobView.layer.borderWidth = 5
    singleJobView.layer.borderColor = UIColor.white.cgColor
    
    monthlyJobView.layer.borderWidth = 5
    monthlyJobView.layer.borderColor = UIColor.white.cgColor
    
    unlimitedJobView.layer.borderWidth = 5
    unlimitedJobView.layer.borderColor = UIColor.white.cgColor
    
    let gradientView = GradientView(frame: self.tableView.bounds)
    gradientView.startColor = UIColor(red: 30.0/255.0, green: 79.0/255.0, blue: 114.0/255.0, alpha: 1.0)
    gradientView.endColor = UIColor(red: 13.0/255.0, green: 39.0/255.0, blue: 62.0/255.0, alpha: 1.0)
    
    tableView.backgroundView = gradientView
  }
  
  func jobDescriptionAccepted() {
    print("job description accepted")
    if let row = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: row, animated: true)
      performSegue(withIdentifier: StoryboardSegues.ChooseJobToSetJobDetails, sender: nil)
    }
  }
}

extension ChooseJobController {
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == StoryboardSegues.ChooseJobToJobDescription {
      let vc = segue.destination as? JobDescriptionController
      vc?.jobDescriptionAccepted = jobDescriptionAccepted
      vc?.jobType = sender as? JobType
    } else if segue.identifier == StoryboardSegues.ChooseJobToSetJobDetails {
      let vc = segue.destination as? SetJobDetailsController
      vc?.jobType = jobType
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath)
    
    
    if cell === singleJobCell {
      jobType = .single
    } else if cell === monthlyJobCell {
      jobType = .monthly
    } else if cell === unlimitedJobCell {
      jobType = .unlimited
    }
    
    performSegue(withIdentifier: StoryboardSegues.ChooseJobToJobDescription, sender: jobType)
  }
  
}














































