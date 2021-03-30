changeView(brainstormStore.state);
fillStarsWithUserVotes();
changeHeadlineAccordingToVotesLeft(currentUser.votesCastIdeas.length + currentUser.votesCastIdeaBuilds.length, brainstormStore.maxVotesPerUser )

const removeOverflowingUsers = (onlineUsers) => {
  for (let i = 0; i < onlineUsers - 7; i++) {
    document.getElementById("name-list").removeChild(document.getElementById("name-list").childNodes[i]);
  }
  let div = document.createElement("div");
  div.classList.add("flex", "flex-col", "justify-center", "items-center", "rounded-full", "h-12", "w-12", "m-4", "text-black", "text-2xl", "border-2", "border-solid", "border-black", "font-bold");
  document.getElementById("name-list").prepend(div);
  let paragraph = document.createElement("P");
  div.appendChild(paragraph);
  let text = document.createTextNode("+" + (onlineUsers - 7));
  paragraph.appendChild(text);
}

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