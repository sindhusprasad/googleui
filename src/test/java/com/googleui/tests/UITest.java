package com.googleui.tests;

import com.googleui.pages.UIPage;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.openqa.selenium.support.PageFactory;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.concurrent.TimeUnit;

public class UITest {
    private WebDriver driver;

    @BeforeTest
    public void setup() throws MalformedURLException {
        String browser = System.getProperty("browser");
        DesiredCapabilities capabilities;

        if (browser.equals("firefox")) {
            capabilities = DesiredCapabilities.firefox();
        } else {
            capabilities = DesiredCapabilities.chrome();
        }

        driver = new RemoteWebDriver(new URL("http://localhost:4444/wd/hub"), capabilities);
        driver.manage().timeouts().implicitlyWait(30, TimeUnit.SECONDS);
    }

    @Test
    public void googleTest() {
        driver.get("https://www.google.com/");
        UIPage uiPage = PageFactory.initElements(driver, UIPage.class);
        uiPage.clickGSearch();
    }

    @AfterTest
    public void tearDown() {
        driver.quit();
    }
}
