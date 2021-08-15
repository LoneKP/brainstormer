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
      case "toggle_voting":
        toggleUserDoneVoting(data.user_id);
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
  const nameListMobileElement = document.getElementById("name-list-mobile");
  nameListElement.innerHTML = "";
  nameListMobileElement.innerHTML = "";
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

const createUserBadgePhone = (data) => {
  const nameListElementMobile = document.getElementById("name-list-mobile");
  let userBadgeMobile = document.createElement("div");
  userBadgeMobile.classList.add("text-6xl", "font-black", "flex", "items-center");
  let svg = '<svg class="mr-2 h-full w-16" xmlns="http://www.w3.org/2000/svg" enable-background="new 0 0 24 24" height="24px" viewBox="0 0 24 24" width="24px" fill="#000000"><g><rect fill="none" height="24" width="24"/></g><g><g/><g><g><path d="M16.67,13.13C18.04,14.06,19,15.32,19,17v3h4v-3 C23,14.82,19.43,13.53,16.67,13.13z" fill-rule="evenodd"/></g><g><circle cx="9" cy="8" fill-rule="evenodd" r="4"/></g><g><path d="M15,12c2.21,0,4-1.79,4-4c0-2.21-1.79-4-4-4c-0.47,0-0.91,0.1-1.33,0.24 C14.5,5.27,15,6.58,15,8s-0.5,2.73-1.33,3.76C14.09,11.9,14.53,12,15,12z" fill-rule="evenodd"/></g><g><path d="M9,13c-2.67,0-8,1.34-8,4v3h16v-3C17,14.34,11.67,13,9,13z" fill-rule="evenodd"/></g></g></g></svg>'
  userBadgeMobile.innerHTML = svg + `<div>${data.initials.length}</div>` 
  nameListElementMobile.appendChild(userBadgeMobile);
}

const createUserBadges = (data) => {
  createUserBadgePhone(data);
  const nameListElement = document.getElementById("name-list");
  let nameListContainer = document.getElementById("name-list-container");
  let doneDivContainer;

  if (document.getElementById("doneDivContainer") == null) {
    doneDivContainer = document.createElement("div");
  }
  else {
    doneDivContainer = document.getElementById("doneDivContainer")
  }

  doneDivContainer.classList.add("lg:flex", "hidden")
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

const toggleUserDoneVoting = (userId) => {
  if ( document.getElementById(`user-done-${userId}`).classList.contains("invisible") ) {
    document.getElementById(`user-done-${userId}`).classList.remove("invisible")
  } 
  else {
    document.getElementById(`user-done-${userId}`).classList.add("invisible");
  }
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
