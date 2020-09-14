//
//  ContentView.swift
//  TestTwo
//
//  Created by Jan Hovland on 14/09/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var account = Account()
    @State private var accounts = [Account]()
    @State private var saveAccount = false
    
    var body: some View {
        
        Text("Test of reading from CloudKit")
        
        List {
            ForEach(accounts) { account in
                Text("Account for \(account.name)")
            }
        }
        
        VStack {
            Button(action: {
                account.name = "Xxx Xxxxx"
                account.email = "xxx.xxxxx.lyse.net"
                account.password = "xxxxxx"
                CloudKitAccount.saveAccount(item: account) { (result) in
                    switch result {
                    case .success:
                        print("Saved OK")
                    case .failure(let err):
                        print(err)
                    }
                }
                
            }, label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(.blue)
                    .font(.title)
            })
        }

        
        
        

        .onAppear {
            refresh()
        }
    }
    
    
    func refresh() {
        self.accounts.removeAll()
        /// Fetch all persons from CloudKit
        let predicate = NSPredicate(value: true)
        CloudKitAccount.fetchAccount(predicate: predicate)  { (result) in
            switch result {
            case .success(let account):
                accounts.append(account)
                accounts.sort(by: {$0.name < $1.name})
            case .failure(let err):
                print(err)
            }
        }
    }
}
