//
//  ItemViewController.swift
//  Nano_Challenge_1
//
//  Created by Wildan Budi on 28/04/22.
//

import UIKit

class ItemViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [LaundryItem]()
    var newModels = LaundryItem()
    var isEdit: Bool?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var qty: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEdit == true {
            name.text = newModels.name
            qty.text = String(newModels.qty)
        } else {
           
        }
        // Do any additional setup after loading the view.x
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveData))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func saveData() {
        let item = newModels
        if isEdit == true {
            updateItem(item: item, newName: name.text!, newQty: Int(qty.text!)!)
        } else {
            self.createItem(name: name.text!, qty: Int(qty.text!)!)
        }
        _ = navigationController?.popViewController(animated: true)
        getAllItem()
    }
    
    func getAllItem() {
        do {
            models = try context.fetch(LaundryItem.fetchRequest())
        }
        catch{
            //error handling
        }
    }
    
    func createItem(name: String, qty: Int) {
        let newItem = LaundryItem(context: context)
        newItem.name = name
        newItem.qty = Int32(qty)
        
        do {
            try context.save()
            getAllItem()
        }
        catch {
            //error handling
        }
    }
    
    func updateItem(item: LaundryItem, newName: String, newQty: Int) {
        item.name = newName
        item.qty = Int32(newQty)
        do {
            try context.save()
            getAllItem()
        } catch {
            
        }
    }
}
