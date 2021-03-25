//
//  ChatPreview+CoreDataProperties.swift
//  
//
//  Created by Аня Воронцова on 19.03.2021.
//
//

import Foundation
import CoreData


extension ChatPreview {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatPreview> {
        return NSFetchRequest<ChatPreview>(entityName: "Messages")
    }

    @NSManaged public var body: String?
    @NSManaged public var time: String?
    @NSManaged public var sender: Bool

}
