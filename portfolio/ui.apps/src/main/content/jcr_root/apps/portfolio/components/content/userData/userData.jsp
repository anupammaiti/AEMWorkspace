<%@include file="/libs/foundation/global.jsp"%>
<script
  src="https://code.jquery.com/jquery-1.6.1.min.js"
  integrity="sha256-x4Q3aWDzFj3HYLwBnnLl/teCA3RaVRDGmZKjnR2P53Y="
  crossorigin="anonymous"></script>
<cq:includeClientLib categories="userData" />


<script type="text/javascript">

/* Grab the JCR path to the content entry that calls this component
 * with Sling, you cannot call a script, you must call the jcr content
 * node that resolves to the representation (script).
 */
var baseURL = "<%= currentNode.getPath() %>";
 
jQuery(function ($) {

    $('#submit').click(function() {
        var failure = function(err) {
          //  $(".main").unmask();
            alert("Unable to retrive data "+err);

        };


        //Get the user-defined values to persist in the database
        var myFirst= $('#first').val() ; 
        var password= $('#password').val() ; 
        var principalName= $('#principalName').val() ; 


        var url = location.pathname.replace(".html", "/_jcr_content.adduser.json") + "?first="+ myFirst +"&password="+password +"&principalName="+principalName ;
		console.log(url);
        $.ajax(url, {
            dataType: "text",
            success: function(rawData, status, xhr) {
                var serverResponse;
                try {
                    serverResponse = $.parseJSON(rawData);

                    alert(serverResponse.key); 


                } catch(err) {
                    failure(err);
                }
            },
            error: function(xhr, status, err) {
                failure(err);
            } 
        });
      });


 
 
    $('.useraccount-table').flexigrid({
        url: baseURL + '.json', // this will trigger the JSON selector in Sling  
        dataType: 'json', // NOTE: Flexigrid executes a POST, not GET to retrieve data
        colModel : [ {
            display : 'User ID', name : 'id', width : 215, sortable : true, align : 'left', hide: false
        }, {
            display : 'First Name', name : 'givenName', width : 100, sortable : true, align : 'left', hide: false
        }, {
            display : 'Last Name', name : 'familyName', width : 100, sortable : true, align : 'left', hide: false
        },{
            display : 'Email', name : 'email', width : 215, sortable : true, align : 'left', hide: false
        }], 
        buttons : [
            {name: 'Add', bclass: 'add', onpress : test},
            {name: 'Edit', bclass: 'edit', onpress : test},
            {name: 'Delete', bclass: 'delete', onpress : test},
            {separator: true}
            ],
       searchitems : [
            {display: 'User ID', name : 'user_id',isdefault: true},
            {display: 'First Name', name : 'givenName'},
            {display: 'Last Name', name : 'familyName'}
            ],
        sortname: "id",
        sortorder: "asc",
        usepager: true,
        title: "Adobe CQ5 Users",
        useRp: true,
        rp: 15,
        showTableToggleBtn: false,
        singleSelect: true,
        width: 700,
        height: 200
    });
});
 
function test() {
    alert("Not implemented yet.");
}
 
</script>
 
<body>
<div class="wrapper">
    <div class="header">
        <p class="logo">Adobe User Manager app</p>
    </div>
    <div class="content">
    <div class="main">
    <h1>Adobe User Manager app</h1>
       
    <form name="signup" id="signup">
     <table>
    <tr>
    <td>
    <label for="first">First Name:</label>
    </td>
     <td>
    <input type="first" id="first" name="first" value="" />
    </td>
    </tr>
    <tr>
    <td>
    <label for="password">Password:</label>
    </td>
     <td>
    <input type="password" id="password" name="password" value="" />
    </td>
    </tr>
     <tr>
    <td>
    <label for="principalName">Principal Name:</label>
    </td>
     <td>
    <input type="principalName" id="principalName" name="principalName" value="" />
    </td>
    </tr>
          
</table>
            <div>
                <input type="button" value="Add A CQ User"  name="submit" id="submit" value="Submit">
            </div>
        </form>
        </div>
    </div>
      <div>
<table class="useraccount-table"></table><!-- Rendered by Flexigrid jQuery plugin -->
</div>
</body>
</html>
