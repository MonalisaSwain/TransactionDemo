//
//  TransactionsModel.swift
//  TransactionsDemo
//
//  Created by Monalisa.Swain on 02/09/24.
//

import Foundation


// ATM Model
struct ATM: Codable, Identifiable {
    let id: String
    let name: String
    let address: String
    let location: Location
    
    struct Location: Codable {
        let lat: Double
        let lng: Double
    }
}

// Transaction Model
struct Transaction: Identifiable, Codable {
    let id: String
    let effectiveDate: String
    let description: String
    let amount: Double
    let atmId: String?
    
    var formattedDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: effectiveDate) ?? Date()
    }
    
    var displayDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy" 
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            var formattedDate = dateFormatter.string(from: formattedDate)
        
            return formattedDate
        }
    
    
}

// Account Model
struct Account: Codable {
    let accountName: String
    let accountNumber: String
    let available: Double
    let balance: Double
}

// Root Model
struct FinancialData: Codable {
    let account: Account
    let transactions: [Transaction]
    let pending: [Transaction]
    let atms: [ATM]
}
