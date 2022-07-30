<%
dim msg, q, qFix, bColor

msg = Session("msg")
Session("msg") = "" %>
	<meta charset="UTF-8">
    <meta property="og:site_name" content="מילון ערבית מדוברת"/>
    <meta property="fb:app_id" content="1567725220133768" />
    <meta property="og:locale" content="he_IL" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="stylesheet" href="css/normalize.css" />
	<link rel="stylesheet" href="css/nav.css" />
    <link rel="stylesheet" href="css/bootstrap.min.css" />
	<link rel="stylesheet" href="css/arabic_constant.css" />
	<link rel="shortcut icon" href="img/site/favicon.ico" />
    <link rel="image_src" href="img/site/logo.jpg" />

    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-3KCSSVHC9Z"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', 'G-3KCSSVHC9Z');
    </script>
