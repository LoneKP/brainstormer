import consumer from "./consumer"

const session_id = document.cookie
  .split("; ")
  .find(row => row.startsWith("visitor_id="))
  .split("=")[1];

consumer.subscriptions.create({
  channel: "NotificationsChannel", id:session_id
}, {
  received(data) {
    switch (data.status) {
      case "generating":
        togglePdfButtonSpinner();
        break;
      case "done":
        togglePdfButtonSpinner();
        clickPdfButton();
        break;
      }
  },
})