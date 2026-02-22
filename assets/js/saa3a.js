function showTime(){

    var daqiqa = 'דַקִיקַה';
    var saa3a = '';
    var HH = (new Date()).getHours();
    var MM = (new Date()).getMinutes();
    var clock = ""

    if (String(HH).length==1) {
        clock = "0" + String(HH); 
    } else {
        clock = HH;
    }
    document.getElementById('HH').innerHTML=clock;

    if (String(MM).length==1) {
        clock = "0" + String(MM); 
    } else {
        clock = MM;
    }
    document.getElementById('MM').innerHTML=clock;

    if (MM==40 || MM==45 || MM==50 || MM==55) HH=HH+1 ;

    switch (HH) {
        case 1:
        case 13: saa3a = 'וַחַדֵה';   break;
        case 2:
        case 14: saa3a = "תִנְתֵין"; break;
        case 3:
        case 15: saa3a = "תַלַאתֵה"; break;
        case 4:
        case 16: saa3a = 'אַרְבַּעַה'; break;
        case 5:
        case 17: saa3a = "חַ'מְסַה"; break;
        case 6:
        case 18: saa3a = 'סִתֵّה'; break;
        case 7:
        case 19: saa3a = 'סַבְּעַה'; break;
        case 8:
        case 20: saa3a = 'תַמַאנְיֵה'; break;
        case 9:
        case 21: saa3a = 'תִסְעַה'; break;
        case 10:
        case 22: saa3a = 'עַשַרַה'; break;
        case 11:
        case 23: saa3a = 'אְחְדַעַש'; break;
        case 12:
        case 00: saa3a = 'תְנַעַש'; break;
    }

    switch (MM) {
        case 0:     saa3a += " בִּ(אל)זַّבֵּט"; break;
        case 1:     saa3a += " וּדַקִיקַה"; break;
        case 2:     saa3a += " וּדַקִיקְתֵין"; break;
        case 3:     saa3a += " וּתַלַת"; break;
        case 4:     saa3a += " וּאַרְבַּע"; break;
        case 5:     saa3a += " וּחַ'מְסֵה"; break;
        case 6:     saa3a += " וּסִתّ"; break;
        case 7:     saa3a += " וּסַבְּע"; break;
        case 8:     saa3a += " וּתַמַן"; break;
        case 9:     saa3a += " וּתִסְע"; break;
        case 10:    saa3a += " וּעַשַרַה"; break;
        case 11:    saa3a += " וּחְדַעְשַר";     break;
        case 12:    saa3a += " וּתְנַעְשַר";     break;
        case 13:    saa3a += " וּתְלַאתַעְשַר";     break;
        case 14:    saa3a += " וּאַרְבַּעְתַעַשַר";     break;
        case 15:    saa3a += " וּרֻבְּע";     break;
        case 16:    saa3a += " וּסִתַעְשַר";     break;
        case 17:    saa3a += " וּסַבַּעְתַעְשַר";     break;
        case 18:    saa3a += " וּתַמַנְתַעְשַר";     break;
        case 19:    saa3a += " וּתִסְעַתַעְשַר";     break;
        case 20:    saa3a += " וּתֻלְת";     break;
        case 21:    saa3a += " וּוַאחַד וּעִשְרִין";     break;
        case 22:    saa3a += " ותְנֵין וּעִשְרִין";     break;
        case 23:    saa3a += " וּתַלַאתֵה וּעִשְרִין";     break;
        case 24:    saa3a += " וּאַרְבַּעַה וּעִשְרִין";     break;
        case 25:    saa3a += " וּנֻץّ אִלַא חַ'מְסֵה";     break;
        case 26:    saa3a += " וּסִתֵّה וּעִשְרִין";     break;
        case 27:    saa3a += " וּסַבְּעַה וּעִשְרִין";     break;
        case 28:    saa3a += " וּתַמַאנְיֵה וּעִשְרִין";     break;
        case 29:    saa3a += " וּתִסְעַה וּעִשְרִין";     break;
        case 30:    saa3a += " וּנֻץّ";     break;
        case 31:    saa3a += " וּוַאחַד וּתַלַאתִין";     break;
        case 32:    saa3a += " ותְנֵין וּתַלַאתִין";     break;
        case 33:    saa3a += " וּתַלַאתֵה וּתַלַאתִין";     break;
        case 34:    saa3a += " וּאַרְבַּעַה וּתַלַאתִין";     break;
        case 35:    saa3a += " וּנֻץّ וּחַ'מְסֵה";     break;
        case 36:    saa3a += " וּסִתֵّה וּתַלַאתִין";     break;
        case 37:    saa3a += " וּסַבְּעַה וּתַלַאתִין";     break;
        case 38:    saa3a += " וּתַמַאנְיֵה וּתַלַאתִין";     break;
        case 39:    saa3a += " וּתִסְעַה וּתַלַאתִין";     break;
        case 40:    saa3a += " אִלַא תֻלְת";     break;
        case 41:    saa3a += " וּוַאחַד וּאַרְבַּעִין";     break;
        case 42:    saa3a += " ותְנֵין וּאַרְבַּעִין";     break;
        case 43:    saa3a += " וּתַלַאתֵה וּאַרְבַּעִין";     break;
        case 44:    saa3a += " וּאַרְבַּעַה וּאַרְבַּעִין";     break;
        case 45:    saa3a += " אִלַא רבע";     break;
        case 46:    saa3a += " וּסִתֵّה וּאַרְבַּעִין";     break;
        case 47:    saa3a += " וּסַבְּעַה וּאַרְבַּעִין";     break;
        case 48:    saa3a += " וּתַמַאנְיֵה וּאַרְבַּעִין";     break;
        case 49:    saa3a += " וּתִסְעַה וּאַרְבַּעִין";     break;
        case 50:    saa3a += " אִלַא עַשַרַה";     break;
        case 51:    saa3a += " וּוַאחַד וּחַ'מְסִין";     break;
        case 52:    saa3a += " ותְנֵין וּחַ'מְסִין";     break;
        case 53:    saa3a += " וּתַלַאתֵה וּחַ'מְסִין";     break;
        case 54:    saa3a += " וּאַרְבַּעַה וּחַ'מְסִין";     break;
        case 55:    saa3a += " אִלַא חַ'מְסֵה";     break;
        case 56:    saa3a += " וּסִתֵّה וּחַ'מְסִין";     break;
        case 57:    saa3a += " וּסַבְּעַה וּחַ'מְסִין";     break;
        case 58:    saa3a += " וּתַמַאנְיֵה וּחַ'מְסִין";     break;
        case 59:    saa3a += " וּתִסְעַה וּחַ'מְסִין";     break;
    
    }

    if (MM > 2 && MM < 11) daqiqa = "דַקַאיֵק" 
    if (MM % 5 == 0) daqiqa = ""
    if (MM == 1 || MM == 2) daqiqa = ""  

    document.getElementById('taatiklock').innerHTML=" אִ(ל)סֵّאעַה " +  saa3a + " " + daqiqa;

}


showTime();

setInterval(() => {
    showTime();
}, 60000);
