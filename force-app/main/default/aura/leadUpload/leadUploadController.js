({
	submit : function(component, event, helper) {
        
        var fileInput  = component.find("file").getElement();
        var file = fileInput.files[0];
        console.log(file);

        var reader = new FileReader();
   
        reader.onload = function (e) {
            var fileContent = reader.result;
        	var base64 = 'base64,';
    		var dataStart = fileContent.indexOf(base64) + base64.length;
    		fileContent = fileContent.substring(dataStart)
            console.log(fileContent);
            
            var jobID = component.get("v.jobID");
            var recID = component.get("v.recID");
            
            var action = component.get("c.POST");
            action.setParams({ file : fileContent, jobID : jobID });
     		action.setCallback(this, function(response) {
                var returnValue = response.getReturnValue();
            	console.log(returnValue);
            
            	component.set("v.message", returnValue);
            });
            $A.enqueueAction(action);
        };
        reader.readAsDataURL(file);
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'sticky',
            message: 'Success',
        	messageTemplate: '{0} record created! See it {1}!',
        	messageTemplateData: ['Job', {
            	url: 'https://sdodemo-main-166ce2cf6b6-171-1720a2753f1.force.com/partnercentral/s/job/a045w000045g6rBAAQ',
            	label: 'here',
            	}
        	]
        });
        toastEvent.fire();
	},
    click : function(component, event, helper) {
        
        var input = component.find("file").getElement();
        input.click();
        
        var action = component.get("c.createJob");
        action.setCallback(this, function(response) {
                var returnValue = response.getReturnValue();
            	console.log(returnValue);
            	
            	component.set("v.recID", returnValue[0]);
            	component.set("v.jobID", returnValue[1]);
            });
            $A.enqueueAction(action);
        
        window.setTimeout(
    		$A.getCallback(function() {
        		$A.util.removeClass(component.find('previewContainer'),"slds-hide");
    		}), 5000
		)
    },
})