<%@include file="/libs/foundation/global.jsp"%>
<cq:includeClientLib categories="jquerysamples" />
<html>
<head>
<meta charset="UTF-8">
<title>Adobe CQ Persist Page</title>
<style>
#signup .indent label.error {
  margin-left: 0;
}
#signup label.error {
  font-size: 0.8em;
  color: #F00;
  font-weight: bold;
  display: block;
  margin-left: 215px;
}
#signup  input.error, #signup select.error  {
  background: #FFA9B8;
  border: 1px solid red;
}
</style>
<script>
$(document).ready(function() {
      
    $('body').hide().fadeIn(5000);
      
$('#submit').click(function() {
    var failure = function(err) {
             alert("Unable to retrive data "+err);
   };
      
    //Get the user-defined values to persist in the database
    var myFirst= $('#first').val() ; 
    var myLast= $('#last').val() ; 
    var myDescription= $('#description').val() ; 
    var myAddress= $('#address').val() ; 
      
    var url = location.pathname.replace(".html", "/_jcr_content.persist.json") + "?first="+ myFirst +"&last="+myLast +"&desc="+myDescription +"&phone="+myAddress;
           
    $.ajax(url, {
        dataType: "text",
        success: function(rawData, status, xhr) {
            var data;
            try {
                data = $.parseJSON(rawData);
                                
                //Set the fields in the forum
                $('#custId').val(data.pk); 
             } catch(err) {
                failure(err);
            }
        },
        error: function(xhr, status, err) {
            failure(err);
        } 
    });
  });
  
}); // end ready
</script>
</head>
<body>
<div class="wrapper">
    <div class="header">
        <p class="logo">Adobe CQ Data Customer Persist Application</p>
    </div>
    <div class="content">
    <div class="main">
    <h1>Adobe CQ Data Persist Example</h1>
        <form name="signup" id="signup">
            <table>
                <tr>
                  <td>
                <label for="first" class="label">First Name:</label>
                 </td>
                 <td>
                <input name="first" type="text" id="first">
                 </td>
                </tr>
        <tr>
                  <td>
                <label for="last" class="label">Last Name:</label>
         </td>
                 <td>    
                <input name="last" type="text" id="last" >
                 </td>
                </tr>
         <tr>
              <td>
               <label for="description">Description:</label>
               </td>
              <td>
                <select id="description"  >
                    <option>Active Customer</option>
                    <option>Past Customer</option>  
                </select>
                </td>
                </tr>
                  <td> 
                <label for="address" class="label">Address:</label>
                      </td>
                 <td>    
                <input name="address" type="text" id="address">
             </td>
                </tr>
        <tr>
                  <td> 
                <label for="custId" class="label">Customer Id:</label>
                        </td>
                 <td>    
                <input name="custId" type="text" id="custId" readonly="readonly">
          </td>
                </tr>
                       
               <tr>
                <td></td>
                <td>
                <input type="button" value="Add Customer!"  name="submit" id="submit" value="Submit">
                </td>
                </tr>
            </table>
        </form>
        </div>
    </div>
</div>
</body>
</html>
