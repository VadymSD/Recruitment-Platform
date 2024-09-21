import { LightningElement, api} from 'lwc';

export default class PositionPagination extends LightningElement {

    @api pageSize = 5;
    totalPages = 0;
    pageLinks;
    totalRecords;
    totalRecordsNumber;
    currentPage = 1;

    get records() {
        return this.visibleRecords;
    }

    @api
    set records(data) {
        if (data) {
            this.totalRecords = data;
            this.totalRecordsNumber = this.totalRecords.length;
            this.totalPages = Math.min(Math.ceil(this.totalRecordsNumber/ this.pageSize), 10);
            this.pageLinks = Array.from({ length: this.totalPages }, (_, index) => index + 1);
            this.updateRecords();
        }
    }

    renderedCallback(){
        this.highlightButtonsBasedOnCurrentPage();
    }

    highlightButtonsBasedOnCurrentPage() {
        const buttons = this.template.querySelectorAll('lightning-button');
        buttons.forEach((button) => {
            const page = parseInt(button.value, 10);
            if(this.currentPage === page) {
                button.classList.add('currentPage');
                button.blur();
            } else {
                button.classList.remove('currentPage');
            }
        });
    }

    get isPrevDisabled() {
        return this.currentPage <= 1;
    }

    get isNextDisabled() {
        return this.currentPage >= this.totalPages;
    }

    handlePrev() {
        if(this.currentPage > 1) {
            this.currentPage -= 1;
            this.updateRecords();
        }
    }

    handleNext() {
        if(this.currentPage < this.totalPages) {
            this.currentPage += 1;
            this.updateRecords();
        }
    }

    handlePageButtonClick(event) {
        this.currentPage = event.target.value;
        this.updateRecords();
    }

    updateRecords() { 
        const start = (this.currentPage - 1) * this.pageSize;
        const end = this.pageSize * this.currentPage;
        this.visibleRecords = this.totalRecords.slice(start, end);
        this.dispatchEvent(new CustomEvent('update', { 
            detail: { 
                records:this.visibleRecords
            }
        }))
    }

    @api
    setCurrentPageToOne(){
        if(this.currentPage > 1){
            this.currentPage = 1;
        }
    }
}