class Notification {

    constructor() {}

    /**
     *
     * @param effectiveTime (effective time in seconds)
     * @param messageHtml (html including message)
     * @param classType (bulma class type, "is-success", "is-danger" etc)
     * @param position (clockwise 0: top left, 1: top right, 2: right bottom, 3: left bottom)
     */
    notify(effectiveTime, messageHtml, classType='is-primary', position=2){
        let uuid = this.generateUuid();
        let html = this.getNotificationHtml(messageHtml, classType, position, uuid);
        $(document).fadeIn("slow").append(html);
        $(".notification > .delete").on("click", function () {
            $(this).closest(".notification").remove();
        });
        setTimeout(function(){
            $(`#${uuid}`).remove();
        }, effectiveTime*1000);
    }

    getNotificationHtml(messageHtml, classType, position, id){
        let positionClass = 'notification-top-right';
        switch (position){
            case 0:
                positionClass = 'notification-top-left';
                break;
            case 2:
                positionClass = 'notification-bottom-right';
                break;
            case 3:
                positionClass = 'notification-bottom-left';
                break;
            default:
                positionClass = 'notification-top-right';
                break;
        }

        return `<div id="${id}" class="${positionClass} notification ${classType}"><button class="delete"></button>${messageHtml}</div>`;
    }

    generateUuid() {
        // https://github.com/GoogleChrome/chrome-platform-analytics/blob/master/src/internal/identifier.js
        // const FORMAT: string = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx";
        let chars = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".split("");
        for (let i = 0, len = chars.length; i < len; i++) {
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
}

export default Notification;