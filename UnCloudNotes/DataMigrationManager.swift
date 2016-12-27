//
//  DataMigrationManager.swift
//  UnCloudNotes
//
//  Created by User on 12/23/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import Foundation
import CoreData

class DataMigrationManager {
  
  let enableMigrations: Bool
  let modelName: String
  let storeName: String = "UnCloudNotedDataModel"
  var stack: CoreDataStack
  
  init(modelNamed: String, enableMigrations: Bool = false) {
    self.modelName = modelNamed
    self.enableMigrations = enableMigrations
  }
}

func == (firstModel: NSManagedObjectModel, otherModel: NSManagedObjectModel) -> Bool {
  return firstModel.entitiesByName == otherModel.entitiesByName
}

//MARK: - Managed Object Model

extension NSManagedObjectModel {
  
  private class func modelURLs(in modelFolder: String) -> [URL] {
    
    return Bundle.main.urls(forResourcesWithExtension: "mom", subdirectory: "\(modelFolder).momd") ?? []
  }
  
  class func modelVersionsFor(modelNamed modelName: String) -> [NSManagedObjectModel]{
    
    return modelURLs(in: modelName).flatMap(NSManagedObjectModel.init)
  }
  
  class func uncloudNotesModel(named modelName: String) -> NSManagedObjectModel {
    
    let model = modelURLs(in: "UnCloudNotesDataModel")
      .filter { $0.lastPathComponent == "\(modelName).mom" }
      .first
      .flatMap(NSManagedObjectModel.init)
    return model ?? NSManagedObjectModel()
  }
  
  class var version1: NSManagedObjectModel {
    return uncloudNotesModel(named: "UnCloudNotesDataModel")
  }
  
  var isVersion1: Bool {
    return self == type(of: self).version1
  }
  
  class var version2: NSManagedObjectModel {
    return uncloudNotesModel(named: "UnCloudNotesDataModel v2")
  }
  
  var isVersion2: Bool {
    return self == type(of: self).version2
  }

  class var version3: NSManagedObjectModel {
    return uncloudNotesModel(named: "UnCloudNotesDataModel v 3")
  }
  
  var isVersion3: Bool {
    return self == type(of: self).version3
  }


}