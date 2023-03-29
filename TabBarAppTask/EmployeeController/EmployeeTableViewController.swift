//
//  EmployeeTableViewController.swift
//  TabBarAppTask
//
//  Created by Aryan on 28/03/23.
//

import UIKit
import CoreData

class EmployeeTableViewController: UITableViewController {

    @IBOutlet weak var employeeTableView: UITableView!
    var employeeArray = [Employee]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedDepartment : Department?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmployees()
        title = selectedDepartment?.depName
        navigationController?.navigationBar.tintColor = .black

    }
    func getEmployees(){
        if let department = selectedDepartment{
            if let employees = department.departmentR as? Set<Employee>{
                employeeArray = Array(employees)
                employeeTableView.reloadData()
            }
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath)
        cell.textLabel?.text = employeeArray[indexPath.row].eName
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmployeeAdd"{
            let employeeAddVC = segue.destination as! AddEmployeeViewController
            employeeAddVC.delegate = self
            employeeAddVC.selectedDepartment = self.selectedDepartment
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        employeeTableView.reloadData()
        getEmployees()
    }

}

extension EmployeeTableViewController : copyData{
    func employeeAdded() {
       
        employeeTableView.reloadData()
    }
    
    
}

// for deleting data from core data and
extension EmployeeTableViewController{
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            tableView.beginUpdates()
            context.delete(employeeArray[indexPath.row])
            employeeArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            saveEmployeeData()
            tableView.endUpdates()
            
        }
    }
    
    func saveEmployeeData(){
        do{
            try context.save()
        }catch{
           
        }
}
}
