let stateConfiguration = {
  setup: {
    setup: true,
    setup_facilitator: false,
    setup_participant: false,
    ideation: false,
    time_is_up: false,
    vote: false,
    voting_done: false
  },
  ideation: {
    setup: false,
    setup_facilitator: false,
    setup_participant: false,
    ideation: true,
    time_is_up: false,
    vote: false,
    voting_done: false
  },
  time_is_up: {
    setup: false,
    setup_facilitator: false,
    setup_participant: false,
    ideation: false,
    time_is_up: true,
    vote: false,
    voting_done: false
  },
  vote: {
    setup: false,
    setup_facilitator: false,
    setup_participant: false,
    ideation: false,
    time_is_up: false,
    vote: true,
    voting_done: false
  },
  voting_done: {
    setup: false,
    setup_facilitator: false,
    setup_participant: false,
    ideation: false,
    time_is_up: false,
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
}

fillStarsWithUserVotes = function () {
  for (i = 0; i < currentUser.votesCastIdeas.length; i++) {
    let elems = document.getElementsByClassName(`star-idea-${currentUser.votesCastIdeas[i]}`);
    for (x = 0; x < elems.length; x++) {
      elems[x].setAttribute("fill", "#312783");
    }
  };
  
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