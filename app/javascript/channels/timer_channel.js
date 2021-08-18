import consumer from "./consumer"

class Timer {
  get isRunning() { return this.ticking }

  get percentage() {
    return 100 - (this.secondsLeft / this.duration * 100)
  }

  get secondsLeft() { return this.secondsLeftValue }
  set secondsLeft(secondsLeft) {
    this.secondsLeftValue = secondsLeft
    this.render()
  }

  start() {
    this.ticking = setInterval(this.tick.bind(this), 1000)
  }

  stop() {
    clearInterval(this.ticking)
    this.ticking = null
  }

  reset() {
    this.stop()
    this.secondsLeft = this.duration
  }

  tick() {
    this.secondsLeft--
    if (this.secondsLeft <= 0) {
      this.stop()
      showTimeIsUpModal()
    }
  }

  render() {
    this.element.textContent = this.formattedTimeLeft()
    updateMobilePhoneProgress()
  }

  formattedTimeLeft() {
    const secondsLeft = this.secondsLeft % 60
    const minutesLeftInSeconds = (this.secondsLeft - secondsLeft) / 60
    const minutesLeft = minutesLeftInSeconds % 60
    return `${withLeadingZeros(minutesLeft)}:${withLeadingZeros(secondsLeft)}`
  }
}

const withLeadingZeros = (unit) => ("0" + unit).slice(-2)

window.timer = new Timer()

consumer.subscriptions.create({
  channel: "TimerChannel", token: location.pathname.replace("/", "")
}, {
  received(data) {
    if (data.event == "start") {
      timer.reset()
      timer.start()
    } else if (data.event == "reset") {
      timer.reset()
    }
  },
})

const updateMobilePhoneProgress = () => {
  let timerOnMobile = document.getElementById("timerPhoneElement")
  timerOnMobile.classList.toggle("bg-blurple", timer.isRunning)
  if (timer.isRunning) timerOnMobile.setAttribute("style", `width: ${timer.percentage}%`)
}
