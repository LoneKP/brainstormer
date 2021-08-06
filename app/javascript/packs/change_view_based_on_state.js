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

changeView = function (state) {
  configuration = stateConfiguration[state]
  for (const [key, value] of Object.entries(configuration)) {
    document.getElementById(key).style.display = value ? 'block' : 'none';
  }

  if (typeof brainstormStore.state === 'undefined' || brainstormStore.state === 'setup') {

    document.querySelector("#setup_participant").style.display = currentUser.facilitator == "false" ? "block" : "none"
    document.querySelector("#setup_facilitator").style.display = currentUser.facilitator == "true" ? "block" : "none"
  }

  if (state == "voting_done") {
    document.getElementById("notice").innerHTML = '<div class="bg-greeny fade-out inset-x-0 fixed text-white text-center py-4 z-50 font-bold my-shadow"><span>Voting is done! Now you can review all your great ideas.</span></div>'
  }
}

showTimeIsUpModal = function () {
  console.log("SHOW TIME IS UP MODAL")
  document.getElementById("time_is_up").classList.remove("hidden");
}

fillStarsWithUserVotes = function () {
  currentUser.votesCastIdeas.forEach((id) => {
    let elements = document.getElementsByClassName(`star-idea-${id}`)
    Array.from(elements).forEach((element) => element.setAttribute("fill", "#312783"))
  })

  for (i = 0; i < currentUser.votesCastIdeaBuilds.length; i++) {
    let elems = document.getElementsByClassName(`star-idea-build-${currentUser.votesCastIdeaBuilds[i]}`);
    for (x = 0; x < elems.length; x++) {
      elems[x].setAttribute("fill", "#312783");
    }
  };
}

changeHeadlineAccordingToVotesLeft = function (votesCast, maxVotesPerUser) {
  if (votesCast >= maxVotesPerUser) {
    document.getElementById("votingHeadline").textContent = "No votes left!"
  }
  else if (votesCast < maxVotesPerUser) {
    document.getElementById("votingHeadline").textContent = "Vote on your favourite ideas"
  }
}

setAndChangeBrainstormState = function (state) {
  console.log("state is now: ", state)
  brainstormStore.state = state;
  changeView(state);
}

removeNameListUserIdIfUserIsFacilitator = function () {
  if (currentUser.facilitator == "true") {
    let userNameElement = document.getElementById(`name-list-user-id-${currentUser.id}`);
    userNameElement.remove();
  }
}
