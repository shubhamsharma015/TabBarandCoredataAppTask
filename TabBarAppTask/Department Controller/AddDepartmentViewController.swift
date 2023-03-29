//
//  AddDepartmentViewController.swift
//  TabBarAppTask
//
//  Created by Aryan on 27/03/23.
//

import UIKit
import CoreData

protocol addData{
    func textFieldValue()
    
}

class AddDepartmentViewController: UIViewController {
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var depAddTextField: UITextField!
    @IBOutlet weak var AddBtn: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate : addData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        depAddTextField.placeholder = "Write Department Name Here.."
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func depAddButton(_ sender: UIButton) {
        
        let text = depAddTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        var Departments = [Department]()
        
        
        let fetchRequest : NSFetchRequest<Department> = Department.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "depName == %@",text)
        
        do {
            Departments = try context.fetch(fetchRequest)
            
        }catch {
            print ("fetch task failed", error)
        }
        
        
        if let existingDepartment = Departments.first{
            
            let request = UIAlertController(title: "Alert", message: "\(text) Department exist", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            request.addAction(action)
            present(request, animated: true)
            depAddTextField.text = ""
            
        }else{
            
            
            if text.count > 0 {
                let newDepartment = Department(context: context)
                newDepartment.depName = text
                addDepartment()
                navigationController?.popViewController(animated: true)
            }else{
                let alert = UIAlertController(title: "Alert", message: "Department name can't be Empty", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                present(alert, animated: true)
                depAddTextField.text = ""
                
            }
        }
        
        
        
        //        if let departmentData = Departments.first {
        //            if text != departmentData.depName{
        //            debugPrint("hello")
        //            }else{
        //
        //                let request = UIAlertController(title: "Alert", message: "\(text) Department exist", preferredStyle: .alert)
        //                let action = UIAlertAction(title: "Ok", style: .default)
        //                request.addAction(action)
        //                present(request, animated: true)
        //                depAddTextField.text = ""
        //            }
        //        }
        //
        //        if text.count > 0 && Departments.first == nil{
        //
        //            let newItem = Department(context: context)
        //            newItem.depName = depAddTextField.text!
        //            addDepartment()
        //            navigationController?.popViewController(animated: true)
        //
        //        }else{
        //
        //            let request = UIAlertController(title: "Alert", message: "Department name can't be Empty", preferredStyle: .alert)
        //            let action = UIAlertAction(title: "OK", style: .default)
        //            request.addAction(action)
        //            present(request, animated: true)
        //            depAddTextField.text = ""
        //
        //        }
        
    }
    func addDepartment(){
        do{
            try context.save()
        }catch{
            print("getting error on save data")
        }
    }
}

