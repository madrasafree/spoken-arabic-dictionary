<!--#include file="inc/functions/functions.asp"-->
<html>
<head>
    <meta charset="UTF-8">
    <style>
      @font-face {font-family:"keter"; src: url("inc/fonts/KeterYG-Medium.ttf");}
      @font-face {font-family:"NotoSans"; src: url("inc/fonts/NotoSansHebrew-Thin.ttf");}
      @font-face {font-family:"NotoSerif"; src: url("inc/fonts/NotoSerifHebrew-Regular.ttf");}


      body {font-size:large;}
      h2 { font-size:large; margin:4px;}

      .demo {font-size: 3em;}
      .keter {font-family:"keter";}
      .notoSans {font-family:"notoSans";}
      .shofar {font-family:"shofar";}
      .NotoSerif {font-family:"NotoSerif";}

    </style>
</head><%
Function IsUnicode(stringValue)
   IsUnicode = False
   If Asc(Left(stringValue, 1)) <= 0 Or Asc(Left(stringValue, 1)) >= 239 Then
      IsUniCode = True
   End If
End Function

%>


<body>
<div style="max-width:600px; margin:0 auto; border:1px solid gray;">

   <div>מצב רגיל : מַרַّה</div><%
   dim ht,stam,jHeb
   ht = "מַרַّה"
   stam = "מַרַה"
   jHeb = "מרה"
   'ht=Replace(ht,chrw(&H0651),chrw(&hFB1E))
   %>
   <div>ht=<%=ht%></div>
   <div>stam = <%=stam%></div>
   <div>jHeb = <%=jHeb%></div>
   <div>chr(U+0651)=<%=chr(U0651)%></div>
   <div>IsUnicode(ht) = <%=IsUnicode(ht)%></div>
   <div>IsUnicode(stam) = <%=IsUnicode(stam)%></div>
   <div>IsUnicode(jHeb) = <%=IsUnicode(jHeb)%></div>


   <div>chrw(&H0651) : א<%=chrw(&H0651)%></div>
   <div>chrw(&hFB1E) : א<%=chrw(&hFB1E)%></div>
   <div>chrw(64) : א<%=chrw(64)%></div>
   <div>chrw(65) : א<%=chrw(65)%></div>
</div>
 <%
 dim temp
 temp = Replace("לֻّעַّ׳ה אַّגְ׳נַבִּיֵّה",chrw(&H0651),chrw(&hFB1E))
 %>

<div class="demo keter">
   <h2>KETER FONT</h2>
   <div>לֻע׳ה אגְ׳נַבִּיה</div>
   <div>לֻעַ׳ה אַגְ׳נַבִּיֵה</div>
   <div><%=temp%></div>
   <div>לֻّעַّ׳ה אַّגְ׳נַבִּיֵّה</div>
   <div>לֻّעַّ׳הّ אַّגְّ׳נַّבִּّיֵّהّ</div>
</div>

<div class="demo notoSans">
   <h2>notoSans FONT</h2>
   <div>לֻע׳ה אגְ׳נַבִּיה</div>
   <div>לֻעַ׳ה אַגְ׳נַבִּיֵה</div>
   <div><%=temp%></div>
   <div>לֻّעַّ׳ה אַّגְ׳נַבִּיֵّה</div>
   <div>לֻّעַّ׳הّ אַّגְّ׳נַّבִּّיֵّהّ</div>
</div>

<div class="demo NotoSerif">
   <h2>NotoSerif FONT</h2>
   <div>לֻע׳ה אגְ׳נַבִּיה</div>
   <div>לֻעַ׳ה אַגְ׳נַבִּיֵה</div>
   <div><%=temp%></div>
   <div>לֻّעַّ׳ה אַّגְ׳נַבִּיֵّה</div>
   <div>לֻّעַّ׳הّ אַّגְّ׳נַّבִּّיֵّהّ</div>
</div>


</body>
</html>