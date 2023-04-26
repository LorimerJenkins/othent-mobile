


// detect reqs
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    
    console.log("Request just in: ", request);
    
    if (request.command === "logInButton") {
        console.log("logInButton")
    }
    
    
    if (request.update === "siteURL") {
        let titleContent = window.location.href;
        titleContent = titleContent.replace(/^https:\/\//i, "");
        console.log(titleContent)
        sendResponse({
            title: titleContent
        })
    }
    
    
    
    
});
