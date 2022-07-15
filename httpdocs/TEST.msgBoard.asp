<html><%
Function getRND(nLow, nHigh)
  Randomize
  getRND = right("000"+cstr(Int((nHigh - nLow + 1) * Rnd + nLow)),3)
End Function %>
<head>
    <META NAME="ROBOTS" CONTENT="NOINDEX" />
    <meta charset="UTF-8">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script> 
 
    <script>    
    function getRndInt(min, max) {
        var x = "000"+(Math.floor(Math.random() * (max - min + 1) ) + min).toString();
        return x.substring(x.length-3,x.length);
    }

    $(function(){
      $("#includedContent").load("test.msg"+getRndInt(1,3)+".html"); 
    });
    </script> 

</head>
<body>
<h1>TEST - (Random) Message Board</h1>

<div id="includedContent"></div>

</body>
</html>