import consumer from "./consumer"

const visitor_id = document.cookie
  .split("; ")
  .find(row => row.startsWith("visitor_id="))
  .split("=")[1];

consumer.subscriptions.create({
  channel: "NotificationsChannel", id:visitor_id
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