//
//  StockItem+CoreDataClass.swift
//  Stock Track
//
//  Created by Zhihao Cui on 27/05/2018.
//  Copyright © 2018 Zhihao Cui. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(StockItem)
public class StockItem: NSManagedObject {
    public func setPhoto(uiImage: UIImage) {
        let dataImage = UIImagePNGRepresentation(uiImage)
        self.photo = dataImage! as NSData
    }
    
    public func getPhoto() -> UIImage {
        return UIImage(data: self.photo! as Data)!
    }
}
