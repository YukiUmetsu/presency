// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix";
let socket = new Socket("/admin_socket", {params: {token: window.userToken}});

socket.connect();

let channel = socket.channel("image_uploader", {});
channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

channel.push("image_uploader:new", { image: "binary" })
    .receive("ok", (reply) => console.log(reply))
    .receive("error", (reply) => console.log(reply))

export default socket
