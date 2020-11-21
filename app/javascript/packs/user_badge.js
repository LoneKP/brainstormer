class UserBadge extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback() {

    const color = randomColorPicker()
    div = document.createElement("div")
    div2 = document.createElement("div")
    div2.innerHTML = "DONE"
    div2.classList.add(color, "text-white", "text-center", "font-bold", "hidden")

    div.classList.add("flex", "flex-col", "justify-center", "items-center", "rounded-full", "h-12", "w-12", "m-4", "text-white", "text-2xl", "font-black", color);

    this.appendChild(div)
    this.appendChild(div2)
  }
}

customElements.define('user-badge', UserBadge);

const randomColorPicker = () => {
  let colorClasses = ["bg-purply", "bg-greeny", "bg-yellowy", "bg-reddy"];
  let randomColor = colorClasses[Math.floor(Math.random() * colorClasses.length)];
  return randomColor;
}