
cleanup() {
    # kill selenium server if already running
    for pid in $(ps -ef | awk '/selenium-server-standalone/ {print $2}'); do kill -9 $pid; done

    # kill geckodriver if already running
    for pid in $(ps -ef | awk '/geckodriver/ {print $2}'); do kill -9 $pid; done

    # kill chromedriver if already running
    for pid in $(ps -ef | awk '/chromedriver/ {print $2}'); do kill -9 $pid; done

    # remove the downloaded selenium server jar if any
    rm -rf selenium-server-standalone-3.9.1.jar

    # cleanup previously downloaded dependencies
    rm -rf geckodriver-v0.24.0-macos.tar.gz
    rm -rf geckodriver

    # cleanup previously downloaded dependencies
    rm -rf chromedriver_mac64.zip
    rm -rf chromedriver
}

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------

firefox_setup() {
    # download geckodriver
    curl -OL https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-macos.tar.gz

    # uncompress it
    tar -xvf geckodriver-v0.24.0-macos.tar.gz &

    # start selenium server
    java -Dwebdriver.gecko.driver=geckodriver -jar selenium-server-standalone-3.9.1.jar 2> selenium.log > selenium-error.log &
}

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------

chrome_setup() {
    # start selenium server
    java -jar selenium-server-standalone-3.9.1.jar 2> selenium.log > selenium-error.log &

    # download chromedriver
    curl -O https://chromedriver.storage.googleapis.com/2.31/chromedriver_mac64.zip

    # unzip it
    unzip -o chromedriver_mac64.zip

    # start chromedriver
    ./chromedriver 2> chrome.log > chrome-error.log &
}

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------

if [ $# -lt 2 ]; then
  echo 1>&2 "Not enough arguments. Should be invoked as ./start-test.sh browsername test_suite [ex:- ./start-test.sh firefox testng]"
  exit 2
elif [ $# -gt 2 ]; then
  echo 1>&2 "Too many arguments. Should be invoked as ./start-test.sh browsername test_suite [ex:- ./start-test.sh firefox testng]"
  exit 2
fi

echo "Starting selenium server........"

cleanup

# download selenium stand alone server
curl -O https://selenium-release.storage.googleapis.com/3.9/selenium-server-standalone-3.9.1.jar

echo "****************************************************************************************************"
echo "Running tests on $1"
echo "****************************************************************************************************"

if [[ "$1" = "firefox" ]] ; then
    firefox_setup
elif [[ "$1" = "chrome" ]] ; then
    chrome_setup
else
    echo "Browser $1 is not installed"
    setup_failed=true
fi

if [[ -z "$setup_failed" ]]; then
    echo "Started server and driver successfully.........."

    echo "****************************************************************************************************"
    echo "Starting the tests"
    echo "****************************************************************************************************"

    # start the tests
    mvn clean install -Dbrowser=$1 -Dsuite=$2
fi
