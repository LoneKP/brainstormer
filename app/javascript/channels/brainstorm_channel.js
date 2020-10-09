import consumer from "./consumer"

let timer;
let timerState;
const timerStartSeconds = 600;

consumer.subscriptions.create({
  channel: "BrainstormChannel", token: location.pathname.replace("/", "")
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
      case "transmit_list":
        if (typeof currentUser == "undefined") {
          location.reload();
        }
        setBoolIfNoUserName(data);
        clearNameListElement();
        createUserBadges(data);
        openModalToSetName();
        showCurrentUser();
        evaluateTimer(data);
        formatTime();
        setStateOfTimerButton();
        if (data.users.length > 7) { removeOverflowingUsers(data.users.length) };
        break;
      case "name_changed":
        this.perform("update_name");
        setCurrentUserName(data.name);
        break;
      case "start_timer":
        timerState.status = "running"
        startTimer();
        break;
      case "reset_timer":
        timerState.status = "readyToStart"
        resetTimer();
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

const evaluateTimer = (data) => {
  if (data.timer_status == "ready_to_start_timer") {
    timerState = {
      status: "readyToStart",
      secondsTotal: timerStartSeconds
    }
  }
  else if (data.timer_status == "time_has_run_out") {
    timerState = {
      status: "timeElapsed",
      secondsTotal: 0
    }
    clearInterval(timer);
  }
  else if (data.timer_status > 0 && data.timer_status < timerStartSeconds) {
    clearInterval(timer);
    timerState = {
      status: "running",
      secondsTotal: timerStartSeconds - data.timer_status
    }
    startTimer();
  }
  else {
    resetTimer();
  }
}

const startTimer = () => {
  document.getElementById("startTimer").textContent = "Reset timer"
  timer = setInterval(countDown, 1000);
}

const resetTimer = () => {
  clearInterval(timer);
  timerState = { status: "readyToStart", secondsTotal: timerStartSeconds };
  formatTime();
  document.getElementById("startTimer").textContent = "Start timer"
}

const setStateOfTimerButton = () => {
  switch (timerState.status) {
    case "timeElapsed":
      document.getElementById("startTimer").textContent = "Reset timer"
      break;
    case "readyToStart":
      document.getElementById("startTimer").textContent = "Start timer"
      break;
    case "running":
      document.getElementById("startTimer").textContent = "Reset timer"
      break;
  }
}

const formatTime = () => {
  let timeLeftSeconds = timerState.secondsTotal % 60;
  let timeLeftSecondsInMinutes = (timerState.secondsTotal - timeLeftSeconds) / 60;
  let timeLeftMinutes = timeLeftSecondsInMinutes % 60;
  let formattedTimeLeftMinutes = ("0" + timeLeftMinutes).slice(-2);
  let formattedTimeLeftSeconds = ("0" + timeLeftSeconds).slice(-2);
  timeDisplay.textContent = `${formattedTimeLeftMinutes}:${formattedTimeLeftSeconds}`;
  let timerOnMobile = document.getElementById("timerPhoneElement")
  if (timerState.status == "running") {
    if (timerOnMobile.classList.contains("bg-blurple") == false) {
      timerOnMobile.classList.add("bg-blurple")
    }
    timerOnMobile.setAttribute("style", `width: ${100 - timerState.secondsTotal / timerStartSeconds * 100}%`)
  }
  else if (timerState.status == "readyToStart") {
    timerOnMobile.classList.remove("bg-blurple")
  }
  else if (timerState.status == "timeElapsed") {
    timerOnMobile.classList.remove("bg-blurple")
  }

}

const countDown = () => {
  timerState.secondsTotal--;
  formatTime();
  if (timerState.secondsTotal <= 0) {
    clearInterval(timer);
    timerState.status = "timeElapsed";
    console.log("time is up");
    document.getElementById("modalContainer").setAttribute("x-data", "{ 'timeIsUpModal': true }")
  }
}