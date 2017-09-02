<%@include file="/libs/foundation/global.jsp"%>
<html>
   
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
     
<div>
       
<link href="http://code.jquery.com/mobile/1.0a2/jquery.mobile-1.0a2.min.css" rel="stylesheet">
       
<link href="css/colors.css" rel="stylesheet">
       
<script src="http://code.jquery.com/jquery-1.6.3.min.js"></script>
      <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.5.3/jquery-ui.min.js" type="text/javascript"></script>
      <script src="http://code.jquery.com/mobile/1.0a2/jquery.mobile-1.0a2.min.js"></script>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
     
 
  <script>
$(document).ready(function() {
 
    $('body').hide().fadeIn(5000);
        
$('#submit').click(function() {
    var failure = function(err) {
             alert("Unable to retrive data "+err);
   };
 
    //Get the user-defined values to persist in the database
    var myFirst= $('#FirstName').val() ; 
    var myLast= $('#LastName').val() ; 
    var date= $('#DateId').val() ; 
    var cat= $('#Cat_Id').val() ; 
     var state= $('#State_Id').val() ; 
     var details= $('#Explain').val() ; 
     var city= $('#City').val() ; 
     var address= $('#Address').val() ; 
 
    var url = location.pathname.replace(".html", "/_jcr_content.mobile.json") + "?first="+ myFirst + "&last="+ myLast + "&address="+ address + "&city="+ city + "&details="+ details + "&state="+ state + "&date="+ date + "&cat="+ cat;
 
    $.ajax(url, {
        dataType: "text",
        success: function(rawData, status, xhr) {
            var data;
            try {
                data = $.parseJSON(rawData);
                                  
                //Set the fields in the forum
                $('#ClaimNum').val(data.claimId); 
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
   
<title>formTitle</title>
   
<body>
     
<div data-role="page" data-theme="a">
       
<div data-role="content" id="contentMain" name="contentMain">
         
<div data-nobackbtn="true" data-role="header" id="hdrMain" name="hdrMain">
           
<h1>Adobe CQ Mobile Claim Form</h1>
         
</div>
         
<form method="#">
   
       
<div data-role="fieldcontain" id="RequestNumDiv">
             
<label for="ClaimNum" id="ClaimNumLabel" name="ClaimNumLabel">A. Claim Number      </label>
            <input id="ClaimNum" name="A1. Claim Number" readonly=true type="text" value="">
           
</div>
 
<div data-role="fieldcontain" id="ProjectTitleDiv">
             
<label for="DateId" id="DateIncident" name="DateIncident">A.2. Date of Incident     </label>
            <input id="DateId" name="A.2 Date of Incident     " type="text" value="">
           
</div>    
           
<div data-role="fieldcontain" id="RequestTitleDiv">
             
<label for="FirstName" id="FirstNameLabel" name="FirstNameLabel">B2. First Name     </label>
            <input id="FirstName" name="B1. First Name    " type="text" value="">
           
</div>
           
<div data-role="fieldcontain" id="LastNameDiv">
             
<label for="LastName" id="LastNameLabel" name="LastNameeLabel">C1. Last Name     </label>
            <input id="LastName" name="C1. Last Name     " type="text" value="">
           
</div>
           
<div data-role="fieldcontain" id="Cat_IdDiv">
 
<label for="Cat_Id">D1. Category </label>
            <select id="Cat_Id" name="Category ">
              <option value="Home">Home Claim</option>
              <option value="Auto">Auto Claim</option>
              <option value="Boat">Boat Claim</option>
              <option value="Personal">Personnal Claim</option>
            </select>
           
</div>
 
<div data-role="fieldcontain" id="AddressDiv">
             
<label for="Address" id="AddressLabel" name="AddressLabel">E1. Address   </label>
            <input id="Address" name="Address   " type="text" value="">
           
</div>
           
<div data-role="fieldcontain" id="CityDiv">
 
<label for="City" id="CityLabel" name="CityLabel">F1. City   </label>
            <input id="City" name="City   " type="text" value="">
           
</div>
 
<div data-role="fieldcontain" id="ExplanDiv">
 
<label for="Explain" id="ExplainLabel" name="ExplainLabel">G1. Additional Details  </label>
    <input id="Explain" name="Explain   " type="text" value="">
           
</div>    
           
<div data-role="fieldcontain" id="State_IdDiv">
 
<label for="State_Id">H1. State </label>
            <select id="State_Id" name="State ">
              <option value="Alabama">Alabama</option>
              <option value="Alaska">Alaska</option>
              <option value="Arizona">Arizona</option>
              <option value="Arkansas">Arkansas</option>
              <option value="California">California</option>
              <option value="Colorado">Colorado</option>
              <option value="Connecticut">Connecticut</option>
              <option value="Delaware">Delaware</option>
              <option value="District of Columbia">District of Columbia</option>
              <option value="Florida">Florida</option>
              <option value="Georgia">Georgia</option>
              <option value="Hawaii">Hawaii</option>
              <option value="Idaho">Idaho</option>
              <option value="Illinois">Illinois</option>
              <option value="Indiana">Indiana</option>
              <option value="Iowa">Iowa</option>
              <option value="Kansas">Kansas</option>
              <option value="Kentucky">Kentucky</option>
              <option value="Louisiana">Louisiana</option>
              <option value="Maine">Maine</option>
              <option value="Maryland">Maryland</option>
              <option value="Massachusetts">Massachusetts</option>
              <option value="Michigan">Michigan</option>
              <option value="Minnesota">Minnesota</option>
              <option value="Mississippi">Mississippi</option>
              <option value="Missouri">Missouri</option>
              <option value="Montana">Montana</option>
              <option value="Nebraska">Nebraska</option>
              <option value="Nevada">Nevada</option>
              <option value="New Hampshire">New Hampshire</option>
              <option value="New Jersey">New Jersey</option>
              <option value="New Mexico">New Mexico</option>
              <option value="New York">New York</option>
              <option value="North Carolina">North Carolina</option>
              <option value="North Dakota">North Dakota</option>
              <option value="Ohio">Ohio</option>
              <option value="Oklahoma">Oklahoma</option>
              <option value="Oregon">Oregon</option>
              <option value="Pennsylvania">Pennsylvania</option>
              <option value="Rhode Island">Rhode Island</option>
              <option value="South Carolina">South Carolina</option>
              <option value="South Dakota">South Dakota</option>
              <option value="Tennessee">Tennessee</option>
              <option value="Texas">Texas</option>
              <option value="Utah">Utah</option>
              <option value="Vermont">Vermont</option>
              <option value="Virginia">Virginia</option>
              <option value="Washington">Washington</option>
              <option value="West Virginia">West Virginia</option>
              <option value="Wisconsin">Wisconsin</option>
              <option value="Wyoming">Wyoming</option>
            </select>
 
</div>
 
<div>
        <input type="button" value="Submit"  name="submit" id="submit" value="Submit">
 </div>
 
</form>
 
</div>
     
</div>
 
</body>
 
</html>
