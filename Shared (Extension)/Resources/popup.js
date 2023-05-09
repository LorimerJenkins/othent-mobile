// const statusElem = document.querySelector("#status");
const titleElem = document.querySelector("#title");
const username = document.querySelector("#username");
const avatar = document.querySelector("#avatar");
const loginButton = document.querySelector("#login-button");
const logoutButton = document.querySelector("#logout-button");
const loginContainer = document.querySelector("#login-container");
const logoutContainer = document.querySelector("#logout-container");
const txnButton = document.querySelector("#send-transaction-button");

// Disable buttons on click event
const updateButton = (btnElem, msg, disabled, display) => {
  if (display) btnElem.style.display = display;
  btnElem.classList.add("button-loading");
  btnElem.disabled = disabled;
  if (msg) btnElem.innerHTML = msg;
};

loginButton.addEventListener("click", () =>
  updateButton(loginButton, "Logging&nbsp;in...", true)
);
logoutButton.addEventListener("click", () =>
  updateButton(logoutButton, "Logging&nbsp;out...", true)
);

// Set up popup view if user is logged in
const loggedIn = (userDetails) => {
  // statusElem.innerHTML = "Logged In";
  updateButton(loginButton, "Log&nbsp;In", true);
  updateButton(logoutButton, "Log&nbsp;Out", false);
  loginContainer.style.display = "none";
  logoutContainer.style.display = "flex";
  if (userDetails) {
    if (userDetails.given_name) {
      username.style.display = "flex";
      username.innerHTML = userDetails.given_name;
    } else username.style.display = "none";
    if (userDetails.picture) {
      avatar.style.display = "flex";
      avatar.src = userDetails.picture;
    } else avatar.style.display = "none";
  }
};

// Set up popup view if user is logged in
const loggedOut = () => {
  // statusElem.innerHTML = "Logged In";
  updateButton(loginButton, "Log&nbsp;In", false);
  updateButton(logoutButton, "Log&nbsp;Out", true);
  loginContainer.style.display = "flex";
  logoutContainer.style.display = "none";
  username.innerHTML = "";
  username.style.display = "none";
  avatar.src = "";
  avatar.style.display = "none";
  logoutContainer.style.display = "none";
  loginContainer.style.display = "flex";
};

// Helpers
const getActiveTab = () =>
  browser.tabs.query({ active: true, currentWindow: true });
const logErr = (err) => console.log(`PU: Error thrown: ${err}`);
const logRes = (res) => console.log(`PU: Received response: ${res}`);

const bgStatus = (res) => {
  console.log(`PU: Background answered: ${res}`);
  if (res.status === "logout ok") loggedOut();
  else if (res.status === "login ok") loggedIn(res.userDetails);
};

// Call Background with an action helpers
const msgBackground = (req, handleRes) =>
  browser.runtime.sendMessage(req).then(handleRes ? handleRes : logRes, logErr);

// Call Content with an action helper
const msgContent = (req, handleRes) => {
  getActiveTab().then((tabs) => {
    if (tabs.length == 0) console.log("BG: Couldn't message active tab");
    else
      browser.tabs
        .sendMessage(tabs[0].id, req)
        .then(handleRes ? handleRes : logRes, logErr);
  });
};

const login = () => {
  msgBackground({ message: "bg-action", action: "login" });
  window.close();
};
const logout = () => msgBackground({ message: "bg-action", action: "logout" });
const getLocation = () =>
  msgContent({ message: "ct-action", action: "site url" });
const sendTx = () => msgContent({ message: "ct-action", action: "send tx" });

// Listen to messages from Background
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
  console.log("PU Received request: ", request);

  if (request.message === "pu-action") {
    switch (request.action) {
      case "login ok":
        loggedIn(request.userDetails);
        sendResponse({ message: `PU: ${request.action} action received` });
        // window.close();
        break;
      case "logout ok":
        loggedOut();
        sendResponse({ message: `PU: ${request.action} action received` });
        break;
      default:
        sendResponse({ message: "PU: No action matched" });
    }
  }
});

// *********

document.addEventListener("DOMContentLoaded", () => {
  // Listen to button events to call helpers
  loginButton.addEventListener("click", login);
  logoutButton.addEventListener("click", logout);
  txnButton.addEventListener("click", () =>
    msgContent({ message: "ct-action", action: "send tx" }, logRes)
  );
  console.log("PU dom loaded: Calling background for status");
  msgBackground({ message: "bg-action", action: "status" }, bgStatus);
  msgContent(
    { message: "ct-action", action: "site url" },
    (res) => (titleElem.innerHTML = res?.message)
  );
});
