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

    <!-- START : Google Analytics-->
    <script type="text/javascript">
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-16150819-2']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
    </script>
    <!-- END : Google Analytics-->

    <!-- START : Facebook Custom Audience pixel -->
    <script>(function() {
    var _fbq = window._fbq || (window._fbq = []);
    if (!_fbq.loaded) {
    var fbds = document.createElement('script');
    fbds.async = true;
    fbds.src = '//connect.facebook.net/en_US/fbds.js';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(fbds, s);
    _fbq.loaded = true;
    }
    _fbq.push(['addPixelId', '1567725220133768']);
    })();
    window._fbq = window._fbq || [];
    window._fbq.push(['track', 'PixelInitialized', {}]);
    </script>
    <noscript><img height="1" width="1" alt="" style="display:none" src="https://www.facebook.com/tr?id=1567725220133768&amp;ev=PixelInitialized" /></noscript>
    <!-- END : Facebook Custom Audience pixel -->
