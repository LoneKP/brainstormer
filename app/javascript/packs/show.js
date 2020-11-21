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
    console.log('Element', key, 'is', value ? 'block' : 'none')
  }
}

changeView(brainstormStore.state)

if (typeof brainstormStore.state === 'undefined' || brainstormStore.state === 'setup') {

  console.log('State: ', brainstormStore.state)
  console.log('Setup participant div', document.querySelector("#setup_participant"))
  console.log('Setup facilitator div', document.querySelector("#setup_facilitator"))

  document.querySelector("#setup_participant").style.display = currentUser.facilitator == "true" ? "none" : "block"
  document.querySelector("#setup_facilitator").style.display = currentUser.facilitator == "true" ? "block" : "none"

  console.log('Setup participant div after logic', document.querySelector("#setup_participant"))
  console.log('Setup facilitator div after logic', document.querySelector("#setup_facilitator"))
}

for (i = 0; i < JSON.parse(currentUser.votesCastIdeas).length; i++) {
  document.getElementById(`star-idea-${JSON.parse(currentUser.votesCastIdeas)[i]}`).setAttribute("fill", "#312783");
};

for (i = 0; i < JSON.parse(currentUser.votesCastIdeaBuilds).length; i++) {
  document.getElementById(`star-idea-build-${JSON.parse(currentUser.votesCastIdeaBuilds)[i]}`).setAttribute("fill", "#312783");
};

const p = document.getElementById("characterCountIdea");
const inputField = document.getElementById("idea_text");
const maxCharacters = 110
inputField.maxLength = maxCharacters

document.getElementById("addIdeaPin").addEventListener(
  "click",
  function () {
    p.innerHTML = inputField.value.length + "/" + maxCharacters
    p.classList.remove("text-red-400")
    p.textContent = "0" + "/" + maxCharacters
  }
)

p.innerHTML = inputField.value.length + "/" + maxCharacters

inputField.addEventListener(
  "input",
  function () {
    p.textContent = inputField.value.length + "/" + maxCharacters
    if (inputField.value.length >= maxCharacters - 2) {
      p.classList.add("text-red-400")
    } else if (inputField.value.length <= maxCharacters - 2) {
      p.classList.remove("text-red-400")
    }
  }
);

// This could be enclosed in it's own function
// Something like an Idea object with a validate() method
// that accepts the inputField.value.lenght as argument
inputField.addEventListener(
  "keyup",
  function () {
    if (inputField.value.length > 0) {
      document.getElementById("addIdeaPin").classList.add("bg-post-it-yellowy");
      document.getElementById("addIdeaPin").classList.remove("bg-lighter-gray");
      document.getElementById("addIdeaPin").firstElementChild.style.fill = "#312783";
    }
    else if (inputField.value.length == 0) {
      document.getElementById("addIdeaPin").classList.remove("bg-post-it-yellowy");
      document.getElementById("addIdeaPin").classList.add("bg-lighter-gray");
      document.getElementById("addIdeaPin").firstElementChild.style.fill = "white";
    }
  }
)

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