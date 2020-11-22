import consumer from "./consumer"

let timer;
let timerState;
const timerStartSeconds = 600;


consumer.subscriptions.create({
  channel: "TimerChannel", token: location.pathname.replace("/", "")
}, {
  received(data) {
    console.log(data)
    switch (data.event) {
      case "transmit_timer_status":
        evaluateTimer(data);
        formatTime();
        setStateOfTimerButton();;
        break;
      case "start_timer":
        timerState.status = "running"
        startTimer();
        break;
      case "reset_timer":
        timerState.status = "readyToStart"
        resetTimer();
        break;
      case "set_brainstorm_state":
        setBrainstormState(data.state);
    }
  },
})

const setBrainstormState = (state) => {
  brainstormStore.state = state;
  changeView(state);
  if (state == "vote" || state == "voting_done") {
    location.reload();
  }
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
    setBrainstormState("time_is_up");
  }
}