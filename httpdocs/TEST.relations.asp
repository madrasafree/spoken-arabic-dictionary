<!--#include file="inc/inc.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <META NAME="ROBOTS" CONTENT="NOINDEX" />
	<title>קשרים בין מילים</title>
	<meta name="Description" content="דף זמני שמציג קשרים בין מילים במילון" />
    <!--#include file="inc/header.asp"-->
    <style>
        #relMenu {DISPLAY:NONE; text-align:center; margin:0 auto;}
        #relMenu td {padding:4px;}
        #relMenu img {object-fit:cover; height:44px; width:64px; background:white; border:1px solid gray;}
        #relMenu img:hover {background:#eee; cursor:pointer;}

        #showing {
            text-align: center;
            padding: 10px;
            background: #fdff7394;
            margin: 0 auto 10px auto;
            border-radius: 20px;
            color: #777715;            
        }

        #toggleRelMenu {
            background-color: #7994b2;
            border: none;
            color: white;
            padding: 8px 30px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            letter-spacing: 0.2em;
        }


    </style>
    <script>
        $(document).ready(function() {

            $(".relation").hide();
            $(".relation[data-type='4']").show();
            countShow();

            $("#toggleRelMenu").click(function() {
                $("#relMenu").slideToggle(800);    
            });


            var prevTName;

            $("#relMenu").find("img")
                .mouseover(function() {
                    prevTName = $("#typeName").text();
                    //alert(prevTName);
                    var tName = $(this).attr("alt");
                    $("#typeName").text(tName);
                })
                .mouseout(function() {
                    $("#typeName").text(prevTName);
                });

            
            $("#relMenu").find("img").click(function(){
                var tID = $(this).data("type");
                $(".relation").hide();
                $(".relation[data-type='"+tID+"']").show();
                var tName = $(this).attr("alt");
                $("#typeName").text(tName);
                prevTName = tName;
                $("#relMenu").slideToggle(800);

                countShow();
            });



            function countShow() {
                var countShow = $(".relation").filter(function() {
                    return $(this).css('display') !== 'none';
                }).length;
                $("#showing").html("מציג "+ countShow +" קשרים מתוך " + $("#countAll").text() + " סך הכל");
            }

        });
    </script>
</head>
<body>
<!--#include file="inc/top.asp"-->

<div id="pTitle">קשרים בין מילים</div>

<div class="table">
    <table style="width:100%;">
        <tr>
            <td style="width:80%">
                <h2 style="display:inline-block;" id="typeName">זכר - נקבה</h2>
            </td>
            <td style="width:20%">
                <button id="toggleRelMenu" title="בחר סוג קשר על מנת להציג את הרשימה הרלוונטית">תפריט</button>
            </td>
        </tr>
    </table>
</div>

<div class="table" id="relMenu">
    <table>
        <tr>
            <td><img data-type="4" src="img/site/rel_gen_f.png" alt="זכר - נקבה" title="זכר - נקבה" /></td>
            <td><img data-type="3" src="img/site/rel_num_plrl.png" alt="יחיד - רבים" title="יחיד - רבים" /></td>
            <td><img data-type="6" src="img/site/rel_snd_arb.png" alt="נשמע כמו - בערבית" title="נשמע כמו - בערבית" /></td>
            <td><img data-type="7" src="img/site/rel_snd_heb.png" alt="נשמע כמו - בעברית" title="נשמע כמו - בעברית" /></td>
            <td><img data-type="2" src="img/site/rel_syn_arb.png" alt="מילה נרדפת - ערבית" title="מילה נרדפת - ערבית" /></td>
            <td><img data-type="1" src="img/site/rel_syn_heb.png" alt="מילה נרדפת - עברית" title="מילה נרדפת - עברית" /></td>
        </tr>
        <tr>
            <td><img data-type="8" src="img/site/rel_res_after.png" alt="תגובה" title="תגובה" /></td>
            <td><img data-type="5" src="img/site/rel_ops.png" alt="הפכים" title="הפכים" /></td>
            <td><img data-type="99" src="img/site/rel_dup.png" alt="כפילויות" title="כפילויות" /></td>
            <td><img data-type="10" src="img/site/empty.png" alt="צירופים" title="צירופים" /></td>
            <td><img data-type="20" src="img/site/empty.png" alt="נגזרות" title="נגזרות" /></td>
            <td><img data-type="60" src="img/site/empty.png" alt="פעיל - סביל" title="פעיל - סביל" /></td>
        </tr>
        <tr>
            <td><img data-type="12" src="img/site/empty.png" alt="משמעות נוספת בעברית" title="משמעות נוספת בעברית" /></td>
            <td><img data-type="13" src="img/site/empty.png" alt="משמעות נוספת בערבית" title="משמעות נוספת בערבית" /></td>
            <td><img data-type="50" src="img/site/empty.png" alt="בינוני פועל" title="בינוני פועל" /></td>
            <td><img data-type="52" src="img/site/empty.png" alt="בינוני פעול" title="בינוני פעול" /></td>
            <td><img data-type="54" src="img/site/empty.png" alt="מַצְדַר (שם פעולה)" title="מַצְדַר (שם פעולה)" /></td>
            <td><img data-type="0" src="img/site/unchecked.png" alt="ראו גם" title="ראו גם" /></td>
        </tr>
    </table>
