//
//  TransactionViewModelTests.swift
//  TransactionsDemo
//
//  Created by Monalisa.Swain on 02/09/24.
//

import XCTest
@testable import TransactionsDemo

final class TransactionViewModelTests: XCTestCase {
    
    var viewModel: TransactionViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        viewModel = TransactionViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadTransactions() {
        viewModel.loadTransactions()
        
        XCTAssertNotNil(viewModel.account, "Account should not be nil")
        XCTAssertFalse(viewModel.transactions.isEmpty, "Transactions should not be empty")
        XCTAssertFalse(viewModel.atms.isEmpty, "ATMs should not be empty")
    }
    
    func testRelativeDateCalculation() {
        let now = Date()
        let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let fiveDaysAgo = Calendar.current.date(byAdding: .day, value: -5, to: now)!
        
        XCTAssertEqual(viewModel.daysAgo(from: now), "Today", "Should return 'Today' for the current date")
        XCTAssertEqual(viewModel.daysAgo(from: oneDayAgo), "1 days ago", "Should return '1 day ago' for 1 day ago")
        XCTAssertEqual(viewModel.daysAgo(from: fiveDaysAgo), "5 days ago", "Should return '5 days ago' for 5 days ago")
    }
    
    func testATMsDictionaryPopulation() {
        viewModel.loadTransactions()
        
        XCTAssertFalse(viewModel.atms.isEmpty, "ATMs dictionary should not be empty")
        
        for (id, atm) in viewModel.atms {
            XCTAssertEqual(id, atm.id, "ATM ID should match the key in the dictionary")
        }
    }
    
    func testInvalidDataHandling() {
        guard let invalidURL = Bundle.main.url(forResource: "InvalidSample", withExtension: "json") else {
            XCTFail("Invalid sample JSON not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: invalidURL)
            XCTAssertThrowsError(try JSONDecoder().decode(FinancialData.self, from: data), "Invalid data should throw an error")
        } catch {

        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
