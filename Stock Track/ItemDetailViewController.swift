//
//  DetailViewController.swift
//  Stock Track
//
//  Created by Zhihao Cui on 27/05/2018.
//  Copyright © 2018 Zhihao Cui. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var remainingSlider: UISlider!
    @IBOutlet weak var remainingLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var estimateLabel: UILabel!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        configureView()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveItem(_:)))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.timestamp!.description
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: StockItem? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    @objc
    func saveItem(_ sender: Any) {
        let context = self.fetchedResultsController.managedObjectContext
        let newItem = StockItem(context: context)
        
        // If appropriate, configure the new managed object.
        newItem.timestamp = Date() as NSDate
        
        newItem.name = "My item"
        newItem.setPhoto(uiImage: UIImage(named: "DefaultItemImage")!)
        newItem.amountLeft = 10
        newItem.totalPackageCount = 100
        newItem.consumptionDailyRate = 1
        newItem.isDeseret = true
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (tableView == self.historyTableView) {
            return fetchedResultsController.sections?.count ?? 0
        }
        else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.historyTableView) {
            let sectionInfo = fetchedResultsController.sections![section]
            return sectionInfo.numberOfObjects
        }
        else {
            if section == 0 {
                return 6
            }
            else {
                return 1 // Row History container view
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.historyTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StockHistoryCell", for: indexPath)
            let itemHistory = fetchedResultsController.object(at: indexPath)
            configureItemHistoryCell(cell, withItemHistory: itemHistory)
            return cell
        }
        else {
            let cell = super.tableView(tableView, cellForRowAt: indexPath) // Static cells
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if tableView == self.historyTableView {
            return true
        }
        else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == self.historyTableView {
            if editingStyle == .delete {
                let context = fetchedResultsController.managedObjectContext
                context.delete(fetchedResultsController.object(at: indexPath))
                
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func configureItemHistoryCell(_ cell: UITableViewCell, withItemHistory itemHistory: StockHistory) {
        cell.textLabel?.text = itemHistory.timestamp?.description
        cell.detailTextLabel?.text = itemHistory.amount.description
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<StockHistory> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<StockHistory> = StockHistory.fetchRequest()
        let predicate: NSPredicate = StockHistory.matchPredicate(withItem: self.detailItem!)
        
        fetchRequest.predicate = predicate
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<StockHistory>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        historyTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            historyTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            historyTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            historyTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            historyTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureItemHistoryCell(historyTableView.cellForRow(at: indexPath!)!, withItemHistory: anObject as! StockHistory)
        case .move:
            configureItemHistoryCell(historyTableView.cellForRow(at: indexPath!)!, withItemHistory: anObject as! StockHistory)
            historyTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        historyTableView.endUpdates()
    }

    // MARK: - Core Data Saving support
    
    func saveContext () {
        guard let context = self.managedObjectContext else {
            print("\(String(describing: type(of: self))) context is nil, returning")
            return
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

