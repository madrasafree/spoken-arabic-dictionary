$(function() {


    //keyboard event
    $(".newRelInput").keydown(charCheck);
    function charCheck(e){
        if (e.key == ",") {
            console.log("comma!");
            e.preventDefault();
        };
    }

    $(".newRelInput").keyup(relKeyUp);

    function relKeyUp(){
        var search = $(this).val();
        search = search.replace(/\s+/g, '');
        var select = $(this).parent().find(".newRelSelect");

        if (search !== ""){
        //get json data from the server   
        $.getJSON("json.asp",  {"relData":"1,"+search} , function(json){

            //remove duplicates
            var previousIds = [];
            var filteredJSON = json.filter(function(object){
                 var isInPrev = previousIds.includes(object.id);
                 previousIds.push(object.id);
                 return !isInPrev;
            });

            //empty the datalist
            select.empty();
            //populate the datalist by the json data
            $.each(filteredJSON, function(i, item) {
                select.append($("<li>").attr('data-id',item.id).html(`${item.hebrew} - ${item.arabic} - ${item.taatik}`));
            });
            select.attr("size", json.length+1);
            if (json.length > 0) {
                select.show();
                $(".newRelSelect li").click(relSelect);
            } else {
                select.empty().hide();
            }
        });
        } else {
            select.empty().hide();
        }
    }


    //onclick option

    function relSelect(){
        var value = $(this).attr("data-id");
        var word = $(this).text();

        $(this).parents(".newRelDiv").find("#wordID").val(value);
        
        $("#newRelForm").submit();
        
    }

});