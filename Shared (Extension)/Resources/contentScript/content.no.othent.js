// We include the othent module by adding it to the manifest.json
// import { Othent } from "othent";

// const othent = Othent({ API_KEY: "API_KEY", API_ID: "API_ID" });

// mock data
const mockUser = {
  contract_id: "abcdefghij",
  given_name: "Lorimer",
  family_name: "Jenkins",
  nickname: "Lorimer",
  name: "Lorimer Jenkins",
  // picture: "https://www.w3schools.com/html/img_girl.jpg",
  picture:
    "https://lh3.googleusercontent.com/a/AGNmyxav6wx_N-uO9gj2N2QNad-Kzi1wPZ3oCepvF1wu9w=s96-c",
  locale: "EN_us",
  email: "hello@othent.io",
  email_verified: "hello@othent.io",
  sub: "123",
};

// mock login / logout
const handleRes = (res) => console.log(`CT: Received response: ${res}`);
const handleErr = (err) => console.log(`CT: Error thrown: ${err}`);
const sendLoginOkMessage = () =>
  browser.runtime
    .sendMessage({
      message: "bg-action",
      action: "login ok",
      userDetails: mockUser,
    })
    .then(handleRes, handleErr);
const sendLogoutOkMessage = () =>
  browser.runtime
    .sendMessage({
      message: "bg-action",
      action: "logout ok",
    })
    .then(handleRes, handleErr);
const login = () => {
  setTimeout(sendLoginOkMessage, 4000);
};
const logout = () => {
  setTimeout(sendLogoutOkMessage, 4000);
};

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
