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
    console.log(data);
    const nameListElement = document.getElementById("name-list");
    nameListElement.innerHTML = "";

    for (let i = 0; i < data.initials.length; i++) {
      let div = document.createElement("div");
      div.setAttribute("id", data.user_ids[i]);
      div.title = data.users[i];
      div.classList.add("flex", "flex-col", "justify-center", "items-center", "bg-white", "rounded-full", "h-8", "w-8", "ml-1", "border-solid", "border-2", "border-blurple");
      nameListElement.appendChild(div)
      let paragraph = document.createElement("P")
      div.appendChild(paragraph)
      let text = document.createTextNode(data.initials[i])
      paragraph.appendChild(text)
    };

    showCurrentUser()
  },

  get documentIsActive() {
    return document.visibilityState == "visible" || document.hasFocus()
  },
})

