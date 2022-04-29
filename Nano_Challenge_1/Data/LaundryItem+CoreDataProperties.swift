//
//  LaundryItem+CoreDataProperties.swift
//  Nano_Challenge_1
//
//  Created by Wildan Budi on 27/04/22.
//
//

import Foundation
import CoreData


extension LaundryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LaundryItem> {
        return NSFetchRequest<LaundryItem>(entityName: "LaundryItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var qty: Int32

}

extension LaundryItem : Identifiable {

}
