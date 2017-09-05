<%@include file="/libs/foundation/global.jsp"%>
<script
  src="https://code.jquery.com/jquery-1.6.1.min.js"
  integrity="sha256-x4Q3aWDzFj3HYLwBnnLl/teCA3RaVRDGmZKjnR2P53Y="
  crossorigin="anonymous"></script>
<cq:includeClientLib categories="userData" />
<cq:includeClientLib categories="queryBuilder" />
<script type="text/javascript">
  

jQuery(function ($) {
  
 
$("#flex1").flexigrid(
{
        dataType: 'json',
        colModel : [
        {display: 'Num', name : 'id', width : 100, sortable : true, align: 'left'},
        {display: 'Asset Path', name : 'name', width : 500, sortable : true, align: 'left'},

    ],
    buttons : [
    {name: 'Report', bclass: 'report', onpress : test},
    {name: 'Deactivate', bclass: 'delete', onpress : test},
    {name: 'FormIT', bclass: 'view', onpress : test},
    {separator: true}
    ],
        searchitems : [
            {display: 'First Name', name : 'first_name'},
            {display: 'Surname', name : 'surname', isdefault: true},
            {display: 'Position', name : 'position'}
        ],
    sortname: "id",
    sortorder: "asc",
    usepager: true,
    title: "Results for term Geometrixx",
    useRp: true,
    rp: 10,
    showTableToggleBtn: false,
    resizable: true,
    width: 1000,
    height: 470,
    singleSelect: true
    }
);


$('#submit').click(function() {
var failure = function(err) {

  alert("Unable to retrive data "+err);
  };


  var url = location.pathname.replace(".html", "/_jcr_content.queryBuilder.json");

  $.ajax(url, {
          dataType: "text",
          success: function(rawData, status, xhr) {
              var data;
              try {
                  data = $.parseJSON(rawData);

                  var val = data.xml  ;        

                //Display the results in the Grid control
              var jsonObj = []    ;
              var index = 1 ; 
 
              $(val).find('result').each(function(){
 
                      var Template = {};
                      var field = $(this);
 
                      Template["id"] =  index; 
                      Template["name"] =  $(field).find('path').text();
     
                      //Push JSON
                      jsonObj.push(Template)   ;
                      index++; 
 
          });
 
    //Populate the Flexigrid control
     var gridData =  formatCustomerResults(jsonObj)  ; 
     $("#flex1").flexAddData(eval(gridData));
                    
      } catch(err) {
          failure(err);
          }
      },
      error: function(xhr, status, err) {
              failure(err);
      } 
  });
   });
   
       
});
  
function test() {
    alert("Not implemented yet.");
}
 
function formatCustomerResults(Templates){
 
    var rows = Array();
    var temp =      Templates ;
 
    for (i = 0; i <temp.length; i++) {
        var item = temp[i];
 
        rows.push({ cell: [item.id,
            item.name
        ]
        });
    }
 
    var len =  temp.length;

    return {
        total: len,
        page: 1,
        rows: rows
    }
 
};
 
  
</script>
  
<body>
<h2>Adobe AEM Query Builder Example Application</h2>
 
 <table id="flex1" width="1050">
 
 </table>
  
 <input type="button" value="Search CQ"  name="submit" id="submit" value="Submit">
                    
</body>
</html>
