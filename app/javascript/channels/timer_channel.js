import consumer from "./consumer"

class Timer {
  static duration = 0
  static secondsLeft = null

  get isReady() { return !this.secondsLeft || this.secondsLeft == this.duration }
  get isRunning() { return this.secondsLeft > 0 }
}

let timer = new Timer()
let timerTick
let timerState

consumer.subscriptions.create({
  channel: "TimerChannel", token: location.pathname.replace("/", "")
}, {
  received(data) {
    timer.duration = data.brainstorm_duration

    if (data.event == "transmit_timer_status") {
      evaluateTimer(data)
      formatTime()
    } else if (data.event == "start_timer") {
      timer.secondsLeft = timer.duration

      formatTime()
      startTimer()
    } else if (data.event == "reset_timer") {
      resetTimer()
    }
  },
})

const evaluateTimer = (data) => {
  if (data.timer_status == "ready_to_start_timer") {
  } else if (data.timer_status == "time_has_run_out") {
    timer.secondsLeft = 0
    timerState = {
      status: "timeElapsed"
    }
    clearInterval(timerTick)
  }
  else if (data.timer_status > 0 && data.timer_status < data.brainstorm_duration) {
    clearInterval(timerTick)
    timer.secondsLeft = data.brainstorm_duration - data.timer_status
    startTimer()
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
  timer.secondsLeft = timer.duration
  formatTime()
}

const formatTime = () => {
  let timeLeftSeconds = timer.secondsLeft % 60;
  let timeLeftSecondsInMinutes = (timer.secondsLeft - timeLeftSeconds) / 60;
  let timeLeftMinutes = timeLeftSecondsInMinutes % 60;
  let formattedTimeLeftMinutes = ("0" + timeLeftMinutes).slice(-2);
  let formattedTimeLeftSeconds = ("0" + timeLeftSeconds).slice(-2);
  timeDisplay.textContent = `${formattedTimeLeftMinutes}:${formattedTimeLeftSeconds}`;
  let timerOnMobile = document.getElementById("timerPhoneElement")
  if (timer.isRunning) {
    if (timerOnMobile.classList.contains("bg-blurple") == false) {
      timerOnMobile.classList.add("bg-blurple")
    }
    timerOnMobile.setAttribute("style", `width: ${100 - timer.secondsLeft / timer.duration * 100}%`)
  }
  else if (timer.isReady) {
    timerOnMobile.classList.remove("bg-blurple")
  }
  else if (timerState.status == "timeElapsed") {
    timerOnMobile.classList.remove("bg-blurple")
  }
}

const countDown = () => {
  timer.secondsLeft--;
  formatTime();
  if (timer.secondsLeft <= 0) {
    clearInterval(timerTick)
    timerState.status = "timeElapsed";
    document.getElementById("timerPhoneElement").classList.remove("bg-blurple")
    setAndChangeBrainstormState("vote");
    showTimeIsUpModal()
  }
}
