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
        if (brainstormStore.state == "setup") {
          clearListOfParticipants();
          HideOrShowListOfParticipantsContainer(data);
          createListOfParticipants(data);
          removeNameListUserIdIfUserIsFacilitator();
        }
        clearNameListElement();
        createUserBadges(data);
        openModalToSetName();
        showCurrentUser();
        if (data.users.length > 7) { removeOverflowingUsers(data.users.length) };
        if (brainstormStore.state !== "vote") { removeUsersDoneVoting(data.user_ids) };
        break;
      case "name_changed":
        this.perform("update_name");
        setCurrentUserName(data.name);
        break;
      case "done_voting":
        showUserDoneVoting(data.user_id);
        break;
      case "resume_voting":
        removeUserDoneVoting(data.user_id);
        break;
      case "remove_done_tags_on_user_badges":
        this.perform("update_name");
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

const clearListOfParticipants = () => {
  const listElement = document.getElementById("list-of-participants");
  listElement.innerHTML = "";
}

const HideOrShowListOfParticipantsContainer = (data) => {
  let listOfParticipantsContainer = document.getElementById("list-of-participants-container")
  if (data.users.length > 1) {
    listOfParticipantsContainer.classList.remove("hidden");
  }
  else {
    listOfParticipantsContainer.classList.add("hidden");
  } 
}

const createListOfParticipants = (data) => {
  for (let i = 0; i < data.users.length; i++) {
    let nameDiv = document.createElement("div");
    nameDiv.innerHTML = data.users[i];
    nameDiv.classList.add("flex", "py-2", "px-2", `${data.user_colors[i]}`);
    nameDiv.setAttribute("id", `name-list-user-id-${data.user_ids[i]}`);
    document.getElementById("list-of-participants").appendChild(nameDiv)
  }
}

const createUserBadges = (data) => {
  const nameListElement = document.getElementById("name-list");
  let nameListContainer = document.getElementById("name-list-container");
  let doneDivContainer;

  if (document.getElementById("doneDivContainer") == null) {
    doneDivContainer = document.createElement("div");
  }
  else {
    doneDivContainer = document.getElementById("doneDivContainer")
  }

  doneDivContainer.classList.add("flex")
  doneDivContainer.setAttribute("id", "doneDivContainer");

  doneDivContainer.innerHTML = '';

  for (let i = 0; i < data.initials.length; i++) {
    let userBadge = document.createElement("user-badge");
    userBadge.setAttribute("id", data.user_ids[i]);
    userBadge.classList.add("cursor-default");
    nameListElement.appendChild(userBadge)
    let text = document.createTextNode(data.initials[i])
    userBadge.firstChild.append(text)
    userBadge.firstChild.classList.add(data.user_colors[i])
    
    let fullName = document.createElement("div");
    fullName.classList.add("text-white", "text-lg", "absolute", "mt-2", "my-shadow", "px-2", "hidden", `${data.user_colors[i]}`);
    fullName.innerHTML = `${data.users[i]}`;

    userBadge.appendChild(fullName);

    showOnHover(userBadge, fullName);

    let doneDiv = document.createElement("div");
    doneDiv.innerHTML = "DONE"
    doneDiv.setAttribute("id", `user-done-${data.user_ids[i]}`);
    doneDiv.classList.add("w-12", "mx-4", "text-center", "font-bold", "bg-yellowy", "text-white", "mt-2", "text-sm", "my-shadow")
    if (data.done_voting_list[i] == "false" || data.done_voting_list[i] == null) {
      doneDiv.classList.add("invisible")
    }
    doneDivContainer.appendChild(doneDiv);
  };
  nameListContainer.appendChild(doneDivContainer)
}

const showOnHover = (hoverElement, showElement) => {
  hoverElement.addEventListener("mouseover",function (){
    showElement.classList.remove("hidden");
  });

  hoverElement.addEventListener("mouseout",function (){
    showElement.classList.add("hidden");  
  });
}

const showUserDoneVoting = (userId) => {
  document.getElementById(`user-done-${userId}`).classList.remove("invisible");
}

const removeUserDoneVoting = (userId) => {
  document.getElementById(`user-done-${userId}`).classList.add("invisible");
}

const removeUsersDoneVoting = (userIds) => {
  for (let i = 0; i < userIds.length; i++) {
    console.log(document.getElementById(`user-done-${userIds[i]}`))
    document.getElementById(`user-done-${userIds[i]}`).classList.add("invisible");
  }
}
