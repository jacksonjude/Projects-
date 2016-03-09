//
//  Syncable.swift
//  ProjectsPlus
//
//  Created by jackson on 11/25/15.
//  Copyright © 2015 jackson. All rights reserved.
//

import Foundation
import CloudKit

@objc protocol Syncable
{
    var uuid: String? { get set }
    var syncState: NSNumber? { get set }
    
    func updateFromRemote(remoteRecord: CKRecord)
    func updateToRemote(remoteReacord: CKRecord)
}