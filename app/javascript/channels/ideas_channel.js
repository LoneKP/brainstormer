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
      case "transmit_ideas":
        buildHTML(data.ideas, brainstormStore.state, data.available_votes, data.anonymous);
    }
  }
});

const buildHTML = (ideas, state, available_votes, anonymous) => {
  if (state == "vote") {
    buildVotePage(ideas, anonymous);
    showVotesAvailable(available_votes);
    fillStarsWithUserVotes();
  }
  else if (state == "voting_done") {
    buildVotingDonePage(ideas, anonymous);
  }
  else if (state == "ideation") {
    buildIdeationPage(ideas, anonymous);
    updateFacilitatorSpecificElementsOnIdeas();
    addIdeasCount(ideas);
  }
}

const showVotesAvailable = (votes) => {
  let stars = ""
  for (let i = 0; i < votes; i++) {
    stars += `<svg class="flex lg:h-8 lg:w-8 h-20 w-20" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 36 36" version="1.1"><title>0E4C7326-8988-4892-82B6-3FD8F36A9D07</title><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-701.000000, -551.000000)"><g transform="translate(653.000000, 551.000000)"><g transform="translate(48.000000, 0.000000)"><polygon id="Path" points="0 0 36 0 36 36 0 36" /><polygon id="Path" points="0 0 36 0 36 36 0 36" /><polygon class="starVoteFill" id="Path" fill="#FFFFFF" stroke="#FFFFFF" stroke-width="3" stroke-linejoin="bevel" fill-rule="nonzero" points="18.12 25.8332211 27.39 31.44 24.93 20.8728 33.12 13.7628632 22.335 12.8459368 18.12 2.88 13.905 12.8459368 3.12 13.7628632 11.31 20.8728 8.85 31.44" /></g></g></g></g></svg>`
  }

  document.getElementById("starsContainer").innerHTML = stars
}

const buildVotePage = (ideas, anonymous) => {
  let htmlIdeaAndIdeaBuilds = ""

  for (let i = 0; i < ideas.length; i++) {
    let htmlIdeaBuilds = ""
    for (let x = 0; x < ideas[i].idea_builds.length; x++) {
      htmlIdeaBuilds += `<div class="lg:w-64 w-full bg-post-it-yellowy-${ideas[i].idea_builds[x].opacity_lookup} italic lg:px-4 px-10 lg:pt-6 lg:pb-1 pt-14 pb-8 cursor-default"><div class="flex flex-row justify-between w-full items-center"><h2 class="font-bold lg:m-0 text-blurple text-5xl lg:text-xl">#${ideas[i].number}.${ideas[i].idea_builds[x].decimal}</h2></div><div class="flex flex-col justify-between h-full"><p class="font-bold pb-4 text-4xl lg:text-base leading-loose lg:leading-normal break-words w-full ">${ideas[i].idea_builds[x].idea_build_text}</p><p class="font-extralight lg:m-0 text-2xl lg:text-sm leading-loose lg:leading-normal break-words w-full">${anonymous ? "" : ideas[i].idea_builds[x].author}</p></div></div>`
    }
    htmlIdeaAndIdeaBuilds += `<div class="flex flex-col lg:mr-4"><div class="my-shadow my-8 lg:my-4 bg-white"><a data-remote="true" rel="nofollow" data-method="post" href="/ideas/${ideas[i].id}/vote"><div class="idea-card lg:h-64 lg:w-64 w-full lg:px-4 px-10 lg:pt-6 lg:pb-1 pt-14 pb-8 flex flex-col items-start italic bg-post-it-yellowy cursor-default"><div class="flex flex-row justify-between w-full font-bold"><h2 class="mb-4 lg:m-0 text-blurple text-5xl lg:text-xl">#${ideas[i].number}</h2><svg class="lg:h-8 lg:w-8 h-20 w-20" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 36 36" version="1.1"><title>0E4C7326-8988-4892-82B6-3FD8F36A9D07</title><g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g transform="translate(-701.000000, -551.000000)"><g transform="translate(653.000000, 551.000000)"><g transform="translate(48.000000, 0.000000)"><polygon id="Path" points="0 0 36 0 36 36 0 36"></polygon><polygon id="Path" points="0 0 36 0 36 36 0 36"></polygon><polygon class="star-idea-${ideas[i].id}" id="star-idea-${ideas[i].id}" stroke="#312783" stroke-width="3" stroke-linejoin="bevel" fill-rule="nonzero" points="18.12 25.8332211 27.39 31.44 24.93 20.8728 33.12 13.7628632 22.335 12.8459368 18.12 2.88 13.905 12.8459368 3.12 13.7628632 11.31 20.8728 8.85 31.44"></polygon></g></g></g></g></svg></div><div class="flex flex-col justify-between h-full"><p class="font-bold mb-4 lg:m-0 text-4xl lg:text-base leading-loose lg:leading-normal break-words w-full">${ideas[i].text}</p><p class="font-extralight lg:m-0 text-2xl lg:text-sm leading-loose lg:leading-normal break-words w-full">${anonymous ? "" : ideas[i].author}</p></div></div></a>${htmlIdeaBuilds}</div></div>`

    document.getElementById("ideasVote").innerHTML = htmlIdeaAndIdeaBuilds; 
  }
}

