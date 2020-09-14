//
//  CloudKitAccount.swift
//  PersonOverView
//
//  Created by Jan Hovland on 28/07/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct CloudKitAccount {
    struct RecordType {
        static let account = "Account"            
    }
    /// MARK: - errors
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    
    /// MARK: - saving to CloudKit
    static func saveAccount(item: Account, completion: @escaping (Result<Account, Error>) -> ()) {
        let itemRecord = CKRecord(recordType: "Account") // RecordType.account)
        itemRecord["name"] = item.name as CKRecordValue
        itemRecord["email"] = item.email as CKRecordValue
        itemRecord["password"] = item.password as CKRecordValue
        CKContainer.default().privateCloudDatabase.save(itemRecord) { (record, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
                guard let record = record else {
                    completion(.failure(CloudKitHelperError.recordFailure))
                    return
                }
                let recordID = record.recordID
                guard let name = record["name"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let email = record["email"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                guard let password = record["password"] as? String else {
                    completion(.failure(CloudKitHelperError.castFailure))
                    return
                }
                let account = Account(recordID: recordID,
                                    name: name,
                                    email: email,
                                    password: password)
                
                completion(.success(account))
            }
        }
    }

    
    
    // MARK: - fetching from CloudKit
    static func fetchAccount(predicate:  NSPredicate, completion: @escaping (Result<Account, Error>) -> ()) {
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: RecordType.account, predicate: predicate)
        query.sortDescriptors = [sort]
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["name",
                                 "email",
                                 "password",
                                 "image"]
        operation.resultsLimit = 500
        operation.recordFetchedBlock = { record in
            DispatchQueue.main.async {
                let recordID = record.recordID
                guard let name = record["name"] as? String else { return }
                guard let email = record["email"] as? String else { return }
                guard let password = record["password"] as? String else { return }
                
                if let image = record["image"], let imageAsset = image as? CKAsset {
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                        let image = UIImage(data: imageData)
                        let account = Account(recordID: recordID,
                                              name: name,
                                              email: email,
                                              password: password,
                                              image: image)
                        completion(.success(account))
                    }
                }
                else {
                    let account = Account(recordID: recordID,
                                          name: name,
                                          email: email,
                                          password: password,
                                          image: nil)
                    completion(.success(account))
                }
            }
        }
        operation.queryCompletionBlock = { ( _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    completion(.failure(err))
                    return
                }
            }
        }
        CKContainer.default().privateCloudDatabase.add(operation)
    }
    
}

