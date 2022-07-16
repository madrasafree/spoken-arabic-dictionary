<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <META NAME="ROBOTS" CONTENT="NOINDEX" />
	<title>תגובות</title>
	<meta name="Description" content="המקום שלכם להגיב" />
	<!--#include file="inc/header.asp"-->
    <meta property="fb:app_id" content="212260402169980" />
        <style>
        #disqus_thread { max-width:600px; margin: 0 auto; }
        .fb-comments { max-width:600px; margin: 0 auto;}
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->

<div id="pTitle">תגובות</div>

הקוד שלהם כאן מ-2015, צריך לעדכן אותו
<!--Disqus Start-->
<div id="disqus_thread"></div>
<script type="text/javascript">
    /* * * CONFIGURATION VARIABLES * * */
    // Required: on line below, replace text in quotes with your forum shortname
    var disqus_shortname = 'arabic4hebs';
    
    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>

<script type="text/javascript">
    /* * * CONFIGURATION VARIABLES * * */
    // Required: on line below, replace text in quotes with your forum shortname
    var disqus_shortname = 'arabic4hebs';
    
    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function () {
        var s = document.createElement('script'); s.async = true;
        s.type = 'text/javascript';
        s.src = '//' + disqus_shortname + '.disqus.com/count.js';
        (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s);
    }());
</script>
<!--Disqus End-->

<!--FB comments Start-->
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/he_IL/sdk.js#xfbml=1&version=v2.3&appId=212260402169980";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>

<div style="width:600px;margin: 0 auto;"><%
    dim fbURI
    fbURI = Len(Request.ServerVariables("url"))
    fbURI = fbURI-6 %>
    <div class="fb-comments" data-href="http://ronen.rothfarb.info<%=right(Request.ServerVariables("url"),fbURI)%>" data-width="600" data-numposts="5" data-colorscheme="light"></div>
</div>
<!--FB comments End-->


<!--#include file="inc/trailer.asp"-->