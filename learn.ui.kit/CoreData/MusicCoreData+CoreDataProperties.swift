//
//  MusicCoreData+CoreDataProperties.swift
//  learn.ui.kit
//
//  Created by ghtk on 04/07/2022.
//
//

import Foundation
import CoreData


extension MusicCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MusicCoreData> {
        return NSFetchRequest<MusicCoreData>(entityName: "MusicCoreData")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var artistName: String?
    @NSManaged public var artworkUrl100: String?

}

extension MusicCoreData : Identifiable {

}
