import consumer from "./consumer"

class Timer {
  static duration = 0
  static secondsLeft = null
  static ticking = null

  get isRunning() { return this.secondsLeft > 0 }

  start() {
    this.ticking = setInterval(countDown, 1000)
  }

  stop() {
    clearInterval(this.ticking)
    this.ticking = null
  }


  formattedTimeLeft() {
    const secondsLeft = this.secondsLeft % 60
    const minutesLeftInSeconds = (this.secondsLeft - secondsLeft) / 60
    const minutesLeft = minutesLeftInSeconds % 60
    return `${withLeadingZeros(minutesLeft)}:${withLeadingZeros(secondsLeft)}`
  }

  reset() {
    this.stop()
    this.secondsLeft = this.duration
  }
}

const withLeadingZeros = (unit) => ("0" + unit).slice(-2)

let timer = new Timer()

consumer.subscriptions.create({
  channel: "TimerChannel", token: location.pathname.replace("/", "")
}, {
  received(data) {
    timer.duration = data.brainstorm_duration

    if (data.event == "transmit_timer_status") {
      evaluateTimer(data)
      formatTime()
    } else if (data.event == "start_timer") {
      timer.reset()

      formatTime()
      timer.start()
    } else if (data.event == "reset_timer") {
      resetTimer()
    }
  },
})

const evaluateTimer = (data) => {
  if (data.timer_status == "ready_to_start_timer") {
  } else if (data.timer_status == "time_has_run_out") {
    timer.secondsLeft = 0
    timer.stop()
  }
  else if (data.timer_status > 0 && data.timer_status < data.brainstorm_duration) {
    timer.stop()
    timer.secondsLeft = data.brainstorm_duration - data.timer_status
    timer.start()
  }
  else {
    resetTimer();
  }
}

const resetTimer = () => {
  timer.reset()
  formatTime()
}

const formatTime = () => {
  timeDisplay.textContent = timer.formattedTimeLeft()

  let timerOnMobile = document.getElementById("timerPhoneElement")
  timerOnMobile.classList.toggle("bg-blurple", timer.isRunning)
  if (timer.isRunning) timerOnMobile.setAttribute("style", `width: ${100 - timer.secondsLeft / timer.duration * 100}%`)
}

const countDown = () => {
  timer.secondsLeft--;
  formatTime();
  if (timer.secondsLeft <= 0) {
    timer.stop()
    document.getElementById("timerPhoneElement").classList.remove("bg-blurple")
    setAndChangeBrainstormState("vote");
    showTimeIsUpModal()
  }
}
