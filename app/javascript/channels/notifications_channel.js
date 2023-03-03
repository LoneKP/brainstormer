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
        toggleDownloadButtonSpinner(data.type);
        break;
      case "done":
        toggleDownloadButtonSpinner(data.type);
        clickDownloadButton(data.type);
        break;
      }
  },
})