let stateConfiguration = {
  setup: {
    setup: true,
    setup_facilitator: false,
    setup_participant: false,
    ideation: false,
    vote: false,
    voting_done: false
  },
  ideation: {
    setup: false,
    setup_facilitator: false,
    setup_participant: false,
    ideation: true,
    vote: false,
    voting_done: false
  },
  vote: {
    setup: false,
    setup_facilitator: false,
    setup_participant: false,
    ideation: false,
    vote: true,
    voting_done: false
  },
  voting_done: {
    setup: false,
    setup_facilitator: false,
    setup_participant: false,
    ideation: false,
    vote: false,
    voting_done: true
  }
}

window.changeView = function (state) {
  let configuration = stateConfiguration[state]
  for (const [key, value] of Object.entries(configuration)) {
    document.getElementById(key).style.display = value ? 'block' : 'none';
  }

  if (typeof brainstormStore.state === 'undefined' || brainstormStore.state === 'setup') {

    document.querySelector("#setup_participant").style.display = currentUser.facilitator == "false" ? "block" : "none"
    document.querySelector("#setup_facilitator").style.display = currentUser.facilitator == "true" ? "block" : "none"
  }
}

window.showTimeIsUpModal = function () {
  document.getElementById("time_is_up").classList.remove("hidden");
}

window.fillStarsWithUserVotes = function () {
  currentUser.votesCastIdeas.forEach((id) => {
    let elements = document.getElementsByClassName(`star-idea-${id}`)
    Array.from(elements).forEach((element) => element.setAttribute("fill", "#312783"))
  })

  let votesUsed = currentUser.votesCastIdeas.size
  let stars = document.getElementsByClassName("starVoteFill")
  
  for (let i = 0; i < votesUsed; i++) {
    stars[i].setAttribute("fill", "312783")
  }
}

window.updateFacilitatorSpecificElementsOnIdeas = function () {
  if (currentUser.facilitator == "false") {
    let toggleIdeaMenuButtonElements = document.getElementsByClassName("toggleIdeaMenuButton");

    for (let toggleIdeaMenuButtonElement of toggleIdeaMenuButtonElements) {
      toggleIdeaMenuButtonElement.classList.add("hidden");
    }
  }
}

window.changeHeadlineAccordingToVotesLeft = function (votesCast, maxVotesPerUser) {
  if (votesCast >= maxVotesPerUser) {
    document.getElementById("votingHeadline").textContent = "No votes left!"
  }
  else if (votesCast < maxVotesPerUser) {
    document.getElementById("votingHeadline").textContent = "Vote on your favourite ideas"
  }
}

window.setAndChangeBrainstormState = function (state) {
  brainstormStore.state = state;
  changeView(state);
}

window.removeNameListUserIdIfUserIsFacilitator = function () {
  if (currentUser.facilitator == "true") {
    let userNameElement = document.getElementById(`name-list-user-id-${currentUser.visitorId}`);
    userNameElement.remove();
  }
}
