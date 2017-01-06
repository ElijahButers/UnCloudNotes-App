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
  var stack: CoreDataStack {
    
    guard enableMigrations, !store(at: storeURL, isCompatibleWithModel: currentModel)
      else { return CoreDataStack(modelName: modelName) }
    
    return CoreDataStack(modelName: modelName)
  }
  
  init(modelNamed: String, enableMigrations: Bool = false) {
    self.modelName = modelNamed
    self.enableMigrations = enableMigrations
  }
  
  private lazy var currentModel: NSManagedObjectModel = .model(named: self.modelName)
  
  private func store(at storeURL: URL, isCompatibleWithModel model: NSManagedObjectModel) -> Bool {
    
    let storeMetadata = metadataForStoreAtURL(storeURL: storeURL)
    
    return model.isConfiguration(withName: nil, compatibleWithStoreMetadata: storeMetadata)
  }
  
  private func metadataForStoreAtURL(storeURL: URL) -> [String: Any] {
    
    let metadata: [String: Any]
    
    do {
      metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: storeURL, options: nil)
    } catch {
      metadata = [:]
      print("Error retrieving metadata for store at URL: \(storeURL): \(error)")
    }
    return metadata
  }
  
  // MARK: - Migration method
  
  func performMigration() {
  }
  
  //MARK: - Current store URL and model
  
  private var applicationSupportURL: URL {
    
    let path = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true)
      .first
    return URL(fileURLWithPath: path!)
  }
  
  private lazy var storeURL: URL = {
    
    let storeFileName = "\(self.storeName).sqlite"
    return URL(fileURLWithPath: storeFileName, relativeTo: self.applicationSupportURL)
  }()
  
  private var storeModel: NSManagedObjectModel? {
    
    return NSManagedObjectModel.modelVersionsFor(modelNamed: modelName)
      .filter {
        self.store(at: storeURL, isCompatibleWithModel: $0)
    }.first
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
  
  class var version4: NSManagedObjectModel {
    return uncloudNotesModel(named: "UnCloudNotesDataModel v4")
  }
  
  var isVersion4: Bool {
    return self == type(of: self).version4
  }
  
  // MARK: - Initializing a Managed Object Model
  
  class func model(named modelName: String, in bundle: Bundle = .main) -> NSManagedObjectModel {
    
    return bundle
      .url(forResource: modelName, withExtension: "momd")
      .flatMap(NSManagedObjectModel.init) ?? NSManagedObjectModel()
  }
  
  // MARK: - Migration method
  
  private func migrateStoreAt(URL storeURL: URL, fromModel from: NSManagedObjectModel, toModel to: NSManagedObjectModel, mappingModel: NSMappingModel? = nil) {
    
    let migrationManager = NSMigrationManager(sourceModel: from, destinationModel: to)
    
    var migrationMappingModel: NSMappingModel
    if let mappingModel = mappingModel {
      migrationMappingModel = mappingModel
    } else {
      migrationMappingModel = try! NSMappingModel
      .inferredMappingModel(forSourceModel: from, destinationModel: to)
    }
    
    let targetURL = storeURL.deletingLastPathComponent()
    let destinationName = storeURL.lastPathComponent + "~1"
    let destinationURL = targetURL.appendingPathComponent(destinationName)
    
    print("From Model: \(from.entityVersionHashesByName)")
    print("To Model: \(to.entityVersionHashesByName)")
    print("Migration store: \(storeURL) to \(destinationURL)")
    print("Mapping Model: \(mappingModel)")
    
    let success: Bool
      do {
        try migrationManager.migrateStore(from: storeURL, sourceType: NSSQLiteStoreType, options: nil, with: migrationMappingModel, toDestinationURL: destinationURL, destinationType: NSSQLiteStoreType, destinationOptions: nil)
        success = true
      } catch {
        success = false
        print("Migration failed: \(error)")
    }
    
    if success {
      print("Migration Completed Successfully")
      
      let fileManager = FileManager.default
      do {
        try fileManager.removeItem(at: storeURL)
        try fileManager.moveItem(at: destinationURL, to: storeURL)
      } catch {
        print("Error migrating \(error)")
      }
    }
  }
}


