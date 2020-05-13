import consumer from "./consumer"

consumer.subscriptions.create({ channel: "IdeasChannel", id: location.pathname.split('/')[2] }, {
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
  let ideaDiv = document.createElement("div");
  let ideaElement = document.createElement("P");
  let numberElement = document.createElement("H2");
  let likeElement = document.createElement("div");
  let likeCountElement = document.createElement("P");
  let heartElement = document.createElement("div");

  likeElement.appendChild(likeCountElement);
  likeElement.appendChild(heartElement);

  likeElement.classList.add("flex", "flex-row", "self-end", "items-center");
  likeCountElement.classList.add("likes");
  heartElement.classList.add("w-4", "h-4", "heart-gray");
  numberElement.classList.add("text-blurple", "text-xl");

  ideaDiv.classList.add("idea-card", "h-48", "w-64", "px-4", "pt-6", "pb-1", "my-shadow", "my-4", "mr-8", "flex", "flex-col", "items-start", "justify-between", "italic", "font-bold", "bg-yellowy");

  ideaDiv.setAttribute("id", data.content.id);

  let likeCountText = document.createTextNode("0")
  let ideaText = document.createTextNode(data.content.text);

  ideaElement.appendChild(ideaText);
  numberElement.innerHTML = `#${data.idea_number}`
  likeCountElement.appendChild(likeCountText)

  ideaDiv.appendChild(numberElement);
  ideaDiv.appendChild(ideaElement);
  ideaDiv.appendChild(likeElement)

  document.getElementById("ideas").prepend(ideaDiv);
}

const addIdeasCount = (data) => {
  document.getElementById("ideasCount").innerHTML = data.ideas_total
};
