pageRequest=null;
filter=null;

// set culture 
Globalize.culture("fr-FR");
function getRubriqueAccueil(rubrique,action,filter){
    
    //pour chaque requete show preloader
    $("#preloader").css("display","block");
    
    
    /**
     *
     *@todo centraliser ici l'affichage du titre navigation
     *
     */
    
    // delete alert confirm
    $(".confirm").remove();
    
    //vide main
    $("#main").empty();
                        
                       
//base,controller,action,context,filtre
     pageRequest=new UrlPageRequest(baseUrl,rubrique,action,"html",filter);
    //declenche hashchange
    
    //vider hash
    if(location.hash!=""){
        location.hash=rubrique+"_"+action;
    }else{
        
        $(window).trigger('hashchange');
        
    }
    
    
    
    
    
}

/**
     *Désactive le comportement par default du subMenu
     *affecte ajax requete pour les sous menus
     * ajoute les effets au menu 
     */
function menuBz(){
    /**
     *@ todo a confirmer cette function
     *
     **/
    
    alert("menuBz a confirmer voir cette function ")
    
    return;
    //menuTop
     /**
      *@todo a revoir lorsque menu
      *
      **/    
    $(".confirm").remove(); 
    //menu left
    $(".subMenu a").click(

        function(evt){
                
            evt.preventDefault();
                    
            //location.hash=$(this).attr("class");

            var lien =$(this).attr("href");
                    
            ($(this).attr("href"));
                    
            $.get(lien,function(data){
                        
                $(".content").html(data);

                makeDataGrid();

            });
   
        }
        
        )
                
   // gestion display  menu left               
    $(".main_menu").click(
                
        function(evt){
           alert("main menu"+evt.target)
            //delete dialog alerte
            $(".confirm").remove();       
            //rubriques
            $(".main_menu").removeClass("active");
            $(this).addClass("active");   
            //sous rubrique    
            $(".main_menu").find("ul li ul").removeClass("active");
            $(this).find("ul li ul").addClass("active");    
        })
              
  
}// fin menuBZ


                
$(document).ready(function() {
    
   
     
    $("#z_Tran").click(function(evt){
        evt.preventDefault();
        
        if(controller=="transaction" && action=="index") return false;
        //acl
         if($(this).hasClass("M_desactive")){
           alert("Vous n'avez pas acces à cette rubrique.");
           return false;
        }
        $("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").addClass("snav_transaction"); 
        $("#titreNav").html('Transaction');
        //chargement transaction
        
        
        getRubriqueAccueil("transaction","index");
        
        _gaq.push (['_trackEvent',"transaction","acceuil",'click silo mini']);
        
    });
    $("#z_exec").click(function(evt){
        evt.preventDefault();
        if(controller=="execution" && action=="index") return false;
        //acl
         if($(this).hasClass("M_desactive")){
           alert("Vous n'avez pas acces à cette rubrique.");
           return false;
        }
        $("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").addClass("snav_execution"); 
        $("#titreNav").html('Exécution');
        //chargement execution
        
        getRubriqueAccueil("execution","index");
        
        _gaq.push (['_trackEvent',"execution","acceuil",'click silo mini']);
    });
    $("#z_admin").click(function(evt){
        evt.preventDefault();
        if(controller=="administration" && action=="index") return false;
        //acl
         if($(this).hasClass("M_desactive")){
           alert("Vous n'avez pas acces à cette rubrique.");
           return false;
        }
        $("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").addClass("snav_administration"); 
        $("#titreNav").html('Administration');
        //chargement admin
       
        getRubriqueAccueil("administration","index");
        _gaq.push (['_trackEvent',"administration","acceuil",'click silo mini']);
    });
    $("#z_prospec").click(function(evt){
        evt.preventDefault();
        if(controller=="prospection" && action=="index") return false;
        //acl
         if($(this).hasClass("M_desactive")){
           alert("Vous n'avez pas acces à cette rubrique.");
           return false;
        }
        $("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").addClass("snav_prospection");
        $("#titreNav").html('Prospection');
        
        
        var filter =new Filter();
        getRubriqueAccueil("prospection","index",filter.getChecked());
        _gaq.push (['_trackEvent',"prospection","acceuil",'click silo mini']);
    });
    $("#acc").click(function(evt){
       
       _gaq.push (['_trackEvent',"accueil","acceuil",'click menu haut']);
        location.hash="accueil_index";
    })
    
    $("#compte").click(function(evt){
       // if(controller=="compte"){return false};
      
        //getRubriqueAccueil("compte","index");
        
        location.hash="compte_index";
         $("#canvas_siloNav").css("display","block");
        _gaq.push (['_trackEvent',"compte","compte",'click menu haut']);
        
    })
    
    $("#offres").click(function(){
        
        //getRubriqueAccueil("transaction","offres");
        $("#canvas_siloNav").css("display","block");
        location.hash="transaction_offres";
       _gaq.push (['_trackEvent',"transaction","offres",'click menu haut']);
    })
    
    $("#marches").click(function(){
        
        //getRubriqueAccueil("transaction","offres");
        $("#canvas_siloNav").css("display","block");
        location.hash="transaction_infosmarches";
        _gaq.push (['_trackEvent',"transaction","marches",'click menu haut']);
    })
    
    $("#bzDocs").click(function(){
       
        /**
         *@todo voir si se comportement est conservé sinon même comportement que messages  
         **/
        //getRubriqueAccueil("transaction","offres");
        $("#canvas_siloNav").css("display","none");
        location.hash="documents_index";
        _gaq.push (['_trackEvent',"documents","document",'click menu haut']);
    })
    
    
    
     $("#aide").click(function(){
        
        //getRubriqueAccueil("transaction","offres");
        $("#canvas_siloNav").css("display","block");
        //location.hash="transaction_offres";
          //action on icone info cell, beware define it before call silo object
 
            $.ajax({
                    url:"/aide/index/format/html",
                    success:function(data){
                        //console.log("data retour info",data);
                        $("#main").append(data);
                        //dialog analyse en affectation
                       $("#info").wijdialog({
                            autoOpen:true,
                            modal: true,
                            captionButtons:{
                            pin: { visible: false },
                            refresh: { visible: false },
                            toggle: { visible: false },
                            minimize: { visible: false },
                            maximize: { visible:false },
                            close: { visible: false} 
                            },
                            title:"Aide extranet Bz Grains",
                            width:"80%",
                            height:"600",
                            close:function(){
                                //destroy dialog
                                 $(this).wijdialog('destroy');
                                 $(this).remove();
                            }, open:function(e,ui){
                                   
                                    var dialog=$(e.target);
                                    if(!$(".sc-bt-dialog-close").length){
                                         $(e.target).parent().find(".ui-dialog-titlebar").append("<span class='sc-bt-dialog-close' style='cursor:pointer;position:absolute;right:5px;' ></div>");
                                                $(".sc-bt-dialog-close").bind("click",function(e){
                                                    dialog.wijdialog('close');
                                                })
                            }
                            }
                            }); 
                    }

                })
                
               
            
    });
    
    
    //--------------call messagerie taches document------/  
    function getNotificationDetail(notification){
        
        
        var type=$(notification).attr("code");
        
        
       /* $.ajax({
            url:"/push/"+type+"/format/html",
            success:function(data){ 
                deletePagecontent();
                // voir check data ou message error et redirection
                $("#main").html(data);
            },
            error:function(error){
                
            }
            
        })*/
        
         location.hash="push_"+type;
    }
    
    $(".n_click").click(function(evt){
        
        //delete alert
        $(".confirm").remove();
        
        getNotificationDetail(this);
        
        
    });
   
});//fin ready

// call when page is totaly load with childs
$(window).load(function(e){

    //create filtre for accueil rubriques  
    filter = new Filter();
    filter.setSelector("#D_filter");
    filter.createFilter();
    
    //init page resuest
    pageRequest=new UrlPageRequest(baseUrl,"accueil","accueil",null,null);
    
    //filter.setChecked(filter.getChecked())
    
    // click filtre show
    $("#filtre").click(function(evt){
        $("#D_filter").wijdialog("toggle");
    })
});


// bind a ready event for ajax return
// a this time the jquery ready was canceled.
$(window).bind("domReady",function(){
   
    // uiToolTip
    //$(".culture").tooltip({ position:"center-top"});
    
     /*$(".bzactive").tooltip({
        position:"center-top"
    });*/
})


           

        

      

 
            
       
        