</div>

<div id="showing" class="table"></div>


<div class="table" style="display: table;">
    <div style="display: table-row; background-color: #eeeeee;">
        <div style="display: table-cell;">מילה 1</div>
        <div style="display: table-cell;">מילה 2</div>
        <div style="display: table-cell;">סוג קשר</div>
    </div><%
    dim countAll
    countAll = 0



    startTime = timer()
    'openDB "arabicWords"
    openDbLogger "arabicWords","O","TEST.relations.asp","single",""

	mySQL = "SELECT * FROM wordsRelations INNER JOIN words ON wordsRelations.word1=words.id"
	res.open mySQL, con
    Do until res.EOF 
        countAll = countAll + 1 %>
        <div class="relation" style="display: table-row;" data-type="<%=res("relationType")%>">
            <div style="display: table-cell;"><a href="word.asp?id=<%=res("word1")%>"><%=res("arabicWord")%></a> <span style="font-size: small;">(<%=res("word1")%>)</span></div>
            <div style="display: table-cell;"><%
                mySQL="SELECT arabicWord FROM words WHERE id="&res("word2")
                res2.open mySQL, con
                if not res2.EOF then %>
                    <a href="word.asp?id=<%=res("word2")%>"><%=res2("arabicWord")%></a> <span style="font-size: small;">(<%=res("word2")%>)</span><%
                end if
                res2.close %>
            </div>
            <div style="display: table-cell; min-width:100px;"><%
                SELECT CASE res("relationType")
                    case 0 %>
                        אחרים<%
                    case 1 %>
                        נרדפות עברית<%
                    case 2 %>
                        נרדפות ערבית<%
                    case 3 %>
                        יחיד - רבים<%
                    case 4 %>
                        זכר - נקבה<%
                    case 5 %>
                        הפכים<%
                    case 6 %>
                        דומה בערבית<%
                    case 7 %>
                        דומה בעברית<%
                    case 8 %>
                        תגובה<%
                    case 10 %>
                        צירופים<%
                    case 12 %>
                        משמעות נוספת בעברית<%
                    case 13 %>
                        משמעות נוספת בערבית<%
                    case 20 %>
                        נגזרות<%
                    case 50 %>
                        בינוני פועל<%
                    case 52 %>
                        בינוני פעול<%
                    case 54 %>
                        מַצְדַר (שם פעולה)<%
                    case 99 %>
                        כפילות<%
                END SELECT%>
            </div>
        </div><%
        res.moveNext
    Loop
    res.close 
    
    endTime = timer()
    durationMs = Int((endTime - startTime)*1000)
    'closeDB
    closeDbLogger "arabicWords","C","TEST.relations.asp","single",durationMs,""
       
    %>

    <p id="countAll" style="DISPLAY:NONE;"><%=FormatNumber(countAll,0)%></p>

</div>
<br />
<!--#include file="inc/trailer.asp"-->