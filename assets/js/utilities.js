function uuid() {
    // https://github.com/GoogleChrome/chrome-platform-analytics/blob/master/src/internal/identifier.js
    // const FORMAT: string = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx";
    var chars = "xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx".split("");
    for (var i = 0, len = chars.length; i < len; i++) {
        switch (chars[i]) {
            case "x":
                chars[i] = Math.floor(Math.random() * 16).toString(16);
                break;
            case "y":
                chars[i] = (Math.floor(Math.random() * 4) + 8).toString(16);
                break;
        }
    }
    return chars.join("");
}

$(document).ready(() => {
   $(".tabs li").on("click", function(){
       $(".tabs li").removeClass("is-active");
       $(this).addClass("is-active");
   })
});

let addEvent = (eventType, selector, func) => {
    $(document).on(eventType, selector, selector, func);
};