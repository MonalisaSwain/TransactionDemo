//
//  TransactionViewModel.swift
//  TransactionsDemo
//
//  Created by Monalisa.Swain on 02/09/24.
//

import Foundation
import SwiftUI

class TransactionViewModel: ObservableObject {
    @Published var transactions: [String: [Transaction]] = [:]
    @Published var account: Account?
    @Published var pendingTransactions: [Transaction] = []
    @Published var atms: [String: ATM] = [:]

    init() {
        loadTransactions()
    }
    
    func loadTransactions() {
        
        guard let url = Bundle.main.url(forResource: "Sample", withExtension: "json") else {
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        
        guard let financialData = try? JSONDecoder().decode(FinancialData.self, from: data) else {
            return
        }
        
        // Group and sort transactions
        let allTransactions = financialData.transactions + financialData.pending.map { Transaction(id: $0.id, effectiveDate: $0.effectiveDate, description: "PENDING: \($0.description)", amount: $0.amount, atmId: $0.atmId) }
        let groupedTransactions = Dictionary(grouping: allTransactions) { $0.effectiveDate }
        let sortedTransactions = groupedTransactions.sorted { $0.key > $1.key }
        self.transactions = Dictionary(uniqueKeysWithValues: sortedTransactions)
        
        self.account = financialData.account
        
        self.pendingTransactions = financialData.pending
        
        self.atms = Dictionary(uniqueKeysWithValues: financialData.atms.map { ($0.id, $0) })
    }
    
    
    
    func relativeDate(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    func daysAgo(from date: Date) -> String {
            let calendar = Calendar.current
            let now = Date()
            
            if let daysDifference = calendar.dateComponents([.day], from: date, to: now).day {
                if daysDifference == 0 {
                    return "Today"
                } else if daysDifference > 0 {
                    return "\(daysDifference) days ago"
                } else {
                    return "In \(-daysDifference) days"
                }
            }
            
            return ""
        }
}
