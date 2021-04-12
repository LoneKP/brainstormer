window.addEventListenerToIdeaPin = function (pinElement, inputField, maxCharacters, countText) {
  const p = countText
  pinElement.addEventListener(
    "click",
    function () {
      p.innerHTML = inputField.value.length + "/" + maxCharacters
      p.classList.remove("text-red-400")
      p.textContent = "0" + "/" + maxCharacters
    }
  )
};

window.addEventListenerToInputField = function (inputField, countText, maxCharacters) {
  const p = countText
  inputField.addEventListener(
    "input",
    function () {
      p.textContent = inputField.value.length + "/" + maxCharacters
      if (inputField.value.length >= maxCharacters - 2) {
        p.classList.add("text-red-400");
      } else if (inputField.value.length <= maxCharacters - 2) {
        p.classList.remove("text-red-400");
      }
    }
  );
};

setMaxCharacters = (inputField, maxCharacters) => {
  inputField.maxLength = maxCharacters
}

setInnerHTMLOfCountText = (inputField, maxCharacters, countText) => {
  const p = countText
  p.innerHTML = inputField.value.length + "/" + maxCharacters
};

colorPinOnTyping = (pinElement, inputField) => {
  inputField.addEventListener(
    "keyup",
    function () {
      if (inputField.value.length > 0) {
        addColorToPin(pinElement)
      } else if (inputField.value.length == 0) {
        removeColorFromPin(pinElement)
      }
    }
  )
};

addColorToPin = (pinElement) => {
  pinElement.classList.add("bg-post-it-yellowy", "hover:bg-post-it-yellowy-dark");
  pinElement.classList.remove("bg-lighter-gray");
  pinElement.firstElementChild.style.fill = "#312783";
}

window.removeColorFromPin = function (pinElement) {
  pinElement.classList.remove("bg-post-it-yellowy", "hover:bg-post-it-yellowy-dark");
  pinElement.classList.add("bg-lighter-gray");
  pinElement.firstElementChild.style.fill = "white";
}

const maxCharacters = 110
const ideaInput = document.getElementById("idea_text");
const characterCountIdea = document.getElementById("characterCountIdea");
const ideaPinElement = document.getElementById("addIdeaPin");

addEventListenerToIdeaPin(ideaPinElement, ideaInput, maxCharacters, characterCountIdea);

addEventListenerToInputField(ideaInput, characterCountIdea, maxCharacters);

setInnerHTMLOfCountText(ideaInput, maxCharacters, characterCountIdea);

colorPinOnTyping(ideaPinElement, ideaInput);

setMaxCharacters(ideaInput, maxCharacters)
