import consumer from "./consumer"

consumer.subscriptions.create({ channel: "IdeasChannel", token: location.pathname.replace("/", "") }, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data)
    createNewIdea(data);
    addIdeasCount(data);
  }
});

const createNewIdea = (data) => {
  let linkContainer = document.createElement("a");
  let ideaDiv = document.createElement("div");
  let ideaElement = document.createElement("P");
  let numberElement = document.createElement("H2");
  let likeElement = document.createElement("div");
  let heartElement = document.createElement("div");


  likeElement.appendChild(heartElement);

  likeElement.classList.add("flex", "flex-row", "self-end", "items-center");

  heartElement.classList.add("w-14", "h-14", "lg:h-5", "lg:w-5", "heart-gray");
  numberElement.classList.add("mb-4", "lg:m-0", "text-blurple", "text-5xl", "lg:text-xl");

  ideaDiv.classList.add("select-none", "idea-card", "lg:h-64", "lg:w-64", "w-full", "lg:px-4", "px-10", "lg:pt-6", "lg:pb-1", "pt-14", "pb-8", "my-shadow", "my-8", "lg:my-4", "mr-8", "flex", "flex-col", "items-start", "justify-between", "italic", "font-bold", "bg-yellowy", "cursor-default");

  ideaElement.classList.add("mb-4", "lg:m-0", "text-4xl", "lg:text-base", "leading-loose", "lg:leading-normal")
  linkContainer.classList.add("cursor-default")
  linkContainer.setAttribute("data-turbolinks", "false")
  linkContainer.setAttribute("data-remote", "true")
  linkContainer.setAttribute("rel", "nofollow")
  linkContainer.setAttribute("data-method", "patch")
  linkContainer.setAttribute("href", `/ideas/${data.content.id}?session_id=${currentUser.id}`)

  heartElement.setAttribute("id", data.content.id);

  let ideaText = document.createTextNode(data.content.text);

  ideaElement.appendChild(ideaText);
  numberElement.innerHTML = `#${data.idea_number}`


  ideaDiv.appendChild(numberElement);
  ideaDiv.appendChild(ideaElement);
  ideaDiv.appendChild(likeElement)

  linkContainer.appendChild(ideaDiv);

  document.getElementById("ideas").prepend(linkContainer);
}

const addIdeasCount = (data) => {
  document.getElementById("ideasCount").innerHTML = data.ideas_total
};
