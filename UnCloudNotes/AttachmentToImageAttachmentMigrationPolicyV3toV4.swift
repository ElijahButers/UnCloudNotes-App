//
//  AttachmentToImageAttachmentMigrationPolicyV3toV4.swift
//  UnCloudNotes
//
//  Created by User on 12/15/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import CoreData
import UIKit

let errorDomain = "Migration"

class AttachmentToImageAttachmentMigrationPolicyV3toV4: NSEntityMigrationPolicy {
  
  override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
    
    let description = NSEntityDescription.entity(forEntityName: "ImageAttachment", in: manager.destinationContext)
    let newAttachment = ImageAttachment(entity: description!, insertInto: manager.destinationContext)
  
  
  func traversePropertyMappings(block: (NSPropertyMapping, String) -> ()) throws {
    
    if let attributeMappings = mapping.attributeMappings {
      for propertyMapping in attributeMappings {
        if let destinaltionName = propertyMapping.name {
          block(propertyMapping, destinaltionName)
        } else {
          let message = "Attribute destioation not configured properly"
          let userInfo = [NSLocalizedFailureReasonErrorKey: message]
          throw NSError(domain: errorDomain, code: 0, userInfo: userInfo)
      }
    }
    } else {
      let message = "No Attribute Mapping found!"
      let userInfo = [NSLocalizedFailureReasonErrorKey: message]
      throw NSError(domain: errorDomain, code: 0, userInfo: userInfo)
    }
  }
  
}
