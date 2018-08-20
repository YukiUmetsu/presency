import {Socket} from "phoenix";
$(document).ready(function () {
    window.socket = new Socket("/admin_socket", {params: {token: window.userToken}});
    window.socket.connect();
});