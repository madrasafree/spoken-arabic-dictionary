<!--#include file="inc/inc.asp"-->
<!--#include file="team/inc/functions/string.asp"-->
<!--#include file="inc/functions/functions.asp"-->
<!--#include file="inc/time.asp"-->
<!DOCTYPE html>
<html style="height:100%;">
<head>
    <!--#include file="inc/header.asp"-->
    <title>מילון ערבית מדוברת - לדוברי עברית</title>
    <meta name="Description" content="המילון לערבית מדוברת (לדוברי עברית) הוא שירות חינמי שנועד לעזור לקהילת לומדי הערבית המדוברת" />
    <meta name="Keywords" content="מילון עברי ערבי, תרגום עברית ערבית, מילון ערבי עברי, תרגום מעברית לערבית, תרגום ערבית עברית, מתרגם עברית ערבית" /> <!-- since 2021-06 -->
    <meta property="og:title" content="מילון ערבית מדוברת - לדוברי עברית" />
    <meta property="og:description" content="המילון לערבית מדוברת (לדוברי עברית) הוא שירות חינמי שנועד לעזור לקהילת לומדי הערבית המדוברת" />
    <meta property="og:url" content="https://rothfarb.info/ronen/arabic/" />
    <meta property="og:type" content="website" />
    <style>
        :root {
            --blue-xLight:#c8e2fd;
            --blue-light:#adcceb;
            --blue-dark:#5c7b9a;
            --red-xLight:#fff3f3;
            --red-dark:#c54d4d;
            }
        #container {
            margin:0;
        }
        .flex-container {
            display: -ms-flexbox;
            display: -webkit-flex;
            display: flex;
            -webkit-flex-direction: row;
            -ms-flex-direction: row;
            flex-direction: row;
            -webkit-flex-wrap: wrap;
            -ms-flex-wrap: wrap;
            flex-wrap: wrap;
            -webkit-justify-content: space-between;
            -ms-flex-pack: justify;
            justify-content: space-between;
            -webkit-align-content: flex-start;
            -ms-flex-line-pack: start;
            align-content: flex-start;
            -webkit-align-items: flex-start;
            -ms-flex-align: start;
            align-items: flex-start;
            }

        .flex-item {
            -webkit-order: 0;
            -ms-flex-order: 0;
            order: 0;
            -webkit-flex: 1 1 320PX;
            -ms-flex: 1 1 320PX;
            flex: 1 1 320PX;
            -webkit-align-self: auto;
            -ms-flex-item-align: auto;
            align-self: auto;
            }

        .flex-item:nth-child(2) {
            flex-grow:3;
            }

        .homepage-item h2 {
            background-color:var(--blue-light);
            color:var(--blue-dark);
            border-radius: 10px 10px 0 0;
            text-align:center;
            margin:0;
            }


        .homepage-item {
            background:white;
            border-radius: 10px 10px 0 0;
            box-shadow:var(--blue-dark) 0px 4px 8px;
            margin:20px 10px;
            min-height:100px;
            padding:0;
            position:relative;
            }

        .homepage-item-icon {
            background-color:var(--blue-dark);
            border-radius:50%;
            color:white;
            text-align:center;
            line-height:42px;
            height:42px;
            width:42px;
            position:absolute;
            top:-8px;
            right:13px;
            }

        .homepage-item p {
            padding:2px 10px;
            padding-bottom:20px;
            text-align:center;
            }

        .msg p {
            font-size:large;
            line-height:1.5em;
        }

        .homepage-item .more-info {
            text-align:left;
            padding-bottom: 10px;
            }

        .homepage-item .more-info a {
            background-color: var(--blue-dark);
            color: var(--blue-xLight);
            padding:2px 5px;
            }
        
        .alert {
            background-color: var(--red-xLight);
        }
        .alert span {
            background-color: var(--red-dark);
        }
        .alert p {
            color: var(--red-dark);
        }

