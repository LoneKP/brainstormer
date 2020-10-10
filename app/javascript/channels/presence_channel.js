import consumer from "./consumer"

consumer.subscriptions.create({
  channel: "PresenceChannel", token: location.pathname.replace("/", "")
}, {

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
    console.log(data)
    switch (data.event) {
      case "transmit_presence_list":
        if (typeof currentUser == "undefined") {
          location.reload();
        }
        setBoolIfNoUserName(data);
        clearNameListElement();
        createUserBadges(data);
        openModalToSetName();
        showCurrentUser();
        if (data.users.length > 7) { removeOverflowingUsers(data.users.length) };
        break;
      case "name_changed":
        this.perform("update_name");
        setCurrentUserName(data.name);
        break;
    }
  },

  get documentIsActive() {
    return document.visibilityState == "visible" || document.hasFocus()
  },
})

const clearNameListElement = () => {
  const nameListElement = document.getElementById("name-list");
  nameListElement.innerHTML = "";
}

const setBoolIfNoUserName = (data) => {
  for (let i = 0; i < data.no_user_names.length; i++) {

    if (currentUser.id == data.no_user_names[i]) {
      currentUser.name = false;
      break;
    }
    else {
      currentUser.name = true;
    }
  }
}

const createUserBadges = (data) => {
  const nameListElement = document.getElementById("name-list");

  for (let i = 0; i < data.initials.length; i++) {
    let div = document.createElement("div");
    div.setAttribute("id", data.user_ids[i]);
    div.title = data.users[i];
    div.classList.add("flex", "flex-col", "justify-center", "items-center", "rounded-full", "h-12", "w-12", "m-4", "text-white", "text-2xl", "font-black", randomColorPicker());
    nameListElement.appendChild(div)
    let paragraph = document.createElement("P")
    div.appendChild(paragraph)
    let text = document.createTextNode(data.initials[i])
    paragraph.appendChild(text)
  };
}

const randomColorPicker = () => {
  let colorClasses = ["bg-purply", "bg-greeny", "bg-yellowy", "bg-reddy"];
  let randomColor = colorClasses[Math.floor(Math.random() * colorClasses.length)];
  return randomColor;
}