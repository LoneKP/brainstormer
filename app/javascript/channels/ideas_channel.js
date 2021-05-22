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
        break;
      case "transmit_ideas":
        console.log(data)
        buildHTML(data.ideas, brainstormStore.state);
        if (brainstormStore.state == "voting_done") {
          fillStarsWithUserVotes();
        }
    }
  }
});

const buildHTML = (ideas, state) => {
  if (state == "vote") {
    buildVotePage(ideas)
  }
  else if (state == "voting_done") {
    buildVotingDonePage(ideas)
  }
}

const buildVotePage = (ideas) => {
  let htmlIdeaAndIdeaBuilds = ""

  for (let i = 0; i < ideas.length; i++) {
    let htmlIdeaBuilds = ""
    for (let x = 0; x < ideas[i].idea_builds.length; x++) {
      htmlIdeaBuilds += `<a data-remote="true" rel="nofollow" data-method="post" href="/ideas/${ideas[i].id}/idea_builds/${ideas[i].idea_builds[x].id}/vote"><div class="lg:w-64 w-full bg-post-it-yellowy-${ideas[i].idea_builds[x].opacity_lookup} italic font-bold lg:px-4 px-10 cursor-default"><div class="flex flex-row justify-between w-full items-center"><h2 class="py-4 mb-4 lg:m-0 text-blurple text-5xl lg:text-xl">#${ideas[i].number}.${ideas[i].idea_builds[x].decimal}</h2><svg class="lg:h-8 lg:w-8 h-20 w-20" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 36 36" version="1.1"><title>0E4C7326-8988-4892-82B6-3FD8F36A9D07</title><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-701.000000, -551.000000)"><g id="Group-16" transform="translate(653.000000, 551.000000)"><g transform="translate(48.000000, 0.000000)"><polygon id="Path" points="0 0 36 0 36 36 0 36"></polygon><polygon id="Path" points="0 0 36 0 36 36 0 36"></polygon><polygon class="star-idea-build-${ideas[i].idea_builds[x].id}" id="star-idea-build-${ideas[i].idea_builds[x].id}" stroke="#312783" stroke-width="3" stroke-linejoin="bevel" fill-rule="nonzero" points="18.12 25.8332211 27.39 31.44 24.93 20.8728 33.12 13.7628632 22.335 12.8459368 18.12 2.88 13.905 12.8459368 3.12 13.7628632 11.31 20.8728 8.85 31.44"></polygon></g></g></g></g></svg></div><p class="py-4 text-4xl lg:text-base leading-loose lg:leading-normal">${ideas[i].idea_builds[x].idea_build_text}</p></div></a>`
    }
    htmlIdeaAndIdeaBuilds += `<div class="flex flex-col lg:mr-4"><div class="my-shadow my-8 lg:my-4 bg-white"><a data-remote="true" rel="nofollow" data-method="post" href="/ideas/${ideas[i].id}/vote"><div class="idea-card lg:h-64 lg:w-64 w-full lg:px-4 px-10 lg:pt-6 lg:pb-1 pt-14 pb-8 flex flex-col items-start italic font-bold bg-post-it-yellowy cursor-default"><div class="flex flex-row justify-between w-full"><h2 class="mb-4 lg:m-0 text-blurple text-5xl lg:text-xl">#${ideas[i].number}</h2><svg class="lg:h-8 lg:w-8 h-20 w-20" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 36 36" version="1.1"><title>0E4C7326-8988-4892-82B6-3FD8F36A9D07</title><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-701.000000, -551.000000)"><g transform="translate(653.000000, 551.000000)"><g transform="translate(48.000000, 0.000000)"><polygon id="Path" points="0 0 36 0 36 36 0 36"></polygon><polygon id="Path" points="0 0 36 0 36 36 0 36"></polygon><polygon class="star-idea-${ideas[i].id}" id="star-idea-${ideas[i].id}" stroke="#312783" stroke-width="3" stroke-linejoin="bevel" fill-rule="nonzero" points="18.12 25.8332211 27.39 31.44 24.93 20.8728 33.12 13.7628632 22.335 12.8459368 18.12 2.88 13.905 12.8459368 3.12 13.7628632 11.31 20.8728 8.85 31.44"></polygon></g></g></g></g></svg></div><p class="mb-4 lg:m-0 text-4xl lg:text-base leading-loose lg:leading-normal">${ideas[i].text}</p></div></a>${htmlIdeaBuilds}</div></div>`

    document.getElementById("ideasVote").innerHTML = htmlIdeaAndIdeaBuilds; 
  }
}

