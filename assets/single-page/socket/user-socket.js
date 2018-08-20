import {Socket} from "phoenix";
$(document).ready(function () {
    window.socket = new Socket("/user_socket", {params: {token: window.userToken}});
    window.socket.connect();
});