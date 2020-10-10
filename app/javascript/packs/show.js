const toggleHeart = (id) => {
  if (document.getElementById(id).classList.contains("heart-gray")) {
    document.getElementById(id).classList.add("heart-red")
    document.getElementById(id).classList.remove("heart-gray")
  } else {
    document.getElementById(id).classList.add("heart-gray")
    document.getElementById(id).classList.remove("heart-red")
  }
}

const p = document.getElementById("characterCount");
const inputField = document.getElementById("idea_text");
const maxCharacters = 110
inputField.maxLength = maxCharacters

document.getElementById("addIdeaButton").addEventListener(
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