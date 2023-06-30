window.addEventListenerToSubmitButton = function (submitButton, inputFieldWithCharacterCount, maxCharacters, countText) {
  const p = countText
  submitButton.addEventListener(
    "click",
    function () {
      p.innerHTML = inputFieldWithCharacterCount.value.length + "/" + maxCharacters
      p.classList.remove("text-red-400")
      p.textContent = "0" + "/" + maxCharacters
    }
  )
};

window.addEventListenerToInputField = function (inputFieldWithCharacterCount, countText, maxCharacters) {
  const p = countText
  inputFieldWithCharacterCount.addEventListener(
    "input",
    function () {
      p.textContent = inputFieldWithCharacterCount.value.length + "/" + maxCharacters
      if (inputFieldWithCharacterCount.value.length >= maxCharacters - 2) {
        p.classList.add("text-red-400");
      } else if (inputFieldWithCharacterCount.value.length <= maxCharacters - 2) {
        p.classList.remove("text-red-400");
      }
    }
  );
};

setMaxCharacters = (inputFieldWithCharacterCount, maxCharacters) => {
  inputFieldWithCharacterCount.maxLength = maxCharacters
}

setInnerHTMLOfCountText = (inputFieldWithCharacterCount, maxCharacters, countText) => {
  const p = countText
  p.innerHTML = inputFieldWithCharacterCount.value.length + "/" + maxCharacters
};

fieldsWithoutPresence = (allInputFieldsForValidation) => {
  console.log()
  let counter = 0
  allInputFieldsForValidation.forEach(inputFieldForValidation => {
   if (inputFieldForValidation.value.trim() === "") {
    counter += 1
   }
  })
  return counter
}

function addColorToSubmitButton(submitButton, activeColors, inactiveColors) {
    activeColors.forEach(activeColor => {
      submitButton.classList.add(activeColor);
    });
    inactiveColors.forEach(inactiveColor => {
      submitButton.classList.remove(inactiveColor);
    });

  //submitButton.firstElementChild.style.fill = "#312783";
}

window.removeColorFromSubmitButton = function(submitButton, activeColors, inactiveColors) {
  activeColors.forEach(activeColor => {
    submitButton.classList.remove(activeColor);
  });
  inactiveColors.forEach(inactiveColor => {
    submitButton.classList.add(inactiveColor);
  });
  //submitButton.firstElementChild.style.fill = "white";
}

colorSubmitButtonOnTyping = (submitButton, allInputFieldsForValidation, activeColors, inactiveColors) => {
  allInputFieldsForValidation.forEach(inputFieldForValidation => {
    inputFieldForValidation.addEventListener(
      "keyup",
      function () {
          if ((inputFieldForValidation.value.length > 0) && (fieldsWithoutPresence(allInputFieldsForValidation) === 0)) {
            addColorToSubmitButton(submitButton, activeColors, inactiveColors)
          } else if (inputFieldForValidation.value.length === 0) {
            removeColorFromSubmitButton(submitButton, activeColors, inactiveColors)
          }
      }
    )
   })
};

addEventListenerToSubmitButton(submitButton, inputFieldWithCharacterCount, maxCharacters, characterCount);

addEventListenerToInputField(inputFieldWithCharacterCount, characterCount, maxCharacters);

setInnerHTMLOfCountText(inputFieldWithCharacterCount, maxCharacters, characterCount);

colorSubmitButtonOnTyping(submitButton, allInputFieldsForValidation, activeColors, inactiveColors);

setMaxCharacters(inputFieldWithCharacterCount, maxCharacters)
