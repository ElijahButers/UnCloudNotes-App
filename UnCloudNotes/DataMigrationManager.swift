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

//MARK: - Managed Object Model

extension NSManagedObjectModel {
}
