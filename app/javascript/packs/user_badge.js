class UserBadge extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback() {

    div = document.createElement("div")
    div2 = document.createElement("div")

    div.classList.add("flex", "flex-col", "justify-center", "items-center", "rounded-full", "h-12", "w-12", "m-4", "text-white", "text-2xl", "font-black");

    this.appendChild(div)
    this.appendChild(div2)
  }
}

customElements.define('user-badge', UserBadge);