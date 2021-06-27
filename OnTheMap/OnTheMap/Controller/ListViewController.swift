//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Sushma Adiga on 27/06/21.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPin: UIBarButtonItem!
    @IBOutlet weak var refresh: UIBarButtonItem!
    @IBOutlet weak var logout: UIBarButtonItem!
    
    var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshAtStart()
    }
    
    func refreshAtStart() {
        OTMClient.getStudentLocation(completion: self.handleGetStudentLocation(success:error:))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        OTMClient.getStudentLocation(completion: self.handleGetStudentLocation(success:error:))
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        OTMClient.logout {
            DispatchQueue.main.async {
              self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func handleGetStudentLocation(success: Bool, error: Error?) {
        if (success) {
            self.tableView.reloadData()
        }
        else {
            showGetStudentLocationFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func showGetStudentLocationFailure(message: String) {
        let alertVC = UIAlertController(title: "Unable to download student information", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated:true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMModel.student.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
       let studentForRow = OTMModel.student[indexPath.row]
      
        cell.textLabel?.text = studentForRow.firstName + " " + studentForRow.lastName
        cell.detailTextLabel?.text = studentForRow.mediaURL
       cell.imageView?.image = UIImage(named: "pin")
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = OTMModel.student[indexPath.row]
          if student.mediaURL != "" {
            UIApplication.shared.open(URL(string: student.mediaURL)!)
       }
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let ipvc = segue.destination as! InformationPostingViewController
        ipvc.segueIdentifier = "unwindToList"
    }
    
    @IBAction func unwindToList(segue:UIStoryboardSegue) { }
        
    }

