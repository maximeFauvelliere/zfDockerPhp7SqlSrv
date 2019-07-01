//attach 
var attachSiloEvents=function(){

$(click_tran.node).hover(
    function(){
        
        $("#tranTxt a").trigger("mouseover");
    },
    function(){
        $("#tranTxt a").trigger("mouseout");
    }

).click(
    function(){
        $("#tranTxt a").trigger("click");
    }
)
 
 $("#tranTxt a").hover(

    function(){
        facades.hide();
        ct_tran.attr({"opacity":"1"});
        $(this).parent().find("div").css("display","block");
        //$(this).css("color","red");
    },
    function(){
        ct_tran.attr({"opacity":"0"});
        facades.show();
         $(this).parent().find("div").css("display","none");
        $(this).css("color","#615046");
    }


).click(
    function(e){
        
        if(controller=="transaction"){return false};
     //acl
        /*if($("#z_Tran").hasClass("M_desactive")){
        alert("Vous n'avez pas acces à cette rubrique.");
        return false;
        }*/
        $("#canvas_siloNav").css("display","block");
        $("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").addClass("snav_transaction");
        
        location.hash="transaction_index";
        
        return false;

});





$(click_pro.node).hover(
    function(){
        $("#proTxt a").trigger("mouseover");
    },
    function(){
        $("#proTxt a").trigger("mouseout");
    }

).click(
    function(){
        $("#proTxt a").trigger("click");
    }
)

$("#proTxt a").hover(
    function(){
        $(this).parent().find("div").css("display","block");
        //$(this).css("color","#83B81A");
        facades.attr({"opacity":"0.01"});
        ct_pro.attr({"opacity":"1"});
        
        
    },
    function(){
        $(this).parent().find("div").css("display","none");
        //$(this).css("color","#615046");
        ct_pro.attr({"opacity":"0"});
        facades.attr({"opacity":"1"});
        
    }

).click(
    function(){

        if(controller=="prospection"){return false};
     //acl
        /*if($("#z_Tran").hasClass("M_desactive")){
        alert("Vous n'avez pas acces à cette rubrique.");
        return false;
        }*/
        $("#canvas_siloNav").css("display","block");$("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").addClass("snav_prospection");
        
        location.hash="prospection_index";
        
        return false;

});

$(click_adm.node).hover(
    function(){
        $("#admTxt a").trigger("mouseover");
    },
    function(){
        $("#admTxt a").trigger("mouseout");
    }

).click(
    function(){
        $("#admTxt a").trigger("click");
    }
)

$("#admTxt a").hover(
    function(){
        $(this).parent().find("div").css("display","block");
        //$(this).css("color","#83B81A");
        facades.attr({"opacity":"0.01"});
        ct_adm.attr({"opacity":"1"});
    },
    function(){
        $(this).parent().find("div").css("display","none");
        //$(this).css("color","#615046");
        ct_adm.attr({"opacity":"0.01"});
        facades.attr({"opacity":"1"})

    }
).click(
    function(){

        if(controller=="administration"){return false};
     //acl
        /*if($("#z_Tran").hasClass("M_desactive")){
        alert("Vous n'avez pas acces à cette rubrique.");
        return false;
        }*/
        $("#canvas_siloNav").css("display","block");
        $("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").addClass("snav_administration");
        
        location.hash="administration_index";
        
        return false;

});

$(click_exe.node).hover(
    function(){
       
        $("#exeTxt a").trigger("mouseover");
    },
    function(){
        
        $("#exeTxt a").trigger("mouseout");
    }

).click(
    function(){
        $("#exeTxt a").trigger("click");
    }
)

$("#exeTxt a").hover(
    //in
    function(e){
         $(this).parent().find("div").css("display","block");
        //$(this).css("color","#83B81A");
       facades.attr({"opacity":"0.01"});
        ct_exe.attr({"opacity":"1"});
  
    },
    //out
    function(e){
        $(this).parent().find("div").css("display","none");
        //$(this).css("color","#615046");
        ct_exe.attr({"opacity":"0.01"});
        facades.attr({"opacity":"1"})
    }
).click(
    function(){

        if(controller=="execution"){return false};
     //acl
        /*if($("#z_Tran").hasClass("M_desactive")){
        alert("Vous n'avez pas acces à cette rubrique.");
        return false;
        }*/
        $("#canvas_siloNav").css("display","block");
        $("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").addClass("snav_execution");
        
        location.hash="execution_index";
        
        return false;

});

//maison
$(click_maison.node).hover(
    function(){
       
        $("#ctTxt a").trigger("mouseover");
    },
    function(){
        
        $("#ctTxt a").trigger("mouseout");
    }

).click(
    function(){
        $("#ctTxt a").trigger("click");
    }
)


$("#ctTxt a").hover(
    function(){
       $(this).parent().find("div").css("display","block");
       //$(this).css("color","#83B81A");
       fenetre.attr({fill:"#E1D24D"});
       porte.attr({fill:"#E1D24D"});
       ct_ma.attr({"opacity":"1"})
    },
    function(){
    
       $(this).parent().find("div").css("display","none");
       //$(this).css("color","#615046");
       fenetre.attr({fill:"#615046"});
       porte.attr({fill:"#615046"});
       ct_ma.attr({"opacity":"0"})
    }

).click(
    function(evt){

        if(controller=="administration"){return false};
        
        //si pas de contrat a signer
        if(!$(evt.target).attr("nbct")) {alert("Vous n'avez pas de contrats à signer.");return false};
        
     //acl
        /*if($("#z_Tran").hasClass("M_desactive")){
        alert("Vous n'avez pas acces à cette rubrique.");
        return false;
        }*/
        $("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").addClass("snav_transaction");
        $("#canvas_siloNav").css("display","block");
        
        location.hash="administration_contratsasigner";
        
        return false;

});

//offres
$(click_offres.node).hover(
    function(){
       
        $("#offresTxt a").trigger("mouseover");
    },
    function(){
        
        $("#offresTxt a").trigger("mouseout");
    }

).click(
    function(){
        $("#offresTxt a").trigger("click");
    }
)

$("#offresTxt a").hover(
     function(){
        $(this).parent().find("div").css("display","block");
        //$(this).css("color","#83B81A");
        offres_over.attr({"opacity":"1"});
    }, 
    function(){
        offres_over.attr({"opacity":"0"});
        $(this).parent().find("div").css("display","none");
       // $(this).css("color","#615046");
    }
).click(
    function(){

        if(controller=="transaction"){return false};
     //acl
        /*if($("#z_Tran").hasClass("M_desactive")){
        alert("Vous n'avez pas acces à cette rubrique.");
        return false;
        }*/
        $("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").addClass("snav_transaction");
        $("#canvas_siloNav").css("display","block");
        
        
        location.hash="transaction_offres";
        return false;

});



//analyses
$(click_analyses.node).hover(
    function(){
       
        $("#analysesTxt a").trigger("mouseover");
    },
    function(){
        
        $("#analysesTxt a").trigger("mouseout");
    }

).click(
    function(){
        $("#analysesTxt a").trigger("click");
    }
)
$("#analysesTxt a").hover(
    function(){
        analyses_over.attr({"opacity":"1"});
        $(this).parent().find("div").css("display","block");
        //$(this).css("color","#83B81A");
    },
    function(){
        analyses_over.attr({"opacity":"0"});
        $(this).parent().find("div").css("display","none");
        //$(this).css("color","#615046");
    }
).click(
    function(evt){

        if(controller=="transaction"){return false};
        //si pas d'analyses
        if(!$(evt.target).attr("nbana")) {alert("Vous n'avez pas d'analyses a affecter.");return false};
        
     //acl
        /*if($("#z_Tran").hasClass("M_desactive")){
        alert("Vous n'avez pas acces à cette rubrique.");
        return false;
        }*/
        $("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").addClass("snav_prospection");
        $("#canvas_siloNav").css("display","block");
        
        location.hash="analysesattentes_analyses";
        return false;
        

});

//infos marches
$(click_infos.node).hover(
    function(){
       
        $("#infosTxt a").trigger("mouseover");
    },
    function(){
        
        $("#infosTxt a").trigger("mouseout");
    }

).click(
    function(){
        $("#infosTxt a").trigger("click");
    }
)
$("#infosTxt a").hover(
    function(){
        infos_over.attr({"opacity":"1"});
        $(this).parent().find("div").css("display","block");
       // $(this).css("color","#83B81A");
    },
    function(){
        infos_over.attr({"opacity":"0"});
        $(this).parent().find("div").css("display","none");
        //$(this).css("color","#615046");
    }
).click(
    function(){

        if(controller=="transaction"){return false};
     //acl
        /*if($("#z_Tran").hasClass("M_desactive")){
        alert("Vous n'avez pas acces à cette rubrique.");
        return false;
        }*/
        $("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").addClass("snav_transaction");
        $("#canvas_siloNav").css("display","block");
        
        location.hash="transaction_infosmarches";
        return false;

});

/*facades.hover(
    function(){
        alert("toto")
    }
)*/
    // gestion pointer =>cursor
    $(click_infos.node).attr("class","cursor");
    $(click_analyses.node).attr("class","cursor");
    $(click_offres.node).attr("class","cursor");
    $(click_tran.node).attr("class","cursor");
    $(click_pro.node).attr("class","cursor");
    $(click_adm.node).attr("class","cursor");
    $(click_exe.node).attr("class","cursor");
    $(click_maison.node).attr("class","cursor");
}