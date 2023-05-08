const emptyUser = {
  contract_id: "",
  given_name: "",
  family_name: "",
  nickname: "",
  name: "",
  picture: "",
  locale: "",
  email: "",
  email_verified: "",
  sub: "",
};

// Define a state to store user info when logged in
const othent = {
  userDetails: emptyUser,
  status: "logout ok",
  // possible status: logged out, logging in, logged in, logging out
};

// Helpers
const logRes = (res) => console.log(`BG: Response received: ${res}`);
const logErr = (err) => console.log(`BG: Error thrown: ${err}`);
const getActiveTab = () =>
  browser.tabs.query({ active: true, currentWindow: true });

// Call Content with an action helper
const msgContent = (req, handleRes) => {
  handleRes = handleRes ? handleRes : logRes;
  getActiveTab().then((tabs) => {
    if (tabs.length == 0) console.log("BG: Couldn't message active tab");
    else browser.tabs.sendMessage(tabs[0].id, req).then(handleRes, logErr);
  });
};

// Call Popup with an action helpers
const msgPopup = (req) => browser.runtime.sendMessage(req).then(logRes, logErr);

// Listen to messages from Content and Popup
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
  console.log("BG Received request: ", request);

  if (request.message === "bg-action") {
    switch (request.action) {
      case "login":
        othent.status = request.action;
        msgContent({ message: "ct-action", action: request.action });
        sendResponse({ message: `BG: ${request.action} action received` });
        break;
      case "logout":
        othent.status = request.action;
        msgContent({ message: "ct-action", action: request.action });
        sendResponse({ message: `BG: ${request.action} action received` });
        break;
      case "login ok":
        othent.status = request.action;
        othent.userDetails = request.userDetails;
        msgPopup({
          message: "pu-action",
          action: request.action,
          userDetails: othent.userDetails,
        });
        sendResponse({ message: `BG: ${request.action} action received` });
        break;
      case "logout ok":
        othent.status = request.action;
        othent.userDetails = emptyUser;
        msgPopup({ message: "pu-action", action: request.action });
        sendResponse({ message: `BG: ${request.action} action received` });
        break;
      case "user details":
      case "status":
        sendResponse({
          message: "bg-response",
          status: othent.status,
          userDetails: othent.userDetails,
        });
        break;
      case "site url":
        msgContent({ message: "ct-action", action: request.action }, (res) =>
          sendResponse(res)
        );
        break;
      default:
        sendResponse({ message: "BG: No action matched" });
    }
  }
});
