//
//  AddEmployeeViewController.swift
//  TabBarAppTask
//
//  Created by Aryan on 28/03/23.
//

import UIKit
import CoreData
protocol copyData{
    func employeeAdded()
}

class AddEmployeeViewController: UIViewController {
  
    var selectedDepartment : Department?
    
    @IBOutlet weak var employeeTextField: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeTextField.placeholder = "Write Employee Name Here.."
    }
    
    var delegate:copyData?
    
    
    @IBAction func employeeAddBtn(_ sender: UIButton) {
        let text = employeeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.count > 0 {
            let newItem = Employee(context: context)
            newItem.eName = employeeTextField.text
            selectedDepartment?.addToDepartmentR(newItem)
            saveEmployeeData()
            delegate?.employeeAdded()
            navigationController?.popViewController(animated: true)
    
        }else{
            let alert = UIAlertController(title: "Alert", message: "Employee Name Can't be Empty", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    
    func saveEmployeeData(){
        do{
            try context.save()
        }catch{
           
        }
    }
  
}
