function validateForm() {
    var x = document.forms["new"]["imgLink"].value;
    if (x.substring(0,5) == "http:") {
        alert("שגיאה בקישור לתמונה. כתובת לא מאובטחת");
        return false;
    }
}







// OLDER FUNCTIONS
// CHECK IF THEY ARE STILL IN USE

onload = function() {
//	new AutoSuggestCtrl(
//		document.getElementById("originWord"), //oTextbox
//		new SuggestionProvider("http://ronen.rothfarb.info/arabic/find.json.asp?q=") //oProvider
//	);
}

function lookUpResult(xml) {
//	var results=[];
//	alert(xml);
//	eval(xml);
//	if (results.length > 0) {
//	}
//	else {
//	}
}

function lookUp(word) {
	var a = new AJAX();
	a.Load("html://ronen.rothfarb.info/arabic/ajax/lookup.asp",
		"arabic=" + escape(word),
		lookUpResult);
}

function Highlight(message, ctrl){
        if (ctrl) ctrl.focus();
        document.getElementById("Message").innerHTML = message;
        return false;
}

function checkRadio(radi) {
	for (var i = 0; i < radi.length; ++i) {

		//alert(i + ": " + radi[i]);
		if (radi[i].checked == true) return true;
	}
	return false;
}

function nikudTyper(me, e) { // IE only...
    switch (e.keyCode) {
        case 65: e.keyCode = 1463; break; // A
        case 69: e.keyCode = 1462; break; // E
        case 73: e.keyCode = 1460; break; // I
        case 85: e.keyCode = 1467; break; // U
    }
}

// function makeSearchStr() {
// 	var f = document.forms['new'];
//     f.searchStringX.value = f.searchString1.value = noNikud(f.arabicWord.value) + "\n" + noNikud(f.hebrewTranslation.value);
// }

function noNikud(val) {
    // THIS WORKS ONLY FOR HEBREW CHARS. ARABIC CHARS NEEDED ASWELL
    for (var i = 1456; i < 1470; i++) {
        val = val.replace(new RegExp(String.fromCharCode(i), "g"), "");
    }
    return val;
}
var req = false;
function updateSelect(param) {
    req = false;
    if (window.XMLHttpRequest) { // Mozilla, Safari,...
        req = new XMLHttpRequest();
        if (req.overrideMimeType) {
            req.overrideMimeType('text/xml');
        }
    } else if (window.ActiveXObject) { // IE
        try {
            req = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e) { }
        }
    }
    if (!req) return false;
    req.onreadystatechange = alertContents;
    req.open('GET', 'http://localhost/arabic/find.xml.asp?' + param, false);
    req.send(null);
}
function alertContents() {
    if (req.readyState != 4) return;
    if (req.status != 200) {
        //alert('There was a problem with the request.');
        return;
    }
    //	var xmlDoc = req.documentElement;
    var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
    xmlDoc.loadXML(req.responseText);
    var matches = xmlDoc.selectNodes("word");
    if (matches.length > 0) {
        var list = document.forms[0].originWordID;
        while (list.options.length > 0) list.options[0] = null;
        for (var i = 0; i < matches.length; i++) {
            var wid = matches[i].selectSingleNode("@id").text;
            var word = matches[i].selectSingleNode("@ar").text;
            list.options[list.options.length] = new Option(word, wid);
        }
    }
}