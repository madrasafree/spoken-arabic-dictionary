<!-- Language="VBScript" CodePage="65001"-->
<!-- Language="VBScript" CodePage="1255"--><%
dim msg, q, qFix, bColor

msg = Session("msg")
Session("msg") = "" %>
	<meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <!--base href="<%=baseA%>" target="_blank"-->
	<link rel="stylesheet" href="<%=baseA%>assets/css/milon_main.css" />
	<%
  If (session("role") and 2) > 0 then %>
  <link rel="stylesheet" href="../assets/css/arabicTeam.css" /><%
  end if%>
	<link rel="shortcut icon" href="../assets/images/team/teamFavicon.ico" />
  <link rel="image_src" href="<%=baseA%>assets/images/site/logo.jpg" />
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>


  <!-- Global site tag (gtag.js) - Google Analytics -->
  <script async src="https://www.googletagmanager.com/gtag/js?id=G-3KCSSVHC9Z"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'G-3KCSSVHC9Z');
  </script>
