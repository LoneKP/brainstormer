import consumer from "./consumer"

consumer.subscriptions.create({ channel: "BrainstormChannel", id: location.pathname.split('/')[2] }, {

  // Called once when the subscription is created.
  initialized() {
    this.update = this.update.bind(this)
  },

  // Called when the subscription is ready for use on the server.
  connected() {
    this.install()
    this.update()
  },

  // Called when the WebSocket connection is closed.
  disconnected() {
    console.log("disconnected")
    this.uninstall()
  },

  // Called when the subscription is rejected by the server.
  rejected() {
    this.uninstall()
  },

  update() {
    if (this.documentIsActive == false) {
      this.away()
    }
  },

  away() {
    this.perform("unsubscribed")
  },

  install() {
    window.addEventListener("focus", this.update)
    window.addEventListener("blur", this.update)
    document.addEventListener("turbolinks:load", this.update)
    document.addEventListener("visibilitychange", this.update)
  },

  uninstall() {
    window.removeEventListener("focus", this.update)
    window.removeEventListener("blur", this.update)
    document.removeEventListener("turbolinks:load", this.update)
    document.removeEventListener("visibilitychange", this.update)
  },

  received(data) {
    console.log(data.users)
    const nameListElement = document.getElementById("name-list")
    nameListElement.innerHTML = "";

    for (let i = 0; i < data.users.length; i++) {
      let paragraph = document.createElement("P")
      let text = document.createTextNode(data.users[i])
      paragraph.appendChild(text)
      nameListElement.appendChild(paragraph)
    };
  },

  get documentIsActive() {
    return document.visibilityState == "visible" || document.hasFocus()
  },
})