const buildVotingDonePage = (ideas, anonymous) => {
  let htmlIdeaAndIdeaBuilds = ""

  for (let i = 0; i < ideas.length; i++) {
    let htmlIdeaBuilds = ""
    for (let x = 0; x < ideas[i].idea_builds.length; x++) {
      htmlIdeaBuilds += `<div class="lg:w-64 w-full bg-post-it-yellowy-${ideas[i].idea_builds[x].opacity_lookup} italic font-bold lg:px-4 px-10 lg:pt-6 lg:pb-1 pt-14 pb-8"><div class="flex flex-row justify-between w-full items-center"><h2 class="lg:m-0 text-blurple text-5xl lg:text-xl">#${ideas[i].number}.${ideas[i].idea_builds[x].decimal}</h2></div><div class="flex flex-col justify-between h-full"><p class="font-bold pb-4 text-4xl lg:text-base leading-loose lg:leading-normal break-words w-full ">${ideas[i].idea_builds[x].idea_build_text}</p><p class="font-extralight lg:m-0 text-2xl lg:text-sm leading-loose lg:leading-normal break-words w-full">${anonymous ? "" : ideas[i].idea_builds[x].author}</p></div></div>`
    }
    htmlIdeaAndIdeaBuilds += `<div class="flex flex-col lg:mr-4"><div class="my-shadow my-8 lg:my-4 bg-white"><div class="idea-card lg:h-64 lg:w-64 w-full lg:px-4 px-10 lg:pt-6 lg:pb-1 pt-14 pb-8 flex flex-col items-start italic font-bold bg-post-it-yellowy cursor-default"><div class="flex flex-row justify-between w-full"><h2 class="mb-4 lg:m-0 text-blurple text-5xl lg:text-xl">#${ideas[i].number}</h2><h2 class="mb-4 lg:m-0 text-blurple text-5xl lg:text-xl">${ideas[i].votes} ${ideas[i].vote_in_plural_or_singular}</h2></div><div class="flex flex-col justify-between h-full"><p class="font-bold mb-4 lg:m-0 text-4xl lg:text-base leading-loose lg:leading-normal break-words w-full">${ideas[i].text}</p><p class="font-extralight lg:m-0 text-2xl lg:text-sm leading-loose lg:leading-normal break-words w-full">${anonymous ? "" : ideas[i].author}</p></div></div>${htmlIdeaBuilds}</div></div>`

    document.getElementById("ideasVotingDone").innerHTML = htmlIdeaAndIdeaBuilds; 
  }
}

