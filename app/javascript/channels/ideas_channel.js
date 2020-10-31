import consumer from "./consumer"

consumer.subscriptions.create({ channel: "IdeasChannel", token: location.pathname.replace("/", "") }, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    switch (data.event) {
      case "create_idea":
        console.log(data)
        createNewIdea(data);
        addIdeasCount(data);
        break;
      case "create_idea_build":
        console.log(data)
        createNewIdeaBuild(data);
    }
  }
});

const createNewIdea = (data) => {
  let postItsContainer = document.createElement("div")
  let ideaContainer = document.createElement("div")
  let ideaDiv = document.createElement("div");
  let ideaElement = document.createElement("P");
  let numberElement = document.createElement("H2");

  let buildOnIdeaDiv = document.createElement("div");
  let buildOnIdeaLink = document.createElement("a");
  let buildOnIdeaButton = document.createElement("button");

  numberElement.classList.add("mb-4", "lg:m-0", "text-blurple", "text-5xl", "lg:text-xl");

  postItsContainer.classList.add("flex", "flex-col");

  ideaContainer.classList.add("my-shadow", "mr-8", "my-8", "lg:my-4", "bg-white");

  ideaDiv.classList.add("select-none", "idea-card", "lg:h-64", "lg:w-64", "w-full", "lg:px-4", "px-10", "lg:pt-6", "lg:pb-1", "pt-14", "pb-8", "flex", "flex-col", "items-start", "italic", "font-bold", "bg-post-it-yellowy", "cursor-default");

  ideaDiv.setAttribute("id", `idea-${data.content.id}`);
  ideaDiv.setAttribute("onclick", `toggleBuildOnIdea(${data.content.id})`);

  ideaElement.classList.add("mb-4", "lg:m-0", "text-4xl", "lg:text-base", "leading-loose", "lg:leading-normal");

  buildOnIdeaDiv.classList.add("text-center", "bg-post-it-yellowy-60", "py-2", "hidden");
  buildOnIdeaDiv.setAttribute("id", `buildOnIdea-${data.content.id}`);
  buildOnIdeaLink.setAttribute("data-remote", "true");
  buildOnIdeaLink.setAttribute("rel", "nofollow");
  buildOnIdeaLink.setAttribute("data-method", "post");
  buildOnIdeaLink.setAttribute("href", data.build_on_idea_link);
  buildOnIdeaButton.classList.add("text-lg", "font-medium", "uppercase", "bg-black", "text-white", "py-1", "px-8");
  buildOnIdeaButton.innerHTML = "Build on idea"

  let ideaText = document.createTextNode(data.content.text);

  ideaElement.appendChild(ideaText);
  numberElement.innerHTML = `#${data.idea_number}`;

  postItsContainer.appendChild(ideaContainer);
  ideaContainer.appendChild(ideaDiv);
  ideaDiv.appendChild(numberElement);
  ideaDiv.appendChild(ideaElement);

  ideaContainer.appendChild(buildOnIdeaDiv);
  buildOnIdeaDiv.appendChild(buildOnIdeaLink);
  buildOnIdeaLink.appendChild(buildOnIdeaButton);

  document.getElementById("ideas").prepend(postItsContainer);
}

const createNewIdeaBuild = (data) => {
  let ideaBuildDiv = document.createElement("div");
  let ideaBuildNumber = document.createElement("h2");
  let ideaBuildText = document.createElement("p");

  ideaBuildDiv.classList.add("lg:w-64", "w-full", `bg-post-it-yellowy-${data.opacity}`, "italic", "font-bold", "lg:px-4", "px-10");
  ideaBuildNumber.classList.add("py-4", "mb-4", "lg:m-0", "text-blurple", "text-5xl", "lg:text-xl");
  ideaBuildText.classList.add("py-4", "text-4xl", "lg:text-base", "leading-loose", "lg:leading-normal");

  ideaBuildText.innerHTML = data.content.idea_build_text
  ideaBuildNumber.innerHTML = `#${data.idea_build_number}`

  ideaBuildDiv.appendChild(ideaBuildNumber);
  ideaBuildDiv.appendChild(ideaBuildText);

  document.getElementById(`buildOnIdea-${data.content.idea_id}`).insertAdjacentElement("beforebegin", ideaBuildDiv);
}

const addIdeasCount = (data) => {
  document.getElementById("ideasCount").innerHTML = data.ideas_total
};
