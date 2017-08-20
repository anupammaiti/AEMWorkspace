<%@include file="/libs/foundation/global.jsp"%>
<cq:includeClientLib categories="jquerysamples" />
<html>
<head>
<meta charset="UTF-8">
<title>CQ Email Form</title>
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
        $(".main").unmask();
        alert("Unable to retrive data "+err);
        // TODO - clear the form
    };

    //Get the values to pass to the Mail OSGi bundle
    var server = $('#host').val() ; 
    var to = $('#toAddress').val() ; 
    var subject = $('#subject').val() ; 
    var message = $('#message').val() ; 

    var url = location.pathname.replace(".html", "/_jcr_content.email2.json") + "?to="+ to +"&server="+server +"&subject="+subject +"&message="+message;

    $(".main").mask("Sending...");

    $.ajax(url, {
        dataType: "text",
        success: function(rawData, status, xhr) {

            try {

                $(".main").unmask();
                $('#toAddress').val('');
                $('#subject').val('');
                $('#message').val('');
                $('#popup').show();
               $('#popup').fadeOut(5000);



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
        <p class="logo">Adobe CQ Email Client</p>
    </div>
    <div class="content">
    <div class="main">
    <h1>CQ Email Service Example</h1>
     <form name="signup" id="signup">
        <table>
        <tr>
            <td>

                <label for="host" class="label">Email Server:</label>
             </td>
             <td>   
                <input name="host" value="mymailServer.com"type="text" id="host" >
                </td>
            </tr>
            <tr>
            <td>
                <label for="toAddress" class="label">To:</label>
            </td>
            <td>    
                <input name="toAddress" type="text" id="toAddress" >
            </td>
            </tr>
            <tr>
            <td>
               <label for=subject class="label">Subject:</label>
            </td>
            <td>   
                <input name="subject" type="text" id="subject" >
            </td>
            </tr>
            <tr>
            <td>
                   <label for="message" class="label">Message:</label>
            </td>
            <td>
                <textarea rows="3" cols="40" id="message">
                           </textarea>
            </td>
            </tr>     

          <tr>
          <td>   
              <input type="button" value="Click me!"  name="submit" id="submit" value="Submit">
           </td>
           <td>
                       <div  style="display:none" id="popup">
            <h3  display=false backgroundcolor="#8B8989"> email was successfully sent</h3>
            </div>
            </td>
            </tr>
            </table>
        </form>
        </div>
    </div>
     
</div>
</body>
</html>