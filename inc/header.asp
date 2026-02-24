<%
dim msg, q, qFix, bColor

msg = Session("msg")
Session("msg") = "" %>

	<meta charset="UTF-8">
    <meta property="og:site_name" content="מילון ערבית מדוברת"/>
    <meta property="fb:app_id" content="1067216663704512" />
    <meta property="og:locale" content="he_IL" />
    <meta property="og:locale:alternate" content="ar_JO" />
    <meta property="og:locale:alternate" content="en" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="stylesheet" href="<%=baseA%>assets/css/milon_main.css" />
	<link rel="shortcut icon" href="<%=baseA%>assets/images/site/favicon.ico" />
    <link rel="image_src" href="<%=baseA%>assets/images/site/logo.jpg" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>

    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-3KCSSVHC9Z"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', 'G-3KCSSVHC9Z');
    </script>
