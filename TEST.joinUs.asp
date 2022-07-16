<!--#include file="inc/inc.asp"--><%
if (session("role") and 7) = 0 then Response.Redirect "login.asp" 
dim countme,eMail,username,fName,lName,gender,about,aboutTemp
countme = 0 
eMail = replace(request("email"),"'","")
username = replace(request("username"),"'","")
fName = replace(request("fName"),"'","")
lName = replace(request("lName"),"'","")
gender = request("gender")
if len(gender)=0 then gender = 1
about = request("about")
if len(about)>0 then
    aboutTemp = left(about,len(about)-1)
    about = right(aboutTemp,len(aboutTemp)-1)
end if %>
<!DOCTYPE html>
<html>
<head>
	<title>הצטרפות למילון</title>
    <meta name="robots" content="none">
    <script src="//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.3.min.js"></script>
<!--#include file="inc/header.asp"-->
    <style>
            .boxes2 {width:90%; max-width:500px; margin:20px auto;}
            .box {width:100%; }
            .boxsub2 > div {margin:10px;}
            .line2 {margin:10px 20px;}
            .line2 > input { padding: 4px; border:1px dotted #cccccc; width:95%;}
            label > span {font-size:small;}
            input:invalid {border:1px solid red;}
    </style>
</head>
<body>
<!--#include file="inc/top.asp"-->

<h1 style="text-align:center;">טופס הצטרפות למילון</h1>

<div id="page">

    <form action="/arabic/team/user.insert.asp" method="post" id="new" name="new">

    <div class="boxes2" style="max-width:400px;">
        <div class="box" style="background-color:rgba(212, 234, 255, 0.5);">
            <div class="boxSub2" style=" padding-top:1px;">
                <div class="line2">
                    <label>דואר אלקטרוני</label>
                    <input maxlength="50" type="email" id="email" name="email" required dir="ltr" autofocus="true" value="<%=eMail%>" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,6}$" title="יש להזין דואר אלקטרוני בפורמט תקני">
                </div>
                <div class="line2">
                    <label>בחר/י שם משתמש <span>לועזית</span></label>
                    <input maxlength="12" type="text" name="username" required dir="ltr" pattern="[A-Za-z]{5,12}" title="חייב להיות בין 5 ל-12 אותיות לועזיות" value="<%=username%>">
                </div>
                <div class="line2">
                    <label>בחר/י סיסמא <span>לועזית</span></label>
                    <input maxlength="20" type="password" name="password" required dir="ltr" pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,20}" title="חייב להכיל אות גדולה, אות קטנה וספרה">
                </div>
                <div class="line2" style="width:40%; display:inline-block; margin:10px 20px 20px 0px; ">
                    <label>שם פרטי <span>בעברית</span></label>
                    <input maxlength="20" type="text" name="firstName" value="<%=fName%>" pattern="[א-ת]{2,20}" required title="בין 2 ל-20 תווים עבריים בלבד">
                </div>
                <div class="line2" style="width:40%; display:inline-block; margin:10px 20px 20px 0px; ">
                    <label>שם משפחה <span>בעברית</span></label>
                    <input maxlength="20" type="text" name="lastName" value="<%=lName%>" pattern="[א-ת]{2,20}" required title="בין 2 ל-20 תווים עבריים בלבד">
                </div>
            </div>
            <div class="boxSub2">
                <div style="margin:0 20px 20px 0;">
                    <label style="margin-left:15px;">פנו אלי בלשון:</label>
                    <input type="radio" name="gender" style="margin-left:5px;" value="1" <%if gender=1 then%>checked<%end if%>>זכר
                    <input type="radio" name="gender" style="margin-left:5px; margin-right:10px;" value="2" <%if gender=2 then%>checked<%end if%>>נקבה
                </div>
            </div>
            <div class="boxSub2" style="padding-bottom:1px;">
                <div class="line2">
                    <label>כמה מילים על הקשר שלך לערבית <br/><span>רשות. יופיע בדף הפרופיל שלך</span></label>
                    <textarea style="display:block; width:100%;height:150px;" id="about" name="about" maxlength="255"><%=about%></textarea>
                </div>
            </div>
        </div>
    </div>
	
    <div style="width:90%; margin:20px auto; text-align: center;">
        <input style="font-size: large;padding: 10px; width:150px;" type="submit" value="יאללה!" name="Submit1" id="Submit1" />
    </div>
</div>


<!--#include file="inc/trailer.asp"-->
<script type="text/javascript" src="js/scripts.js"></script>
</body>
</html>