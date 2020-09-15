//
//  ContentView.swift
//  TestTwo
//
//  Created by Jan Hovland on 14/09/2020.
//

//    Updated for Xcode 12.0
//
//    SwiftUI’s @EnvironmentObject property wrapper allows us to create views that
//    rely on shared data, often across an entire SwiftUI app. For example,
//    if you create a user that will be shared across many parts of your app,
//    you should use @EnvironmentObject.
//
//    For example, we might have an Order class like this one:
//
//    class Order: ObservableObject {
//        @Published var items = [String]()
//    }
//
//
//    struct ContentView: View {
//        @EnvironmentObject var order: Order
//
//        var body: some View {
//            // your code here
//        }
//    }

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var user: User
    
    @State private var account = Account()
    @State private var accounts = [Account]()
    @State private var saveAccount = false
    
    @State private var showOptionMenu = true
    
    
    var body: some View {
        // ScrollView (.vertical, showsIndicators: false) {
        LazyVStack {
            Spacer(minLength: 37)
            HStack {
                Text(NSLocalizedString("Sign in CloudKit", comment: "SignInView"))
                    .font(.headline)
                    .foregroundColor(.accentColor)
            }
            Spacer(minLength: 37)
            ZStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                    .font(Font.title.weight(.ultraLight))
                    //                    if self.user.image != nil {
                    //                        Image(uiImage: self.user.image!)
                    //                            .resizable()
                    //                            .frame(width: 80, height: 80, alignment: .center)
                    //                            .clipShape(Circle())
                    //                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    //                    }
                    .padding(10)
            }
            HStack (alignment: .center, spacing: 10) {
                Text(NSLocalizedString("Options Menu", comment: "SignInView"))
                    /// Skjuler teksten uten å påvirke layout
                    .opacity(showOptionMenu ? 1 : 0)
                Image(systemName: "square.stack")
                    /// Skjuler bildet  uten å påvirke layout
                    .opacity(showOptionMenu ? 1 : 0)
            }
            .foregroundColor(.accentColor)
            .padding(10)
        }
        /// Spacer() flytter innholdet i LazyVStack mot toppen
        Spacer()
        
        //        Text("Test of reading from CloudKit")
        //
        //        List {
        //            ForEach(accounts) { account in
        //                Text("Account for \(account.name)")
        //            }
        //        }
        //
        //        VStack {
        //            Button(action: {
        //                account.name = "Xxx Xxxxx"
        //                account.email = "xxx.xxxxx.lyse.net"
        //                account.password = "xxxxxx"
        //                CloudKitAccount.saveAccount(item: account) { (result) in
        //                    switch result {
        //                    case .success:
        //                        print("Saved OK")
        //                    case .failure(let err):
        //                        print(err)
        //                    }
        //                }
        //            }, label: {
        //                Image(systemName: "magnifyingglass")
        //                    .resizable()
        //                    .frame(width: 20, height: 20, alignment: .center)
        //                    .foregroundColor(.blue)
        //                    .font(.title)
        //            })
        //        }
        
        .onAppear {
            refresh()
            print(user.name)
        }
        
        
    }
    
    func refresh() {
        self.accounts.removeAll()
        /// Fetch all persons from CloudKit
        let predicate = NSPredicate(value: true)
        DispatchQueue.main.async {
            CloudKitAccount.fetchAccount(predicate: predicate)  { (result) in
                switch result {
                case .success(let account):
                    user.name = account.name
                    accounts.append(account)
                    accounts.sort(by: {$0.name < $1.name})
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}
