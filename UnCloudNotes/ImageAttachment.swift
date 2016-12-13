//
//  ImageAttachment.swift
//  UnCloudNotes
//
//  Created by User on 12/13/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import UIKit
import CoreData

class ImageAttachment: Attachment {
  
  @NSManaged var image: UIImage?
  @NSManaged var width: Float
  @NSManaged var height: Float
  @NSManaged var caption: String
}