</style>
</head>
<body>
<!--#include file="inc/top.asp"-->
<div class="flex-container">
    <div class="flex-item">
        <div class="homepage-item msg alert">
            <span class="material-icons homepage-item-icon">campaign</span>
            <h2>הודעת מערכת</h2>
            <p>
                ברוכים הבאים לדף הבית החדש שלנו.
                <br>אנחנו רוצים להנגיש לכם את מה שיש לנו להציע, מעבר למילון. מוזמנים להציץ.
            </p>
        </div><%
        if session("userID")>1 then %>
        <div class="homepage-item">
            <span class="material-icons homepage-item-icon">help</span>
            <h2>תפריט אישי</h2>
            <ul>
                <li>הוספת מילה</li>
                <li>יצירת רשימה</li>
                <li>התנתק</li>
            </ul>
        </div><%
        else %>
        <div class="homepage-item">
            <h2>פרסומת</h2>
            <!--#include file="inc/ads/2021-07_002-milon.asp"-->
        </div><%
        end if %>

        <div class="homepage-item msg">
            <span class="material-icons homepage-item-icon">campaign</span>
            <!-- RANDOMISED MESSAGE -->
            <h2>הודעה מתחלפת</h2>
            <div id="msgBoard"></div>
        </div>
        <div class="homepage-item">
            <span class="material-icons homepage-item-icon">trending_up</span>
            <h2>סטטיסטיקה</h2>
            <p>1.2.3</p>
        </div>
        <div class="homepage-item">
            <span class="material-icons homepage-item-icon">history</span>
            <h2>פעילות קהילה באתר</h2>
            <p>אולי לקרוא לזה 'עדכוני תוכן'?</p>
        </div>
    </div>
    <div class="flex-item">
        <div class="homepage-item">
            <span class="material-icons homepage-item-icon">star</span>
            <h2>מילה אקראית / ספוטלייט</h2>

            <div class="result" onclick="location.href='word.asp?id=268';">
                        <div class="heb" style="position: relative;">
                            <a href="word.asp?id=268">שָׁקַל</a>
                            
                                <span class="def">(פועל, הוא)</span>
                            <span class="icons">
                                <img src="img/site/correct.png" id="ערך זה נבדק ונמצא תקין" alt="ערך זה נבדק ונמצא תקין" title="ערך זה נבדק ונמצא תקין" class="correct">
                            </span>                    
                        </div>
                        <div class="arb harm">زان</div>
                        <div class="arb keter">זַאן</div>
                        <div class="eng">
                            zaan
                        </div>
                        <div class="attr">
                            <div class="pos">פועל<span style="font-size:small;"> (בניין 1)</span>
                            </div>     
                            <div class="gender">זכר
                            </div>     
                            <div class="number">יחיד
                            </div>     
                        </div>
                    </div>


            <div class="more-info">
                <a href="">לדף המילה</a>
            </div>
        </div>
        <div class="homepage-item">
            <span class="material-icons homepage-item-icon">star</span>
            <h2>רשימה בספוטלייט</h2>
            <div class="more-info">
                <a href="">לרשימה</a>
            </div>
        </div>
        <div class="homepage-item">
            <span class="material-icons homepage-item-icon">style</span>
            <!-- TAG CLOUD-->
            <style>
                #tagsCloud a {
                    padding:0 3px;
                }
                #tagsCloud li:hover {
                    background: yellow;
                    box-shadow: #00000050 2px 2px 2px;
                }
            </style>
            <h2>רשימות נושאים</h2>
            <p>
                <div id="tagsCloud">
                    <ul><%
                    dim x,tagSize

                    startTime = timer()
                    'openDB "arabicWords"
                    openDbLogger "arabicWords","O","default.asp","tagCloud",strClean

                    mySQL = "SELECT * FROM labels ORDER BY labelName"
                    res.open mySQL, con
                        Do until res.EOF
                            mySQL = "SELECT count(wordID) FROM wordsLabels WHERE labelID="&res("ID")
                            res2.open mySQL, con
                                x = res2(0)
                                SELECT Case true
                                    case x>=0 AND x<=10
                                    tagSize = "1em"
                                    case x>=11 AND x<=30
                                    tagSize = "1.2em"
                                    case x>=31 AND x<=70
                                    tagSize = "1.4em"
                                    case x>=71 AND x<=120
                                    tagSize = "1.6em"
                                    case x>=121 AND x<=180
                                    tagSize = "1.8em"
                                    case x>=180 AND x<=300
                                    tagSize = "2em"
                                    case else
                                    tagSize = "2.2em"
                                END SELECT
                            res2.close %>
                            <li style="font-size:<%=tagSize%>;" title="ישנן <%=x%> מילים בנושא זה" style="font-size:<%=tagSize%>">
                                <a href="label.asp?id=<%=res("id")%>"><%=res("labelName")%></a>
                            </li><%
                            res.moveNext
                        Loop
                    res.close

                    endTime = timer()
                    durationMs = Int((endTime - startTime)*1000)
                    'closeDB
                    closeDbLogger "arabicWords","C","default.asp","tagCloud",durationMs,strClean

                    %>
                    </ul>
                </div>
            </p>
        </div> 
    </div>
    <div class="flex-item">
        <div class="homepage-item">
            <span class="material-icons homepage-item-icon">schedule</span>
            <h2>תאריך ושעה</h2>
        </div>
        <div class="homepage-item msg">
            <span class="material-icons homepage-item-icon">attach_money</span>
            <h2>תמיכה כלכלית</h2>
            <p>נהנים מהמילון?
                <br> רוצים לאפשר לנו לתחזק אותו ולשפר אותו?</p>
            <div class="more-info">
                <a href="contribute.asp">למידע נוסף</a>
            </div>
        </div>
        <div class="homepage-item">
            <span class="material-icons homepage-item-icon">history</span>
            <h2>חיפושים אחרונים</h2>
        </div>
        <div class="homepage-item">
            <span class="material-icons homepage-item-icon">quiz</span>
            <h2>מדריכי שימוש</h2>
        </div>
        <div class="homepage-item">
            <span class="material-icons homepage-item-icon">play_arrow</span>
            <h2>סרטונים</h2>
        </div>
    </div>
</div>
<!--#include file="inc/trailer.2022.asp"-->