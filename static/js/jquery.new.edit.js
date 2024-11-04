$(function() {
//calc searchString 
    $('#searchString2').focus(function() {
        left = $('#searchStringX').val().length;
        $('#searchString2').attr('maxlength', 250 - left)
    });


    //check that textareas don't exceed DB limit
    var text_max = 220;
    $('#textarea1').keyup(function() {
        var text_length = $('#textarea1').val().length;
        var text_remaining = text_max - text_length;

        $('#textarea1_feedback').html('נותרו עוד ' + text_remaining + ' תוים');
    });

    $('#textarea2').keyup(function() {
        var text_length = $('#textarea2').val().length;
        var text_remaining = text_max - text_length;

        $('#textarea2_feedback').html('נותרו עוד ' + text_remaining + ' תוים');
    });


    //show binyan if verb is choosen
    $('#partOfSpeach').change(function() {
        $('.pos').hide();
        $('#pos' + $(this).val()).show();
    });


    //animate movement to anchor
    var navigationFn = {
        goToSection: function(id) {
            $('html, body').animate({
                scrollTop: $(id).offset().top
            }, 1500);
        }
    }

    //hide stuff...
    $("#firstTimer").hide();
    $("#20min").hide();
    $(".boxes > div").hide();
        

    //show stuff (THIS COULD REALLY USE A SHORTER VERSION)
    $("#toggleFirst").click(function() {
        $("#firstTimer").toggle(function(){
            return false;
        });
    });

    $("#toggle20").click(function() {
        $("#20min").toggle(function(){
            return false;
        });
    });

    $("#toggleGuide").click(function() {
        $(".boxes > div").not("#guide").slideUp();
        $("#guide").slideToggle();
        navigationFn.goToSection('#anchor');
    });

    $("#toggleNotes").click(function() {
        $(".boxes > div").not("#notes").slideUp();
        $("#notes").slideToggle();
        navigationFn.goToSection('#anchor');
    });

    $("#toggleAttrs").click(function() {
        $(".boxes > div").not("#attributes").slideUp();
        $("#attributes").slideToggle();
        navigationFn.goToSection('#anchor');
    });

    $("#toggleTags").click(function() {
        $(".boxes > div").not("#subjects").slideUp();
        $("#subjects").slideToggle();
        navigationFn.goToSection('#anchor');
    });

    $("#toggleRelations").click(function() {
        $(".boxes > div").not("#wordsRelations").slideUp();
        $("#wordsRelations").slideToggle();
        navigationFn.goToSection('#anchor');
    });

    $("#toggleExactMore").click(function() {
        $(".boxes > div").not("#exactMore").slideUp();
        $("#exactMore").slideToggle();
        navigationFn.goToSection('#anchor');
    });

    $("#toggleImage").click(function() {
        $(".boxes > div").not("#image").slideUp();
        $("#image").slideToggle();
        navigationFn.goToSection('#anchor');
    });

    $("#toggleVideo").click(function() {
        $(".boxes > div").not("#video").slideUp();
        $("#video").slideToggle();
        navigationFn.goToSection('#anchor');
    });

    $("#toggleDialect").click(function() {
        $(".boxes > div").not("#dialect").slideUp();
        $("#dialect").slideToggle();
        navigationFn.goToSection('#anchor');
    });

    $("#toggleOrigin").click(function() {
        $(".boxes > div").not("#origin").slideUp();
        $("#origin").slideToggle();
        navigationFn.goToSection('#anchor');
    });

    $("#toggleNikud").click(function() {
        $(".boxes > div").not("#nikud").slideUp();
        $("#nikud").slideToggle();
        navigationFn.goToSection('#anchor');
    });


    // only in edit.asp
    $("#toggleExamples").click(function() {
        $(".boxes > div").not("#examples").slideUp();
        $("#examples").slideToggle();
        navigationFn.goToSection('#anchor');
    });

    $("#toggleSearch").click(function() {
        $(".boxes > div").not("#searchS").slideUp();
        $("#searchS").slideToggle();
        navigationFn.goToSection('#anchor');
    });



    //RELATIONS

    // Relations - starting positions

    $(".newRelSelect").hide();
    $(".newRelWord").hide();

    $(".newRelType").children().hide();
    $(".selectRel").hide();
    $(".relRemove").hide();

    // Relations - show radios of selected type

    $(".selectRel").change(selectRelType);

    function selectRelType(){
        var newRelType = $(this).siblings(".newRelType");
        var selectRel = $(this);
        newRelType.children().hide();

        var relNum = selectRel.find("option:selected").data("reltype");
        newRelType.find(".rel-"+relNum+"-div").show()

        if (relNum===5 || relNum===99 || relNum===0) {
            newRelType.find(".rel-"+relNum+"-div input").prop('checked',true).change();
            newRelType.find(".rel-"+relNum+"-div").hide();
            selectRel.parents(".newRelDiv").find("input[name=newRelType]").val(relNum);
            selectRel.prop("disabled",true);
            selectRel.parents(".newReldiv").find(".relRemove").show();
        }
    }

    // Relations - Create input block template
    var relTemplate = $(".newReldiv").clone();

    // Relations - Add new input block
console.log("relCount.val = ",$("#relCount").val());
    var radioAutoID = 2;
    function relNewBlock() {
        var cloneNum = ($(".newReldiv").length);
        $("#relCount").val(cloneNum);
        console.log ("cloneNum",cloneNum);
        if(cloneNum < 6){
            var cloned = relTemplate.clone();
            cloned.find(".selectRel").change(selectRelType);
            cloned.find(".newRelSelect").change(relSelect);
            cloned.find("input[type=radio]").change(relIsComplete).attr("name","radio"+radioAutoID);
            cloned.find(".relRemove").click(relRemove);
            cloned.find(".newRelInput").keyup(relKeyUp);
            cloned.appendTo($("#newRelations"));
            copyWords();
            radioAutoID++;
        }
        console.log("relCount.val = ",$("#relCount").val());
    }

    // Relations - Check if current block complete (before adding another)
    $(".newReldiv input[type=radio]").change(relIsComplete);

    function relIsComplete(){
        var isRelReady = $(this).parents(".newReldiv").data("ready");
        $(this).parents(".newReldiv").find(".relType").val($(this).val());
        $(this).parents(".newReldiv").find(".relRemove").show();
        if(isRelReady==="no"){
            $(this).parents(".newReldiv").data("ready","yes");
            $(this).parents(".newReldiv").find("input,select").prop("readonly",true);
            relNewBlock();
        }
    }


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
        var wordID = $("#wordID").val();

        if (search !== ""){
        //get json data from the server   
        $.getJSON("json.asp",  {"relData":wordID + "," + search} , function(json){

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


    // Relations - Remove block
    $(".relRemove").click(relRemove);

    function relRemove(){
        var rc = $("#relCount");
        var isComplete = $(this).parents(".newReldiv").data("ready");
        if (rc.val() > 0 && isComplete==="yes") {
            $(this).parents(".newReldiv").remove();
            rc.val($(".newReldiv").length);
        }
        if (rc.val() == 0) relNewBlock();
        console.log ("rc.val = ",rc.val());
    }

    //onclick option

    function relSelect(){
        var value = $(this).attr("data-id");
        var word = $(this).text();
        $(this).parent().slideUp(400);
        $(this).parents(".newReldiv").find(".newRelInput").hide();
        $(this).parents(".newReldiv").find(".newRelID").val(value);
        $(this).parents(".newReldiv").find(".newRelWord").attr("value",word).show();
        $(this).parent().siblings(".selectRel").show();
        
    }

    $(".words").find("input").change(copyWords);

    function copyWords(){
        // Copy arabicWord to relavent explanations
        $("#arabicWord").keyup(function () {
            var value = $(this).val();
            $(".typedWord").text(value);
        }).keyup();

        // Copy hebrew to relavent explanations
        $("#hebrew").keyup(function () {
            var value = $(this).val();
            $(".typedWord2").text(value);
        }).keyup();
    }
});