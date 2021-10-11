changeView(brainstormStore.state);
fillStarsWithUserVotes();
changeHeadlineAccordingToVotesLeft(currentUser.votesCastIdeas.length + currentUser.votesCastIdeaBuilds.length, brainstormStore.maxVotesPerUser )

// These could be summed up in a single "copy()" function
// that accepts the relevant element id and the value as arguments
const copyAction = (value) => {
  let tempInput = document.createElement("input");
  tempInput.style = "position: absolute; left: -1000px; top: -1000px";
  tempInput.value = value;
  document.body.appendChild(tempInput);
  tempInput.select();
  document.execCommand("copy");
  document.body.removeChild(tempInput);
  let tooltip = document.getElementById("myTooltip");
  tooltip.innerHTML = "Copied!";
}

const copyToken = (value) => {
  let tempInput = document.createElement("input");
  tempInput.style = "position: absolute; left: -1000px; top: -1000px";
  tempInput.value = value;
  document.body.appendChild(tempInput);
  tempInput.select();
  document.execCommand("copy");
  document.body.removeChild(tempInput);
  let tooltip = document.getElementById("tooltipToken");
  tooltip.innerHTML = "Copied!";
}

const getURL = () => {
  return window.location.href;
}

const getToken = () => {
  return window.location.pathname.replace("/", "")
}

const outFunc = () => {
  var tooltip = document.getElementById("myTooltip");
  tooltip.innerHTML = "Copy to clipboard";
}

const tokenOutFunc = () => {
  var tooltip = document.getElementById("tooltipToken");
  tooltip.innerHTML = "Copy to clipboard";
}