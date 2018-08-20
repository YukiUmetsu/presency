import Pagination from "./pagination";

const baseUrl = "/api/image_manager";
let token = window.Gon.assets().token;

function getNextIfNotDisabled() {
    let paginationNext = $("#pagination-next");
    if(!paginationNext.attr("disabled")){
        let pageNumber = window.pagination.getCurrentPageNumber();
        getData(pageNumber+1);
    }
}

function getPreviousIfNotDisabled() {
    let paginationPrevious = $("#pagination-previous");
    if(!paginationPrevious.attr("disabled")){
        let pageNumber = window.pagination.getCurrentPageNumber();
        getData(pageNumber-1);
    }
}

function addEventListeners() {
    let paginationNext = $("#pagination-next");
    if(paginationNext.attr("data-click-bound") !== "1"){
        paginationNext.click(getNextIfNotDisabled);
        paginationNext.attr("data-click-bound", 1);
    }
    let paginationPrevious = $("#pagination-previous");
    if(paginationPrevious.attr("data-click-bound") !== "1"){
        paginationPrevious.click(getPreviousIfNotDisabled);
        paginationPrevious.attr("data-click-bound", "1");
    }

    let nextPage = $("#next-page");
    if(nextPage.attr("data-click-bound") !== "1"){
        nextPage.one("click", getNext);
        nextPage.attr("data-click-bound", "1");
    }

    let previousPage = $("#previous-page");
    if(previousPage.attr("data-click-bound") !== "1"){
        previousPage.one("click",getPrevious);
        previousPage.attr("data-click-bound", 1);
    }

    let firstPage = $("#first-page");
    if(firstPage.attr("data-click-bound") !== "1"){
        firstPage.one("click", getData);
        firstPage.attr("data-click-bound", 1);
    }

    let lastPage = $("#last-page");
    if(lastPage.attr("data-click-bound") !== "1"){
        lastPage.one("click", getData);
        lastPage.attr("data-click-bound", 1);
    }
}

function getNext() {
    let pageNumber = window.pagination.getCurrentPageNumber();
    getData(pageNumber+1);
}

function getPrevious() {
    let pageNumber = window.pagination.getCurrentPageNumber();
    getData(pageNumber-1);
}

function createLink(pageNumber){
    let pageSize = window.pagination.getPageSize();
    let token = window.Gon.assets().token;
    return `${baseUrl}?page=${pageNumber}&page_size=${pageSize}&token=${token}`;
}

async function getData(pageNumber) {
    let url = createLink(pageNumber);
    let data = await ajaxImageRequest(url);
    changeImages(data);
    if(typeof data !== 'undefined'){
        window.pagination.updateData(data);
        window.pagination.drawPaginationHTML();
        addEventListeners();
    }
}

function changeImages(data) {
    let images = data.images;
    let imagesHTML = '';
    for (let i = 0; i < images.length; i++) {
        let img = images[i];
        let alt = "";
        if(typeof img.caption !== 'undefined'){
            alt = img.caption;
        }
        imagesHTML += `<div class="image-item column is-one-quarter"><img src="${img.path}" alt="${alt}"></div>`;
    }
    $("#image-list").html(imagesHTML);
}


async function ajaxImageRequest(URL) {
    try {
        return $.ajax({
            url: URL,
            data: {token: window.Gon.assets().token}
        });
    } catch(error) {
        console.error(error);
    }
}

$(document).ready(function () {
    const pagination = new Pagination(baseUrl, window.pageNumber, window.pageSize, window.totalPages, token);
    window.pagination = pagination;
    pagination.drawPaginationHTML();
    addEventListeners(window.pageNumber, window.totalPages);
});


