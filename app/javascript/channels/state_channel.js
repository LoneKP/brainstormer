import consumer from "./consumer"

consumer.subscriptions.create({
  channel: "StateChannel", token: location.pathname.replace("/", "")
}, {
  received(data) {
    console.log(data)
    switch (data.event) {
      case "set_brainstorm_state":
        setAndChangeBrainstormState(data.state);
      }
  },
})