// active tab
function getActiveTab() {
    return browser.tabs.query({active: true, currentWindow: true});
}


// log in button
document.getElementById("logInButton").addEventListener("click", function() {
    getActiveTab().then((tabs) => {
        browser.tabs.sendMessage(tabs[0].id, {
            command: "logInButton",
        });
    });
});


// connected to, text
getActiveTab().then(async (tabs) => { // add async keyword here

    let response = await browser.tabs.sendMessage(tabs[0].id, { // replace "tabs" with "browser.tabs"
        update: 'siteURL'
    });
    console.log(response);
    let titleElement = document.getElementById("title")
    titleElement.textContent = response?.title;

});

