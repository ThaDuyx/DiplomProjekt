//
//  RegistrUITests.swift
//  RegistrUITests
//
//  Created by Christoffer Detlef on 06/05/2022.
//

import XCTest

class RegistrUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private var currentDate = Date()
    
    override func setUp() {
        super.setUp()
        
        self.app = XCUIApplication()
        self.app.launch()
    }
    
    // MARK: - Test for login
    func test_parent_login() {
        // LoginOptions
        let parentLoginButton = self.app.buttons["parentNavigationLink"]
        parentLoginButton.tap()
        
        // UserIDView
        let userIDTextField = self.app.textFields["userIDTextField"]
        userIDTextField.tap()
        userIDTextField.typeText("test1@test.com")
        
        let userIDNextView = self.app.buttons["userIDNextView"]
        userIDNextView.tap()
        
        // PasswordView
        let passwordTextField = self.app.secureTextFields["passwordTextField"]
        passwordTextField.tap()
        passwordTextField.typeText("test1234")
        
        let passwordLogin = self.app.buttons["passwordLogin"]
        passwordLogin.tap()
    }
    
    func test_teacher_login() {
        // LoginOptions
        let parentLoginButton = self.app.buttons["teacherNavigationLink"]
        parentLoginButton.tap()
        
        // UserIDView
        let userIDTextField = self.app.textFields["userIDTextField"]
        userIDTextField.tap()
        userIDTextField.typeText("teacher@test.com")
        
        let userIDNextView = self.app.buttons["userIDNextView"]
        userIDNextView.tap()
        
        // PasswordView
        let passwordTextField = self.app.secureTextFields["passwordTextField"]
        passwordTextField.tap()
        passwordTextField.typeText("test1234")
        
        let passwordLogin = self.app.buttons["passwordLogin"]
        passwordLogin.tap()
    }
    
    // MARK: - Access the report view
    func test_access_report_view() -> XCUIElementQuery {
        // Login flow for teacher
        test_teacher_login()
        
        // Select report in tabbar
        let tabbar = self.app.tabBars["Fanelinje"]
        let tabBarItemRegistration = tabbar.buttons["Fravær"]
        tabBarItemRegistration.tap()
        
        // Select a class to make the report.
        let selectClass = self.app.cells["Favorit, 0.x, Frem"]
        selectClass.tap()
        
        let elementsQuery = self.app/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"tabbar\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements
        return elementsQuery
    }
    
    // MARK: - Test for creating a report as a teacher
    func test_make_new_report_registration() {

        let elementsQuery = test_access_report_view()
        
        var pickedDate: Date
        
        // If the current date is a weekend, there will not be displayed any kids, so we will need to move the date.
        if Calendar.current.isDateInWeekend(currentDate) {
            var dateComponent = DateComponents()
            dateComponent.day = 2
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)!
            pickedDate = futureDate
        } else {
            pickedDate = currentDate
        }
        
        // Select the date
        let scrollViewDate = elementsQuery.staticTexts[dateFormatter(date: pickedDate)]
        scrollViewDate.tap()
        scrollViewDate.tap()
        
        // Select a child to give an absence
        elementsQuery.staticTexts["Alexander Larsen"].tap()
        self.app.buttons["For sent"].tap()
        
        // Save the report
        self.app/*@START_MENU_TOKEN@*/.buttons["Gem"]/*[[".otherElements[\"tabbar\"].buttons[\"Gem\"]",".buttons[\"Gem\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    // MARK: - Checking if there is 15 dates, since it should take currentDate, and then 7 days in the future and 7 days in the past.
    func test_check_date_carousel_count() {
        // Getting the scrollView
        let element = test_access_report_view()
        
        // Counting all the items inside the scrollView
        var elementLabels = [String]()
        for i in 0..<element.staticTexts.count {
            elementLabels.append (element.staticTexts.element(boundBy: i).label)
        }
        
        print(elementLabels.count)
        
        // Using minus 1 here, since it also takes the text "I dag" into account, since it also is part of the scrollview
        let elementsCount = elementLabels.count-1
        
        // Checking if the amount of dates displayed is 15, since that is the amount there should be displayed.
        XCTAssertEqual(15, elementsCount)
        
    }
    
    // MARK: - Creat a new absence registration for child.
    func test_make_new_absence_registration() {
        // Login flow for parent
        test_parent_login()
        
        // Select registration in tabbar
        let tabbar = self.app.tabBars["Fanelinje"]
        let tabBarItemRegistration = tabbar.buttons["Indberet"]
        tabBarItemRegistration.tap()
        
        
        // Select pick child in registration
        let selectChildForRegistration = self.app.buttons["selectChildForRegistration"]
        selectChildForRegistration.tap()
        
        // Select Simone as the child
        let childPicked = self.app.buttons["Simone Jylstrup - 4.y"]
        childPicked.tap()
        
        // Select absence reason menu
        let absenceReasonMenu = self.app.buttons["absenceReasonMenu"]
        absenceReasonMenu.tap()
        
        // Select a reason from the absence reason menu
        let absenceReasonPicked = self.app.buttons["For sent"]
        absenceReasonPicked.tap()
        
        // Write on the description for absence
        let writeDescriptionForAbsence = self.app.textViews["writeDescriptionForAbsence"]
        writeDescriptionForAbsence.tap()
        writeDescriptionForAbsence.typeText("Simone kommer for sent i dag, da vi var til bryllup i går.")
        
        // Create the registration
        let createRegistration = self.app.buttons["createRegistration"]
        createRegistration.tap()
        
        // Checking if the registration have been made (only works truly works on a child that have had no previous registration added)
        child_absence_registration_count(isAfterRegistration: true)
    }
    
    func test_child_absence_registration_count() {
        child_absence_registration_count(isAfterRegistration: false)
    }
    
    func child_absence_registration_count(isAfterRegistration: Bool) {
        
        if isAfterRegistration {
            // Select home in tabbar
            let tabbar = self.app.tabBars["Fanelinje"]
            let tabBarItemRegistration = tabbar.buttons["Børn"]
            tabBarItemRegistration.tap()
        } else {
            test_parent_login()
        }
        
        let childCount = self.app.tables.children(matching: .cell).count
        print("the child count is: \(childCount)")

        let accesChildStatistics = self.app.cells["Konto, Navn: Simone Jylstrup, Klasse: 4.y, Frem, Email: jglen8@mail.com"]
        accesChildStatistics.tap()
        
        let absenceRegistration = self.app.buttons["Indberettelser"]
        absenceRegistration.tap()
        
        let cellCount = self.app.tables.children(matching: .cell).count
        
        print("The total count of cells are: \(cellCount)")
        
        XCTAssertGreaterThan(cellCount, 0)
    }
}


extension RegistrUITests {
    func dateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MMM"
        
        return dateFormatter.string(from: date)
    }
}
