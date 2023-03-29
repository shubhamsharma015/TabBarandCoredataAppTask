//
//  DepartmentCatagaryViewController.swift
//  TabBarAppTask
//
//  Created by Aryan on 27/03/23.
//

import UIKit
import CoreData


class DepartmentCatagaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var departmentTableView: UITableView!
    
    var departmentArray = [Department]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDepartment()
        departmentTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departmentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = departmentTableView.dequeueReusableCell(withIdentifier: "DepartmentCell", for: indexPath) as! DepartmentTableViewCell
        
        cell.DepartmentLabel.text = departmentArray[indexPath.row].depName
        
        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        departmentTableView.reloadData()
        textFieldValue()
    }
    
    // --------------------> for removing data <--------------
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        context.delete(departmentArray[indexPath.row])
    //        departmentArray.remove(at: indexPath.row)
    //        addDepartment()
    //        tableView.deselectRow(at: indexPath, animated: true)
    //    }
    //-------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CatagaryToEmploye", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddDep"{
            let secondVC = segue.destination as! AddDepartmentViewController
            secondVC.delegate = self
        }else if segue.identifier == "CatagaryToEmploye"{
            let employeVC = segue.destination as! EmployeeTableViewController
            if let indexPath = departmentTableView.indexPathForSelectedRow{
                employeVC.selectedDepartment = departmentArray[indexPath.row]
            }
        }
    }
    
    
    
// ----------------core data related functions ------------
    
    
    
    func loadDepartment(){
        let request : NSFetchRequest<Department> = Department.fetchRequest()
        do{
            departmentArray =  try context.fetch(request)
        }catch{
            print(error)
            }
        }
    }

extension DepartmentCatagaryViewController: addData{
    func textFieldValue() {
        loadDepartment()
        departmentTableView.reloadData()
        }
    }

//     -------------- Extension for delete data from table and core data---------------

extension DepartmentCatagaryViewController{
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()
            context.delete(departmentArray[indexPath.row])
            departmentArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            addDepartment()
            tableView.endUpdates()
            
        }
    }
    
    func addDepartment(){
        do{
            try context.save()
        }catch{
            print("getting error on save data")
        }
    }
    
}
