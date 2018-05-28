//
//  DetailViewController.swift
//  Stock Track
//
//  Created by Zhihao Cui on 27/05/2018.
//  Copyright © 2018 Zhihao Cui. All rights reserved.
//

import UIKit

class ItemDetailViewController: UITableViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.timestamp!.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
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


}

