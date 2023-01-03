import consumer from "./consumer"

consumer.subscriptions.create({
  channel: "ProblemChannel", token: location.pathname.replace("/", "")
}, {
  received(data) {
    updateProblemBoxes(data.problem)
  },
})

const updateProblemBoxes = (updatedProblem) => {
  let problemBoxes = document.getElementsByClassName("problem")
  for (let problemBox of problemBoxes) {
    problemBox.textContent = updatedProblem
  }
}
