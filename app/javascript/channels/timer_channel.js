import consumer from "./consumer"

let timer
let timerTick
let timerState
let brainstormDuration


consumer.subscriptions.create({
  channel: "TimerChannel", token: location.pathname.replace("/", "")
}, {
  received(data) {
    brainstormDuration = data.brainstorm_duration

    if (data.event == "transmit_timer_status") {
      evaluateTimer(data)
      formatTime()
    } else if (data.event == "start_timer") {
      timerState.timeLeftSecondsTotal = brainstormDuration

      formatTime()
      timerState.status = "running"
      startTimer()
    } else if (data.event == "reset_timer") {
      timerState.status = "ready"
      resetTimer()
    }
  },
})

const evaluateTimer = (data) => {
  if (data.timer_status == "ready_to_start_timer") {
    timerState = {
      status: "ready",
      timeLeftSecondsTotal: data.brainstorm_duration
    }
  }
  else if (data.timer_status == "time_has_run_out") {
    timerState = {
      status: "timeElapsed",
      timeLeftSecondsTotal: 0
    }
    clearInterval(timerTick)
  }
  else if (data.timer_status > 0 && data.timer_status < data.brainstorm_duration) {
    clearInterval(timerTick)
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
  timerTick = setInterval(countDown, 1000)
}

const resetTimer = () => {
  clearInterval(timerTick)
  timerState = { status: "ready", timeLeftSecondsTotal: brainstormDuration }
  formatTime()
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
  else if (timerState.status == "ready") {
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
    clearInterval(timerTick)
    timerState.status = "timeElapsed";
    document.getElementById("timerPhoneElement").classList.remove("bg-blurple")
    setAndChangeBrainstormState("vote");
    showTimeIsUpModal()
  }
}
