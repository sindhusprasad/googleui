package com.googleui.pages;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class UIPage {
    private WebDriver driver;

    public UIPage(WebDriver driver) {
        this.driver = driver;
    }

    @FindBy(xpath = "//div[not(contains(@style, 'display:none'))]/div/div/center/input[@name='btnK']")
    private WebElement googleSearch;

    public void clickGSearch() {
        googleSearch.click();
    }
}
