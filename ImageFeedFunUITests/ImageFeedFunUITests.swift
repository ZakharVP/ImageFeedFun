//
//  ImageFeedFunUITests.swift
//  ImageFeedFunUITests
//
//  Created by Захар Панченко on 22.03.2025.
//

import XCTest
import ImageFeedFun

final class ImageFeedFunUITests: XCTestCase {

    private let app = XCUIApplication()  // переменная приложения

    override func setUpWithError() throws {
        continueAfterFailure = false  // настройка выполнения тестов, которая прекратит выполнения тестов, если в тесте что-то пошло не так

        app.launch()  // запускаем приложение перед каждым тестом
    }

    func testAuth() throws {
        
        let startButtun = app.buttons["Authenticate"]
        XCTAssertTrue(startButtun.waitForExistence(timeout: 15), "Кнопка авторизации не появилась")
        startButtun.tap()        
            
        // Ожидаем появления webView
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(
            webView.waitForExistence(timeout: 15),
            "Экран авторизации не загрузился")
        
        sleep(10)

        // Вводим логин
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(
            loginTextField.waitForExistence(timeout: 10),
            "Поле для ввода логина не появилось")
        loginTextField.tap()
        loginTextField.typeText("zakhar-panchenko@yandex.ru")
        webView.tap()

        // Вводим пароль
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        sleep(1)
        webView.swipeUp()
               
        UIPasteboard.general.string = "11111111"

        passwordTextField.press(forDuration: 1.5)
        XCTAssertTrue(app.menuItems["Paste"].waitForExistence(timeout: 5))
        app.menuItems["Paste"].tap()
        
        webView.tap() // Скрыть клавиатуру
        
        sleep(5)

        // Нажимаем кнопку "Login"
        webView.buttons["Login"].tap()

        // Ожидаем появления экрана ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(
            cell.waitForExistence(timeout: 10), "Экран ленты не загрузился")

    }

    func testFeed() throws {
        let tablesQuery = app.tables

        sleep(5)

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cellToLike.swipeUp()

        //Установить лайк
        let likeButton = cellToLike.buttons["like button"]
        likeButton.tap()
        
        sleep(5)
        
        //снять лайк
        likeButton.tap()
        
        sleep(5)
        
        //Открыть картинку
        cellToLike.tap()

        sleep(15)

        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1)  // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }

    func testProfile() throws {
        // тестируем сценарий профиля
        sleep(5)
        app.tabBars.buttons.element(boundBy: 1).tap()

        XCTAssertTrue(app.staticTexts["Захар Панченко"].exists)
        XCTAssertTrue(app.staticTexts["@trit5"].exists)
        
        sleep(15)

        app.buttons["logout button"].tap()
        
        sleep(5)

        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
