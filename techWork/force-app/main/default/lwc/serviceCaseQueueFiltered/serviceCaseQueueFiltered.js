import {LightningElement, track, wire} from 'lwc';
import getCases from '@salesforce/apex/ServiceCaseQueueService.getUserCases';
import { getObjectInfo, getPicklistValues } from "lightning/uiObjectInfoApi";
import CASE_OBJECT from '@salesforce/schema/Case';
import STATUS_FIELD from "@salesforce/schema/Case.Status";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from "@salesforce/apex";
import updateCase from '@salesforce/apex/ServiceCaseQueueService.updateCase';
import getUserCasesNew from '@salesforce/apex/ServiceCaseQueueService.getUserCasesNew';
import IdUser from "@salesforce/user/Id";
export default class ServiceCaseQueueFiltered extends NavigationMixin(LightningElement) {

   @track cases = [];
   isLoading  = false;
    @track caseInfo;
    @track caseStatuses = [];

   
   @wire( getObjectInfo, { objectApiName: CASE_OBJECT })  
   results({ error, data }) {
    if (data) {
      this.caseInfo = data.defaultRecordTypeId;
      this.error = undefined;
      console.log('infoObject'+data);
    } else if (error) {
      this.error = error;
      this.caseInfo = undefined;
    }
    } 

   @wire(getPicklistValues,
       {
           recordTypeId: "$caseInfo",
           fieldApiName: STATUS_FIELD
       }
   )  
   picklistResults({ error, data }) {
    if (data) {
      this.caseStatuses = data.values;
      this.error = undefined;
      console.log('Statuses'+ data);
      console.log('currentUser'+ IdUser);
    } else if (error) {
      this.error = error;
      console.log('StatusesDontLoad'+ data);
      this.caseStatuses = undefined;
    }
    }

    @wire (getCases)
    retrieveCases({ error, data }) {
        if(data) {
            this.cases = data;
            console.log('Data loaded'+this.caseInfo);
        }
        else if(error) {
            this.error = error;

        }
    }
  
    async refreshTable () {
        this.isLoading = true;
        try {
            console.log('click');
            await getUserCasesNew().then(data => {this.cases=data});
            refreshApex(this.cases);
            this.isLoading = false;
          } catch (error) {
            // handle error
          }

    }


    async changeStatus(event) {
        const findRecordCases = event.currentTarget.dataset.id;
        const findRecordCaseStatus = event.currentTarget.value;
        try {
          this.isLoading = true;
          await updateCase({caseNumber:findRecordCases, caseStatus:findRecordCaseStatus});
          await getUserCasesNew().then(data => {this.cases=data});
          refreshApex(this.cases);
          this.isLoading = false;
          this.dispatchEvent(
            new ShowToastEvent({
                title : 'Success',
                message : `Record saved succesfully!`,
                variant : 'success',
            }),
         )
        } catch {
          this.dispatchEvent(
            new ShowToastEvent({
                title : 'Error!',
                message : `Record dosnt saved `,
                variant : 'error',
            }),
        )
        }


    }
    navigateToCase (event) {
        const recordId = event.currentTarget.dataset.id;
        console.log(recordId);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: 'Case',
                actionName: 'view'
            }
        });
    }

}
