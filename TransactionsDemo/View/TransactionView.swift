//
//  TransactionView.swift
//  TransactionsDemo
//
//  Created by Monalisa.Swain on 02/09/24.
//

import SwiftUI
import CoreLocation

struct TransactionView: View {
    @StateObject private var viewModel = TransactionViewModel()
       
       var body: some View {
           NavigationView {
               ScrollView {
                   VStack(alignment: .leading) {
                       if let account = viewModel.account {
                           HStack {
                               AccountInfoView(account: account)
                               .padding()
                               .frame(maxWidth: .infinity)
                               .background(Color("HeaderBackgroundColr"))
                           }
                       } //Top header
                       
                       ForEach(viewModel.transactions.keys.sorted(by: >), id: \.self) { dateKey in
                           if let transactions = viewModel.transactions[dateKey] {
                               ForEach(transactions) { transaction in
                                   TransactionGroupView(date: dateKey, transactions: [transaction], relativeDate: viewModel.daysAgo(from: transaction.formattedDate), atms: viewModel.atms)
                               }
                           }
                       }//For each
                   }//Vstack
               }//ScrollView
               .navigationTitle("Account Details")
               .navigationBarTitleDisplayMode(.inline)
           }//NavigationView
       }
}

struct AccountInfoView: View {
    let account: Account

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Top Section
            HStack {
                Image("Accounts")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading) {
                    Text(account.accountName)
                        .font(.title)
                    Text(account.accountNumber)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }//HStack
            
            // Separator
            Divider()
                .padding(.vertical, 5)
                .frame(maxWidth: .infinity)
            
            HStack {
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Available Funds")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(String(format: "$%.2f", account.available))
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Account Balance")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(String(format: "$%.2f", account.balance))
                            .font(.title3)
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                    }//Hstack
                }//VSTack
                .padding(.leading, 50)
                Spacer()
                    
            }//HSTACK
        }//VSTack
        .padding()
        .background(Color(UIColor.systemGray6))
    }
}
struct TransactionGroupView: View {
    let date: String
    let transactions: [Transaction]
    let relativeDate: String
    let atms: [String: ATM]
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var isMapViewActive = false

    
    var body: some View {
        VStack(alignment: .leading) {
            if let firstTransaction = transactions.first {
                
                HStack() {
                    Text("\(firstTransaction.displayDate)")
                        .font(.headline)
                        .padding(.leading, 10)
                    Spacer()
                    
                    Text("\(relativeDate)")
                        .padding(.trailing, 5)
                }
                .frame(maxWidth: .infinity, idealHeight: 30)
                .background(Color("ThemeColor"))
            } //TransactionDate Header
            
            ForEach(transactions) { transaction in
                VStack(alignment: .leading) {
                    HStack {
                        if let atmId = transaction.atmId, let atm = atms[atmId] {
                            if let atmId = transaction.atmId, let atm = atms[atmId] {
                                Button(action: {
                                    fetchCoordinates(for: atm.address)
                                }) {
                                    Image("FindUs")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 30, height: 24)
                                }
                                .padding(.leading, 15)
                                .padding(.trailing, 8)
                            }
                        } //ATM Icon
                        
                        Text(transaction.description.replacingBreaksWithNewlines())
                            .padding(.leading, 10)
                        
                        Spacer()
                        Text(String(format: "$%.2f", transaction.amount))
                            .padding(.trailing, 15)
                        
                    }//Hstack
                    .padding(.vertical, 5)
                } //Vtstack
            } //For Each
            
            if let latitude = latitude, let longitude = longitude {
                NavigationLink(destination: MapView(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)), isActive: $isMapViewActive) {
                    EmptyView()
                }
            }
        }//Vstack
        
        
    }
    
    private func fetchCoordinates(for address: String) {
        MapUtility.shared.getCoordinates(forAddress: address) { location, error in
            if let location = location {
                self.latitude = location.latitude
                self.longitude = location.longitude
                self.isMapViewActive = true
            } else {
                print("Failed to get coordinates.")
            }
        }
    }
}


extension String {
    func replacingBreaksWithNewlines() -> String {
        return self.replacingOccurrences(of: "<br/>", with: "\n")
    }
}

#Preview {
    TransactionView()
}