const buildVotingDonePage = (ideas) => {
  let htmlIdeaAndIdeaBuilds = ""

  for (let i = 0; i < ideas.length; i++) {
    let htmlIdeaBuilds = ""
    for (let x = 0; x < ideas[i].idea_builds.length; x++) {
      htmlIdeaBuilds += `<div class="lg:w-64 w-full bg-post-it-yellowy-${ideas[i].idea_builds[x].opacity_lookup} italic font-bold lg:px-4 px-10"><div class="flex flex-row justify-between w-full items-center"><h2 class="py-4 mb-4 lg:m-0 text-blurple text-5xl lg:text-xl">${ideas[i].idea_builds[x].votes} ${ideas[i].idea_builds[x].vote_in_plural_or_singular}</h2><svg class="lg:h-8 lg:w-8 h-20 w-20" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 36 36" version="1.1"><title>0E4C7326-8988-4892-82B6-3FD8F36A9D07</title><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-701.000000, -551.000000)"><g id="Group-16" transform="translate(653.000000, 551.000000)"><g transform="translate(48.000000, 0.000000)"><polygon id="Path" points="0 0 36 0 36 36 0 36"></polygon><polygon id="Path" points="0 0 36 0 36 36 0 36"></polygon><polygon class="star-idea-build-${ideas[i].idea_builds[x].id}" id="star-idea-build-${ideas[i].idea_builds[x].id}" stroke="#312783" stroke-width="3" stroke-linejoin="bevel" fill-rule="nonzero" points="18.12 25.8332211 27.39 31.44 24.93 20.8728 33.12 13.7628632 22.335 12.8459368 18.12 2.88 13.905 12.8459368 3.12 13.7628632 11.31 20.8728 8.85 31.44"></polygon></g></g></g></g></svg></div><p class="py-4 text-4xl lg:text-base leading-loose lg:leading-normal"><span>#${ideas[i].number}.${ideas[i].idea_builds[x].decimal} </span>${ideas[i].idea_builds[x].idea_build_text}</p></div>`
    }
    htmlIdeaAndIdeaBuilds += `<div class="flex flex-col lg:mr-4"><div class="my-shadow my-8 lg:my-4 bg-white"><div class="idea-card lg:h-64 lg:w-64 w-full lg:px-4 px-10 lg:pt-6 lg:pb-1 pt-14 pb-8 flex flex-col items-start italic font-bold bg-post-it-yellowy cursor-default"><div class="flex flex-row justify-between w-full"><h2 class="mb-4 lg:m-0 text-blurple text-5xl lg:text-xl">${ideas[i].votes} ${ideas[i].vote_in_plural_or_singular}</h2><svg class="lg:h-8 lg:w-8 h-20 w-20" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 36 36" version="1.1"><title>0E4C7326-8988-4892-82B6-3FD8F36A9D07</title><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-701.000000, -551.000000)"><g transform="translate(653.000000, 551.000000)"><g transform="translate(48.000000, 0.000000)"><polygon id="Path" points="0 0 36 0 36 36 0 36"></polygon><polygon id="Path" points="0 0 36 0 36 36 0 36"></polygon><polygon class="star-idea-${ideas[i].id}" id="star-idea-${ideas[i].id}" stroke="#312783" stroke-width="3" stroke-linejoin="bevel" fill-rule="nonzero" points="18.12 25.8332211 27.39 31.44 24.93 20.8728 33.12 13.7628632 22.335 12.8459368 18.12 2.88 13.905 12.8459368 3.12 13.7628632 11.31 20.8728 8.85 31.44"></polygon></g></g></g></g></svg></div><p class="mb-4 lg:m-0 text-4xl lg:text-base leading-loose lg:leading-normal"><span>#${ideas[i].number} </span>${ideas[i].text}</p></div>${htmlIdeaBuilds}</div></div>`

    document.getElementById("ideasVotingDone").innerHTML = htmlIdeaAndIdeaBuilds; 
  }
}

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
  buildOnIdeaButton.classList.add("text-5xl", "lg:text-lg", "font-medium", "uppercase", "bg-black", "text-white", "py-8", "lg:py-1", "lg:px-8", "px-40", "my-8", "lg:my-2");
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
  document.getElementById("final-ideas-count").innerHTML = data.ideas_total > 1 ? `${data.ideas_total} ideas` : `${data.ideas_total} idea`
};
