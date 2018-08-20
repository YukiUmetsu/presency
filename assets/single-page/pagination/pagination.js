class Pagination {

    constructor(baseUrl, pageNumber, pageSize, totalPages, token){
        this.baseUrl = baseUrl;
        this.pageNumber = pageNumber;
        this.pageSize = pageSize;
        this.totalPages = totalPages;
        this.token = token;
        this.disablePrev = true;
        this.disableNext = false;
        this.hideFirstPage = true;
        this.hideLastPage = false;
        this.hidePreviousPage = false;
        this.hideNextPage = false;
    }

    getCurrentPageNumber(){
        return this.pageNumber;
    }

    getTotalPageNumber(){
        return this.totalPages;
    }

    getPageSize(){
        return this.pageSize;
    }

    getFirstPageLink(){
        return this.createLink(1);
    }

    getLastPageLink(){
        return this.createLink(this.totalPages);
    }

    getPageLink(){
        return this.createLink(this.pageNumber);
    }

    createLink(page){
        return `${this.baseUrl}?page=${page}&page_size=${this.pageSize}&token=${token}`;
    }

    updateElementStatus(){
        this.updateHidePreviousStatus();
        this.updateHideNextPageStatus();
        this.updateDisableNextButtonStatus();
        this.updateDisablePreviousButtonStatus();
        this.updateHideFirstStatus();
        this.updateHideLastStatus();
    }

    updateHidePreviousStatus(){
        this.hidePreviousPage = (this.pageNumber === 1);
    }

    updateHideNextPageStatus(){
        this.hideNextPage = (this.pageNumber === this.totalPages);
    }

    updateDisableNextButtonStatus(){
        this.disableNext = (this.pageNumber >= this.totalPages);
    }

    updateDisablePreviousButtonStatus(){
        this.disablePrev = (this.pageNumber <= 1);
    }

    updateHideFirstStatus(){
        this.hideFirstPage = (this.pageNumber < 3);
    }

    updateHideLastStatus(){
        this.hideLastPage = (this.pageNumber > this.totalPages -2);
    }


    drawPaginationHTML(){
        this.updateElementStatus();
        let disablePrevAttr = (this.disablePrev ? "disabled" : "");
        let disableNextAttr = (this.disableNext ? "disabled" : "");
        let html = `<div class="pagination-links u-margin-tb-small">
            <nav class="pagination is-centered" role="navigation" aria-label="pagination">
              <button id="pagination-previous" class="pagination-previous" ${disablePrevAttr}>Prev</button>
              <button id="pagination-next" class="pagination-next" ${disableNextAttr}>Next</button>
              <ul id="pagination-list" class="pagination-list">`;
        if(!this.hideFirstPage){
            html += `<li><a id="first-page" class="pagination-link" aria-label="Goto page 1">1</a></li>
                <li><span class="pagination-ellipsis">&hellip;</span></li>`;
        }
        if(!this.hidePreviousPage){
            html += `<li><a id="previous-page" class="pagination-link" aria-label="Goto page ${this.pageNumber-1}">${this.pageNumber-1}</a></li>`;
        }
        html += `<li><a class="pagination-link is-current" aria-label="Page ${this.pageNumber}" aria-current="page">${this.pageNumber}</a></li>`;
        if(!this.hideNextPage){
            html += `<li><a id="next-page" class="pagination-link" aria-label="Goto page ${this.pageNumber+1}">${this.pageNumber+1}</a></li>`;
        }
        if(!this.hideLastPage){
            html += `<li><span class="pagination-ellipsis">&hellip;</span></li>
                    <li><a id="last-page" class="pagination-link" aria-label="Goto page ${this.totalPages}">${this.totalPages}</a></li>`;
        }
        html += `</ul></nav></div>`;
        $("#pagination").html(html);
    }

    updateData(data){
        this.pageNumber = data.page_number;
        this.pageSize = data.page_size;
        this.totalPages = data.total_pages;
        this.data = data;
    }
}

export default Pagination;