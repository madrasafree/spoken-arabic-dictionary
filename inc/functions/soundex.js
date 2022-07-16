// REPLACED BY VBSCRIPT FUNCTION


// https://en.wikipedia.org/wiki/Unicode_and_HTML_for_the_Hebrew_alphabet
// https://en.wikipedia.org/wiki/Arabic_(Unicode_block)
// http://www.babelstone.co.uk/Unicode/whatisit.html

function soundex(input) {
  var output = "";
  var ltrs = input;
  var dbl = false;

  // Removes chars which aren't Hebrew or Arabic letters, or Geresh
  ltrs = ltrs.replace(/[^א-ת'ؠ-يٱ-ٳٶ-ە]/g,"");

  for ( i = 0; i < ltrs.length; i++)
  {
    if (dbl == true) dbl=false;            
    else if (ltrs[i] == 'א' || ltrs[i] == 'ו' || ltrs[i] == 'י') { 
      if (i>0)
        output += ""; // hebrew a'he'vi
      else
        if (ltrs[i] == 'א') output += "A";
        else if (ltrs[i] == 'ו') output += "W";
        else output += "Y";
    }
    else if ((ltrs[i] == "צ" || ltrs[i] == "ץ" || ltrs[i] == "ד") && ltrs[i+1] == "'") {output += "D"; dbl=true;}
    else if (ltrs[i] == "ט" && ltrs[i+1] == "'") {output += "S"; dbl=true;}
    else if (ltrs[i] == "ת" && ltrs[i+1] == "'") {output += "T"; dbl=true;}
    else if ((ltrs[i] == "ה" || ltrs[i] =="ח") && ltrs[i+1] == "'") {output += "H"; dbl=true;}
    else if ((ltrs[i] == "ג" || ltrs[i] =="ז") && ltrs[i+1] == "'") {output += "J"; dbl=true;}
    else if (ltrs[i] == "ר" && ltrs[i+1] == "'") {output += "R"; dbl=true;}
    else if (ltrs[i] == 'ا' || ltrs[i] == 'آ' || ltrs[i] == 'أ' || ltrs[i] == 'إ' || ltrs[i] == 'ئ' || ltrs[i] == 'ة' || ltrs[i] == 'ء' || ltrs[i] == 'ؤ' || ltrs[i] == 'ي' || ltrs[i] == 'ى' || ltrs[i] == 'و') output += ""; // arabic ltrs
    else if (ltrs[i] == "د" || ltrs[i] == "ד" || ltrs[i] == "ذ" || ltrs[i] == "ד'" || ltrs[i] == "ض" || ltrs[i] == "צ'" || ltrs[i] == "ץ'") output += "D";
    else if (ltrs[i] == "ص" || ltrs[i] == "צ" || ltrs[i] == "ץ" || ltrs[i] == "س" || ltrs[i] == "ס" || ltrs[i] == "ز" || ltrs[i] == "ז" || ltrs[i] == "ظ" || ltrs[i] == "ט'") output += "S";
    else if (ltrs[i] == "ط" || ltrs[i] == "ט" || ltrs[i] == "ت" || ltrs[i] == "ת" || ltrs[i] == "ث" || ltrs[i] == "ת'") output += "T";
    else if (ltrs[i] == "ب" || ltrs[i] == "ב") output += "B";
    else if (ltrs[i] == "ن" || ltrs[i] == "נ" || ltrs[i] == "ן") output += "N";
    else if (ltrs[i] == "ع" || ltrs[i] == "ע") output += "A";
    else if (ltrs[i] == 'ة' || ltrs[i] == 'ه' || ltrs[i] == "ה" || ltrs[i] == "ה'" || ltrs[i] == "ح"  || ltrs[i] == "ח" || ltrs[i] == "خ" || ltrs[i] == "ח'") output += "H";
    else if (ltrs[i] == "ك" || ltrs[i] == "כ" || ltrs[i] == "ך" || ltrs[i] == "ق" || ltrs[i] == "ק" || ltrs[i] == "ג") output += "K";
    else if (ltrs[i] == "ش" || ltrs[i] == "ש" || ltrs[i] == "ج" || ltrs[i] == "ג'" || ltrs[i] == "ז'") output += "J";
    else if (ltrs[i] == "غ" || ltrs[i] == "ע'" || ltrs[i] == "ر" || ltrs[i] == "ר" || ltrs[i] == "ר'") output += "R";
    else if (ltrs[i] == "ل" || ltrs[i] == "ל") output += "L";
    else if (ltrs[i] == "م" || ltrs[i] == "מ" || ltrs[i] == "ם") output += "M";
    else if (ltrs[i] == "ف" || ltrs[i] == "פ" || ltrs[i] == "ף") output += "F";
    else output += ltrs[i];
  }           
  return output;
}