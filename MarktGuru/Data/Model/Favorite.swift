//
//  Favorite.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import CoreData

@objc(Favorite)
final class Favorite: NSManagedObject {
    static let entityName: String = "Favorite"

    @NSManaged public var id: Int
}

// MARK: - NSManagedObjectModel

extension NSManagedObjectModel {
    static func favoriteProductModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        let entity = NSEntityDescription()
        entity.name = Favorite.entityName
        entity.managedObjectClassName = NSStringFromClass(Favorite.self)
        
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .integer64AttributeType
        idAttribute.isOptional = false
        
        entity.properties = [idAttribute]
        model.entities = [entity]
        return model
    }
}
