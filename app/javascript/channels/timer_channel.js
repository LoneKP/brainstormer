import consumer from "./consumer"

let timer;
let timerState;
let brainstormDuration;


consumer.subscriptions.create({
  channel: "TimerChannel", token: location.pathname.replace("/", "")
}, {
  received(data) {
    console.log(data)
    switch (data.event) {
      case "transmit_timer_status":
        evaluateTimer(data);
        formatTime();
        setStateOfTimerButton();
        brainstormDuration = data.brainstorm_duration
        break;
      case "start_timer":
        if (data.brainstorm_duration !== "already_set") {
          timerState.timeLeftSecondsTotal = data.brainstorm_duration
          brainstormDuration = data.brainstorm_duration
        }
        formatTime();
        timerState.status = "running"
        startTimer();
        break;
      case "reset_timer":
        brainstormDuration = data.brainstorm_duration
        timerState.status = "readyToStart"
        resetTimer(data);
        break;
    }
  },
})

const evaluateTimer = (data) => {
  if (data.timer_status == "ready_to_start_timer") {
    timerState = {
      status: "readyToStart",
      timeLeftSecondsTotal: data.brainstorm_duration
    }
  }
  else if (data.timer_status == "time_has_run_out") {
    timerState = {
      status: "timeElapsed",
      timeLeftSecondsTotal: 0
    }
    clearInterval(timer);
  }
  else if (data.timer_status > 0 && data.timer_status < data.brainstorm_duration) {
    clearInterval(timer);
    timerState = {
      status: "running",
      timeLeftSecondsTotal: data.brainstorm_duration - data.timer_status
    }
    startTimer();
  }
  else {
    resetTimer();
  }
}

const startTimer = () => {
  if (document.getElementById("startTimer")) {
    document.getElementById("startTimer").textContent = "Reset timer"
  }
  timer = setInterval(countDown, 1000);
}

const resetTimer = (data) => {
  clearInterval(timer);
  timerState = { status: "readyToStart", timeLeftSecondsTotal: data.brainstorm_duration };
  formatTime();
  if (document.getElementById("startTimer")) {
    document.getElementById("startTimer").textContent = "Start timer"
  }
}

const setStateOfTimerButton = () => {
  if (document.getElementById("startTimer")) {
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
}

const formatTime = () => {
  let timeLeftSeconds = timerState.timeLeftSecondsTotal % 60;
  let timeLeftSecondsInMinutes = (timerState.timeLeftSecondsTotal - timeLeftSeconds) / 60;
  let timeLeftMinutes = timeLeftSecondsInMinutes % 60;
  let formattedTimeLeftMinutes = ("0" + timeLeftMinutes).slice(-2);
  let formattedTimeLeftSeconds = ("0" + timeLeftSeconds).slice(-2);
  timeDisplay.textContent = `${formattedTimeLeftMinutes}:${formattedTimeLeftSeconds}`;
  let timerOnMobile = document.getElementById("timerPhoneElement")
  if (timerState.status == "running") {
    if (timerOnMobile.classList.contains("bg-blurple") == false) {
      timerOnMobile.classList.add("bg-blurple")
    }
    timerOnMobile.setAttribute("style", `width: ${100 - timerState.timeLeftSecondsTotal / brainstormDuration * 100}%`)
  }
  else if (timerState.status == "readyToStart") {
    timerOnMobile.classList.remove("bg-blurple")
  }
  else if (timerState.status == "timeElapsed") {
    timerOnMobile.classList.remove("bg-blurple")
  }
}

const countDown = () => {
  timerState.timeLeftSecondsTotal--;
  formatTime();
  if (timerState.timeLeftSecondsTotal <= 0) {
    clearInterval(timer);
    timerState.status = "timeElapsed";
    document.getElementById("timerPhoneElement").classList.remove("bg-blurple")
    setAndChangeBrainstormState("vote");
    showTimeIsUpModal()
  }
}