const buildIdeationPage = (ideas, anonymous) => {
  let htmlIdeaAndIdeaBuilds = ""

  let auth_token = document.querySelector("meta[name='csrf-token']").getAttribute("content");

  for (let i = 0; i < ideas.length; i++) {
    let htmlIdeaBuilds = ""
    for (let x = 0; x < ideas[i].idea_builds.length; x++) {
      htmlIdeaBuilds += `<div class="lg:w-64 w-full bg-post-it-yellowy-${ideas[i].idea_builds[x].opacity_lookup} italic lg:px-4 px-10 lg:pt-6 lg:pb-1 pt-14 pb-8"><h2 class="font-bold lg:m-0 text-blurple text-5xl lg:text-xl">#${ideas[i].number}.${ideas[i].idea_builds[x].decimal}</h2><div class="flex flex-col justify-between h-full"><p class="font-bold pb-4 text-4xl lg:text-base leading-loose lg:leading-normal break-words w-full ">${ideas[i].idea_builds[x].idea_build_text}</p><p class="font-extralight lg:m-0 text-2xl lg:text-sm leading-loose lg:leading-normal break-words w-full">${anonymous ? "" : ideas[i].idea_builds[x].author}</p></div></div>`
    }
    htmlIdeaAndIdeaBuilds += `<div class="flex flex-col lg:mb-12 mb-28"><div id="group-hover-div-${ideas[i].id}" class="group my-shadow mr-8 my-8 lg:my-4 bg-white"><div class="relative relativeClass"><div class="select-none idea-card lg:h-64 lg:w-64 w-full lg:px-4 px-10 lg:pt-6 lg:pb-1 pt-14 pb-8 flex flex-col items-start justify-between italic bg-post-it-yellowy cursor-default"><h2 class="font-bold mb-4 lg:m-0 text-blurple text-5xl lg:text-xl">#${ideas[i].number}</h2><div class="flex flex-col justify-between h-full"><p class="font-bold mb-4 lg:m-0 text-4xl lg:text-base leading-loose lg:leading-normal break-words w-full">${ideas[i].text}</p><p class="font-extralight lg:m-0 text-2xl lg:text-sm leading-loose lg:leading-normal break-words w-full">${anonymous ? "" : ideas[i].author}</p></div></div>${htmlIdeaBuilds}<div class="absolute absoluteClass w-full z-50 bg-white"><div class="hidden group-hover:flex flex-row items-center lg:h-14 h-32"><div class="flex flex-row w-full leading-none justify-center text-white h-32 lg:h-14"><form class="w-full" method="post" action="/ideas/${ideas[i].id}/show_idea_build_form" data-remote="true"><button class="h-full w-full" type="submit"><p class="bg-blurple hover:bg-post-it-yellowy${ideas[i].opacity_lookup_previous_idea_build} hover:text-blurple hover:border-2 hover:border-blurple hover:border-solid h-full flex flex-col justify-center lg:text-base text-4xl uppercase font-bold">Build on idea</p></button><input type="hidden" name="authenticity_token" value="${auth_token}" autocomplete="off"></form><form class="deleteIdeaButton" method="post" action="/ideas/${ideas[i].id}"><input type="hidden" name="_method" value="delete" autocomplete="off"><button class="h-full w-full" type="submit"><span class="w-32 lg:w-14 material-icons bg-reddy hover:bg-post-it-yellowy${ideas[i].opacity_lookup_previous_idea_build} hover:text-reddy hover:border-2 hover:border-reddy hover:border-solid h-full text-white flex flex-col justify-center lg:text-2xl text-6xl">delete</span></button><input type="hidden" name="authenticity_token" value="${auth_token}" autocomplete="off"></form></div></div><div id="add-idea-build-form-idea-${ideas[i].id}"></div></div></div></div></div>`

    document.getElementById("ideas").innerHTML = htmlIdeaAndIdeaBuilds; 
  }
}

const addIdeasCount = (ideas) => {
  document.getElementById("ideasCount").innerHTML = ideas.length
  document.getElementById("final-ideas-count").innerHTML = ideas.length === 1 ? `${ideas.length} idea` : `${ideas.length} ideas`
};