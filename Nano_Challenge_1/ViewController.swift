//
//  ViewController.swift
//  Nano_Challenge_1
//
//  Created by Wildan Budi on 27/04/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var capacity: UILabel!
    @IBOutlet weak var status: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var models = [LaundryItem]()
    public var datas = LaundryItem()
    var isEdit = false
    var progress = 0
    var limit = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAllItem()
        setProgress()
        if progress == 0 {
            status.text = "Empty"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(didTapAdd))
        } else if progress < limit || progress > 0 {
            status.text = "Available"
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(didTapAdd))
        } else if progress >= limit {
            status.text = "Full"
        } else {
            
        }
        title = "Laundry Basket"
        percentage.text = "\(Int(Double(progress)/Double(limit)*100))%"
        capacity.text = "\(progress)" + "/" + "\(limit)"
        print(Int(Double(progress)/Double(limit)))
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func doneLaundry(_ sender: Any) {
        let alert = UIAlertController(title: "Done Laundry", message: "Have you done your laundry and empty the list?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            self?.deleteAll()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            _ in
            alert.dismiss(animated: true)
        }))
        
        present(alert, animated: true)
    }

    @objc func didTapAdd() {
        self.performSegue(withIdentifier: "AddItem", sender: self)
    }
    
    func deleteAll() {
        for item in models {
            context.delete(item)
            do {
                try context.save()
                getAllItem()
            } catch {
                //error handling
            }
        }
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
    
    func setProgress() {
        for item in models {
            progress += Int(item.qty)
        }
    }
    
    func getAllItem() {
        do {
            models = try context.fetch(LaundryItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }
        catch{
            //error handling
        }
    }
    
    func deleteItem(item: LaundryItem) {
        context.delete(item)
        do {
            try context.save()
            getAllItem()
        } catch {
            //error handling
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return models.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            progressBar.setProgress(Float(Double(progress)/Double(limit)), animated: true)
            if Double(progress)/Double(limit) <= 0.5 {
                progressBar.tintColor = .green
            } else if Double(progress)/Double(limit) <= 0.8 {
                progressBar.tintColor = .yellow
            } else {
                progressBar.tintColor = .red
            }
            return cell
        } else {
            let model = models[indexPath.row]
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.text = model.name
            cell.detailTextLabel?.text = String(model.qty)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            self.datas = item
            self.isEdit = true
            self.performSegue(withIdentifier: "AddItem", sender: self)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            let alert = UIAlertController(title: "Delete Item", message: "Are you sure want to delete this item?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                self?.deleteItem(item: item)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                _ in
                alert.dismiss(animated: true)
            }))
            
            self?.present(alert, animated: true)
            
        }))
        
        present(sheet, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let data = segue.destination as? ItemViewController {
            data.newModels = datas
            data.isEdit = isEdit
        }
    }
}

