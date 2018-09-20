$(document).ready(() => {
    $(".switchable-input").hide();
    $(".switchable-box > .switchable-label").on("click", function(){
        showInput($(this));
    });
    
    $(".switchable-input").on("blur", function () {
        hideInput($(this));
    });
});

let showInput = (clickedElement) => {
    clickedElement.hide();
    let inputId = clickedElement.attr("for");
    $(`#${inputId}`).val(clickedElement.text()).show();
};
let hideInput = (clickedElement) => {
    clickedElement.hide();
    let inputValue = clickedElement.val();
    let labelFor = clickedElement.attr("id");
    let labelElement = $(`label[for='${labelFor}']`);
    if(inputValue.length === 0){
        labelElement.show();
    } else {
        labelElement.text(clickedElement.val()).show();
    }
};

let switchBox = $(".switchable-box");
$(document).mouseup(function (e) {
    // if the target of the click isn't the container nor a descendant of the container
    if (!switchBox.is(e.target) && switchBox.has(e.target).length === 0) {
        hideInput($(".switchable-input[display!='none']"));
    }
});