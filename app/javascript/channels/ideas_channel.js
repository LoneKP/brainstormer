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
  let element = document.createElement("P");
  let div = document.createElement("div");

  div.classList.add("idea-card", "h-48", "w-56", "px-4", "pt-6", "pb-1", "shadow-lg", "m-4", "text-center", "rounded-lg", "flex", "flex-col", "items-center", "justify-between");

  div.setAttribute("id", data.content.id);

  let textnode = document.createTextNode(data.content.text);

  element.appendChild(textnode);
  div.appendChild(element);

  document.getElementById("ideas").prepend(div);
}

const addIdeasCount = (data) => {
  document.getElementById("ideasCount").innerHTML = data.ideas_total
};
