// We include the othent module by adding it to the manifest.json
import { Othent } from "othent";

let othent = null;

const getOthent = () => Othent({ API_KEY: "API_KEY", API_ID: "API_ID" });

// mock login / logout
const handleRes = (res) => console.log(`CT: Received response: ${res}`);
const handleErr = (err) => console.log(`CT: Error thrown: ${err}`);
const msgRuntime = (req, resCallback) =>
  browser.runtime
    .sendMessage(req)
    .then(resCallback ? resCallback : handleRes, handleErr);

// const sendLogoutOkMessage = () =>
//   browser.runtime
//     .sendMessage({
//       message: "bg-action",
//       action: "logout ok",
//     })
//     .then(handleRes, handleErr);

const callLogin = () =>
  othent.logIn().then(
    (res) =>
      msgRuntime({
        message: "bg-action",
        action: "login ok",
        userDetails: res,
      }),
    handleErr
  );

const callLogout = () =>
  othent.logOut().then(
    (res) =>
      msgRuntime({
        message: "bg-action",
        action: "logout ok",
        logOutResponse: res,
      }),
    handleErr
  );

const isOthent = (callbackFn) => {
  if (othent) callbackFn();
  else
    getOthent().then((othInstance) => {
      othent = othInstance;
      callbackFn();
    }, handleErr);
};

const login = () => isOthent(callLogin);
const logout = () => isOthent(callLogout);
// {
//   if (othent) callLogin();
//   else
//     getOthent().then((othentInstance) => {
//       othent = othentInstance;
//       callLogin();
//     }, handleErr);
// };

// const logout = () => {
//   setTimeout(sendLogoutOkMessage, 4000);
// };

// Listen to messages from Background
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
  console.log("CT Received request: ", request);
  if (request.message === "ct-action") {
    switch (request.action) {
      case "login":
        login();
        sendResponse({ message: `CT: ${request.action} action received` });
        break;
      case "logout":
        logout();
        sendResponse({ message: `CT: ${request.action} action received` });
        break;
      case "site url":
        let titleContent = window.location.href;
        titleContent = titleContent.replace(/^https:\/\//i, "");
        console.log(titleContent);
        sendResponse({ message: titleContent });
        break;
      case "send tx":
        sendResponse({ message: `CT: ${request.action} action received` });
        break;
      default:
        sendResponse({ message: "CT: No action matched" });
    }
  }
});
