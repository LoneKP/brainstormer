import consumer from "./consumer"

const THRESHOLD_FOR_OVERFLOWING_USERS = 9

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
    switch (data.event) {
      case "transmit_presence_list":
        console.log("presence list:", data)
        const onlineUsers = Object.values(data.online_users)
        if (typeof currentUser == "undefined") {
          location.reload();
        }
        if (brainstormStore.state == "setup") {
          clearListOfParticipants();
          HideOrShowListOfParticipantsContainer(onlineUsers);
          createListOfParticipants(onlineUsers);
          if (currentUser.facilitator == "true") { removeNameListUserIdIfUserIsFacilitator() };
        }

        if (brainstormStore.state == "vote" && currentUser.facilitator == "true") {
          let usersDoneVotingCount = onlineUsers.reduce((counter, {doneVoting}) => doneVoting === "true" ? counter += 1 : counter, 0);
          updateNumberOfUsersDoneVotingElement(onlineUsers.length, usersDoneVotingCount);
        }

        clearNameListElement();
        createUserBadges(onlineUsers);
        showCurrentUser();
        if (onlineUsers.length > THRESHOLD_FOR_OVERFLOWING_USERS) { 
          removeOverflowingUsers(onlineUsers) 
          listNumberOfOverflowingUsers(onlineUsers)
          moveDoneDivContainerOneStepRight()
          showOnHoverForOverflowingUsers(onlineUsers)
        };
        if (brainstormStore.state !== "vote") { removeUsersDoneVoting(onlineUsers) };
        break;
      case "toggle_done_voting_badge":
        toggleUserDoneVoting(data.user_id);
        break;
      case "update_number_of_users_done_voting_element":
        if (currentUser.facilitator == "true") {
          updateNumberOfUsersDoneVotingElement(data.total_users_online, data.users_done_voting);
        }
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

const HideOrShowListOfParticipantsContainer = (onlineUsers) => {
  let listOfParticipantsContainer = document.getElementById("list-of-participants-container")
  if (onlineUsers.length > 1) {
    listOfParticipantsContainer.classList.remove("hidden");
  }
  else {
    listOfParticipantsContainer.classList.add("hidden");
  } 
}

const createListOfParticipants = (onlineUsers) => {
  for (const onlineUser of onlineUsers) {
    let nameDiv = document.createElement("div");
    nameDiv.innerHTML = onlineUser.name;
    nameDiv.classList.add("flex", "py-2", "px-2", `${onlineUser.userColor}`);
    nameDiv.setAttribute("id", `name-list-user-id-${onlineUser.id}`);
    document.getElementById("list-of-participants").appendChild(nameDiv)
  }
}

const createUserBadges = (onlineUsers) => {
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

  for (const onlineUser of onlineUsers) {
    let userBadge = document.createElement("user-badge");
    userBadge.setAttribute("id", onlineUser.id);
    userBadge.classList.add("cursor-default");
    nameListElement.appendChild(userBadge)
    let text = document.createTextNode(onlineUser.initials)
    userBadge.firstChild.append(text)
    userBadge.firstChild.classList.add(onlineUser.userColor)
    
    let fullName = document.createElement("div");
    fullName.classList.add("text-white", "text-lg", "absolute", "mt-2", "my-shadow", "px-2", "hidden", `${onlineUser.userColor}`);
    fullName.innerHTML = `${onlineUser.name}`;

    userBadge.appendChild(fullName);

    showOnHover(userBadge, fullName);

    let doneDiv = document.createElement("div");
    doneDiv.innerHTML = "DONE"
    doneDiv.setAttribute("id", `user-done-${onlineUser.id}`);
    doneDiv.classList.add("w-12", "mx-4", "text-center", "font-bold", "bg-yellowy", "text-white", "mt-2", "text-sm", "my-shadow")
    if (onlineUser.doneVoting == "false" || onlineUser.doneVoting == null) {
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
  if (document.getElementById(`user-done-${userId}`) !== null){
    document.getElementById(`user-done-${userId}`).classList.toggle("invisible");
  }
}

const removeUsersDoneVoting = (onlineUsers) => {
  for (const onlineUser of onlineUsers) {
    if (document.getElementById(`user-done-${onlineUser.id}`) !== null ) {
      document.getElementById(`user-done-${onlineUser.id}`).classList.add("invisible");
    }
  }
}

const removeOverflowingUsers = (onlineUsers) => {
  for (let i = 0; i < onlineUsers.length - THRESHOLD_FOR_OVERFLOWING_USERS; i++) {
    document.getElementById("name-list").removeChild(document.getElementById("name-list").childNodes[i]);
    document.getElementById("doneDivContainer").removeChild(document.getElementById("doneDivContainer").childNodes[i]);
  }
}

const listNumberOfOverflowingUsers = (onlineUsers) => {
  let numberOfOverflowingUsersContainer = document.createElement("user-badge");
  numberOfOverflowingUsersContainer.setAttribute("id", "overflowingUsers");
  numberOfOverflowingUsersContainer.classList.add("cursor-default");
  document.getElementById("name-list").prepend(numberOfOverflowingUsersContainer);
  numberOfOverflowingUsersContainer.firstChild.classList.remove("text-white")
  numberOfOverflowingUsersContainer.firstChild.classList.add("border-2", "border-solid", "border-black", "text-black")
  
  let paragraph = document.createElement("P");
  let text = document.createTextNode("+" + (onlineUsers.length - THRESHOLD_FOR_OVERFLOWING_USERS));
  paragraph.appendChild(text);
  numberOfOverflowingUsersContainer.firstChild.append(paragraph)
}

const moveDoneDivContainerOneStepRight = () => {
  let doneDivPlaceholder = document.createElement("div");
  doneDivPlaceholder.classList.add("w-12", "mx-4", "mt-2", "invisible");
  document.getElementById("doneDivContainer").prepend(doneDivPlaceholder);
}

const showOnHoverForOverflowingUsers = (onlineUsers) => {
  const shownUserIds = new Set(shownUsersIds());

  let overflowingUsers = []

  for(const onlineUser of onlineUsers) {
      if(!shownUserIds.has(onlineUser.id))
      {
        overflowingUsers.push(onlineUser)
      }
  }
  nameElementsForOverflowingUsers(overflowingUsers)
}

const nameElementsForOverflowingUsers = (overflowingUsers) => {

  let fullNameContainer = document.createElement("div");
  fullNameContainer.classList.add("absolute", "mt-1");
  const overflowingUsersContainer = document.getElementById("overflowingUsers")
  overflowingUsersContainer.append(fullNameContainer);
  
  for (let i = 0; i < overflowingUsers.length; i++) {
    let fullName = document.createElement("div");
    fullName.classList.add("text-white", "mt-1", "text-lg", "my-shadow", "hidden", "px-2", `${overflowingUsers[i].userColor}`);
    fullName.innerHTML = `${overflowingUsers[i].name}`;

    fullNameContainer.append(fullName);

    showOnHover(overflowingUsersContainer, fullName);
  }
}
  
const shownUsersIds = () => {
  let userIds = []
  let elements = document.getElementById("name-list").childNodes
  let arrOfShownUsers = Array.from(elements).slice(1)
  for (let i = 0; i < arrOfShownUsers.length; i++) {
    userIds.push(arrOfShownUsers[i].id)
  }
  return userIds
}

const updateNumberOfUsersDoneVotingElement = (totalUsersOnline, usersDoneVoting) => {
  let el = document.getElementById("number-of-users-done-voting-element");
  el.innerHTML = `${usersDoneVoting}/${totalUsersOnline} participants are done voting`
}