<!--#include file="inc/inc.asp"--><%
  if session("role") < 6 then
    session("msg") = "אין לך הרשאה מתאימה לצפייה בדף המבוקש"
    response.redirect "test.asp"
  end if %>
<!DOCTYPE html>
<html>
<head>
    <title>ארגז חול - JSON</title>
	<meta name="robots" content="noindex" />
    <!--#include file="inc/header.asp"-->
	<link rel="stylesheet" href="css/test.css" />
    <script  src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script>

        $(function() {
            $("#words").hide();
            $("#chosenID").hide();
            $("#chosenWord").hide();
            //keyboard event
           $("#input").keyup(function(){
            var search = $(this).val();
            if (search !== ""){
            //get json data from the server   
            $.getJSON("json.asp",  {"search":search} , function(json){
               //empty the datalist
                $("#words").empty();
                //populate the datalist by the json data
                $.each(json, function(i, item) {
                    $("#words").append($("<option class='sup'>").attr('value', item.id).text(`${item.hebrew} - ${item.arabic}`));
                });
                $("#words").attr("size", json.length);
                if (json.length > 0) $("#words").show();
            });
            } else {
                $("#words").empty().hide();
            }
           });
           
           //onclick option

            $("#words").change(function(){ 
                var value = $(this).val();
                var word = $("#words :selected").text();
                $("#words").slideUp(400);
                $("#input").hide();
                $("#chosenID").attr("value",value).show();
                $("#chosenWord").attr("value",word).show();
                console.log (value);
            });


            //    $("option").click(function(){
            //        console.log ("HEY");
            //        var value = $(this).val();
            //    });
        });

        
    </script>
    <style>
        select {
            DISPLAY: BLOCK;
            BORDER: 1px solid gray;
            margin: 10px;
            padding: 10px;
            background: white;
            width:100%;
        }

        select option {
            border-bottom:1px dotted gray;
            padding: 2px 0;
            font-size: 1.2em;
            cursor:pointer;
        }
        select option:hover {
            background:yellow;
        }
    </style>
</head>
<body dir="rtl">
<!--#include file="inc/top.asp"-->


<div id="bread">
	<a href=".">מילון</a> / 
	<a href="TEST.asp">ארגז חול</a> / 
    <h1>JQUERY + JSON - ניסוי לעבודה א-סינכרונית</h1>
</div>

<div class="table" style="margin:50px auto; border:1px solid gray; padding:20px;">

    <label for="input">חפש מילה</label>
    <input id="input" name="words"/>
    <input id="chosenID" type="text" value="" DISABLED style="max-width:60px;" /> 
    <input id="chosenWord" type="text" value="" DISABLED /> 
    <br>
    <select id="words">
    </select> 

    <datalist STYLE="DISPLAY:NONE;" id="X_words">
    </datalist> 
</div>

<!--#include file="inc/trailer.asp"-->