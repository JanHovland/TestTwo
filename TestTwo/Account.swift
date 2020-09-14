//
//  Account.swift
//  TestTwo
//
//  Created by Jan Hovland on 14/09/2020.
//

import SwiftUI
import CloudKit

struct Account: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var image: UIImage?
}
