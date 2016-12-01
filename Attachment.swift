//
//  Attachment.swift
//  UnCloudNotes
//
//  Created by User on 12/1/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Attachment: NSManagedObject {
  @NSManaged var dateCreated: Date
  @NSManaged var image: UIImage?
  @NSManaged var note: Note?
}
