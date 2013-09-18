$(document).ready(function(){
    
    var isListHidden = true;
    
    $("#modellist-hideShowBtn").click(function() {
        
        if (false == isListHidden) {
        
            // hide endpoint selection
            $("#sparqlservices").fadeOut("fast", function(){
                
                // hide headline
                $($("#modellist").find("h1").first()).fadeOut("fast", function(){
                    
                    // hide list
                    $("#modellist").fadeOut("fast", function() {                        
                        $("#cubeviz-dataSelectionModule-dataSelection")
                            .show();
                    });
                    
                    $("#modellist-hideShowBtn")
                        .html("Open Settings");
                        
                    isListHidden = true;
                    
                });
            });
            
        } else {
            
            $("#cubeviz-dataSelectionModule-dataSelection")
                .hide();
                        
            // show endpoint selection
            $("#sparqlservices").fadeIn("fast", function(){
            
                // show headline
                $($("#modellist").find("h1").first()).fadeIn("fast", function(){
                    
                    // hide list
                    $("#modellist").fadeIn("fast");
                    
                    $("#modellist-hideShowBtn")
                        .html("Hide Settings");
                        
                    isListHidden = false;
                });
            });
        }
    });
});
