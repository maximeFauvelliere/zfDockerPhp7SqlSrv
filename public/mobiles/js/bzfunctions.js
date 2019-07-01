//init variables and function

var flagPageHelp = true,menu, activePage, defaultCamp, minCamp, maxCamp,timingBloc,formTimeOut,bzuser,nextPage,onLine=true;

var pageNoFilter=["sous-detail","sous-bzen","sous-bzenith","sous-stru-exec","sous-per-date","sous-pdts-derives","sous-qt","sous-recap","sous-validation","sous-recap-bzenith","sous-optimiz-ct","ctsign","administration-detail","execution-detail","mygraph","conn"];

function connect(id,pwd){
    bzuser=id;
    bzLoaderShow();
    var data={"identifiant":id,"pwd":pwd}
    $.ajax({
           
           url:"/mlogin/login/format/json",
           data:data,
           type:"POST",
           dataType:"json",
           success:function(data){
                    //console.log("data from login login",data);
           
                    $(".alertes p").text(data.message);
                    $(".alertes").slideDown("slow",function(){
                                   $(".alertes").delay(10000).slideUp("slow");
                    });
           
                    if(data.result!="error"){
                            try{
                                //set acc menu filter
                                data.acc["lastCall"]=new Date().getTime();
                                localStorage.acc =JSON.stringify(data.acc);
                                data.menu["lastCall"]=new Date().getTime();
                                data.menu["bzuser"]=bzuser;
                                localStorage.menu =JSON.stringify(data.menu);
                                data.filter["lastCall"]=new Date().getTime();
                                localStorage.filter =JSON.stringify(data.filter);
                            }catch(error){
           
                            }
           
           
                            //localStorage.rememberme=true;
           //condition pour resume lorsqu'on quitte sur acc
           if(activePage=="acc"){
                bzLoaderHide();
           }else{
            $(":mobile-pagecontainer").pagecontainer("change", "/maccueil/index/format/html");
           }
           
           
           
           
           
                    }else{
           
                        bzLoaderHide();
                    }
           
           },
        error:function(a,b,c){

           console.log("a",a);
           console.log("b",b);
           console.log("c",c);
           ajaxError(a.status,b);;
           
           }
           
           })
}


function initAcc() {
    if (typeof(Storage)!=="undefined") {
        //creation des object data si ils n'existe pas
        if (localStorage.acc) {

            var data = JSON.parse(localStorage.acc);

            lastCall = data.lastCall;

            //depuis combien de temps cet objet est stocké
            var bzNow = new Date().getTime();
            if ((bzNow - lastCall > maxLife)&& onLine) {

                //on recharge les données
                //console.log("acc+maxLife depassé")
                LoadAcc();
            } else {
                //console.log("intervalle temps OK ");
                templateRenderAcc(data)
            }
            $(".ui-loader").css("display","none");
            $(".bzLoader").hide();

        } else {
            //on charge les donnée
            //console.log("acc n'exite pas")
            LoadAcc();
        }



    } else {

        bzLocalStorage = false;
    }

}

function LoadAcc(){   

            if(!bzLocalStorage){
                
                $("#acc").append("<div class='not-compatible'>Votre smartphone n'est pas compatible avec notre application.</div>");
                return;
            }
            
           var filter=getFilter(JSON.parse(localStorage.filter));
            $.ajax({
                url: "/maccueil/index/format/json",
                data: {filter:filter},
                type: "POST",
                dataType: "json",
                success: function(data) {
                        if(data.success=="error"){
                                 
                                                if(data.type=="timeout"){
                                  
                                                        timeOut(data.type);
                                                        LoadAcc();
                                                        return;
                                                }else{
                                                        alert("Une erreur s'est produite, vous allez être redirigé.")
                                                        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index/");
                                                        return;
                                                }
                                  
                                        }

                    //add timeStamp to object
                   data["lastCall"]=new Date().getTime();
                    //render bzview
                    templateRenderAcc(data);
                    $(".ui-loader").css("display","none");
                    $(".bzLoader").hide();
                    //add to local storage
                    localStorage.acc=JSON.stringify(data);
                },

                error: function(a,b,c) {
                    console.log(a);
                    console.log(b);
                    console.log(c);
                   ajaxError(a.status,b);;

                }
            })
           }

/**
 *handlebarjs render for acc
 *
 **/
 function templateRenderAcc(data){

           //console.log("data from renderAccTPL",data)
           
                        //var template = $('#accTPL').html();
                        //var html = Handlebars.compile(template);
                        //var result = html(data);
                        try{ var template=Handlebars.templates['acc'];
                        var result = template(data);
                        $('#wrapper-acc-TPL').html(result); }catch(error){}
                        
                        //admin
                        //var template = $('#adminTPL').html();
                       // var html = Handlebars.compile(template);
                        //var result = html(data);
                        try{ var template=Handlebars.templates['accAdmin'];
                        var result = template(data);
                        $('#admin-wrapper-TPL').html(result); }catch(error){}
                        //exe
                        //var template = $('#exeTPL').html();
                        //var html = Handlebars.compile(template);
                        //var result = html(data);
                        try{ var template=Handlebars.templates['accExe'];
                        var result = template(data);
                        $('#exe-wrapper-TPL').html(result); }catch(error){}
                        //prospection
                        try{var template = $('#proTPL').html();
                        var html = Handlebars.compile(template);
                        var result = html(data);
                        //try{ var template=Handlebars.templates['accExe'];
                        //var result = template(data);
                        $('#pro-wrapper-TPL').html(result);}catch(error){
                        
                        }
                        
                         //refresh acc all
                        $("#refresh-matif-acc ").click(function(){
                            LoadAcc();
                            return false;
                       })
                       
                       setNavAcc();

           }
           
function loadMarches(){
    if(!onLine){
        if(localStorage.marches){
            var data=JSON.parse(localStorage.marches);
            myConvert(data);
            try{ var template=Handlebars.templates['marches'];
            var result = template(data);
            $('#MarchesTPL2').html(result); }catch(error){}
            $(".ui-loader").css("display","none");
            
            // table created
            $( ".t-marches" ).on( "tablecreate", function( event, ui ) {
                                 /*supprime le bt column a replacer lors du structurage*/
                                 $(".t-marches").on("tablecreate", function(event, ui) {
                                                    $(".ui-table-columntoggle-btn").remove();
                                                    });
                                 
                                 } );
            //create widget  table  reflow
            $(".t-marches").table();
            $("#collapsemarches").collapsible();
            
            // add click to tr
            $(".t-marches tr").click(function(e) {
                    alert("Réseau indisponible, nous ne pouvons pas afficher les détails.")
            })

            return;
        }else{
            alert("Réseau indisponible , nous ne pouvons pas afficher le marché.");
            return;
        }
       
    }
     $(".ui-loader").css("display","block")
    var filter=getFilter(JSON.parse(localStorage.filter));
            $.ajax({
                url: "/mmarches/index/format/json",
                dataType: "json",
                data: {filter:filter},
                success: function(data) {
                    //console.log("data marche",data);
                   
                   
                         if(data.success=="error"){
                                 
                                                if(data.type=="timeout"){
                                  
                                                        timeOut(data.type);
                                                        loadMarches();
                                                        return;
                                                }else{
                                                        alert("Une erreur s'est produite, vous allez être redirigé.")
                                                        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index/");
                                                        return;
                                                }
                                  
                                        }
                   localStorage.marches=JSON.stringify(data);
                    //convert tab
                    myConvert(this);
                    /*var template = $('#MarchesTPL').html();
                    var html = Handlebars.compile(template);
                    var result = html(data);*/
                   try{ var template=Handlebars.templates['marches'];
                   var result = template(data);
                    $('#MarchesTPL2').html(result); }catch(error){}
                   
                   $(".ui-loader").css("display","none");

                    // table created
                     $( ".t-marches" ).on( "tablecreate", function( event, ui ) {
                          /*supprime le bt column a replacer lors du structurage*/
                    $(".t-marches").on("tablecreate", function(event, ui) {
                            $(".ui-table-columntoggle-btn").remove();
                    });
                    
                     } );
                    //create widget  table  reflow
                    $(".t-marches").table();
                    $("#collapsemarches").collapsible();
                    
                    // add click to tr
                    $(".t-marches tr").click(function(e) {
                        var isUnlock = $(e.currentTarget).children().last().attr("isunlock");
                        ech=$(this).attr("ech");
                        libech=$(this).attr("libech");
                        ////console.log("hasUnlock", hasUnlock);
                        ////console.log("ech", ech);
                        clickMatifEche(isUnlock, ech,libech);
                    })
                    
                     //refresh acc all
                    $("#refresh-matif-marches").click(function(e){
                        loadMarches();
                        e.stopPropagation();
                        return false;
                    })
                    
                    
                },

                error: function(a,b,c) {
                    console.log(a);
                    console.log(b);
                    console.log(c);
                   ajaxError(a.status,b);;

                }
            })
}

/**
 * function pas en service
 **/
 function getNewFilter(camp,_filter){
     return;
                           _filter?_filter:0;
     alert("get new filter");
     if(!onLine){
         alert("Réseau indisponible.")
         return;
     }
     
                           $.ajax({
                                    url: "/mfilter/get/format/json/",
                                    data: {"filter":_filter,"camp":camp},
                                    type: "POST",
                                    dataType: "json",
                                    success: function(data) {
                                           if(data.success=="error"){
                                 
                                                if(data.type=="timeout"){
                                  
                                                        timeOut(data.type);
                                                        alert("Vous êtes déconnecté, vous allez être redirigé.")
                                                        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index");
                                                }else{
                                                        alert("Une erreur s'est produite, vous allez être redirigé.")
                                                        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index/");
                                                        return;
                                                }
                                  
                                            }
                                        //console.log("filtre",data);
                                        data["lastCall"]=new Date().getTime();
                                        templateRenderFilter(data);
                                        localStorage.filter=JSON.stringify(data);
                                        filter=data;
                                  
                                    },

                                    error: function(a,b,c) {
                                        console.log(a);
                                        console.log(b);
                                        console.log(c);
                                        ajaxError(a.status,b);;

                                    }
                                })
                
                }

function getFilter(filter){
var result={};
//console.log("filter from get filter",filter);
    //campagnes
    $.each(filter.filtre.campagnes.element,function(i,e){
            if(e.checked=="1"){
                result["camp"]=e.idcamp;
            }
    })
    //cultures
     result["cultures"]="";
     var objCu="";
     var objSt="";
     $.each(filter.filtre.cultures.element,function(i,e){
            if(e.checked=="1"){
                objCu+=e.idcu+";";
            }
    })
    result["cultures"]=objCu;
    
     //strcutures
     result["structures"]="";
     $.each(filter.filtre.structures.element,function(i,e){
            if(e.checked=="1"){
                objSt+=e.idti+";";
            }
    })
    result["structures"]=objSt;
    
    result["modify"]="false";
    
    
    ////console.log("final filter",result);
    
    return result;
    
}

//menu
function loadMenu(){
        //console.log("menu from load menu",JSON.parse(localStorage.menu))
        
                   /* var menu={"menu":{"element":[
                            {"checked":"0","rubrique":"contratencours"},
                            {"checked":"0","rubrique":"administration"},
                            {"checked":"1","rubrique":"execution"},
                            {"checked":"1","rubrique":"transaction"},
                            {"checked":"0","rubrique":"contratsasigner"}
                        ]}
                };*/
                  
                    var menu=JSON.parse(localStorage.menu);
                    templateRenderMenu(menu);
    
    
    }



// render filter
function  templateRenderMenu(data){
                    
                    //var template = $('#menuTPL').html();
                    //var html = Handlebars.compile(template);
    try{ var template=Handlebars.templates['menu'];
  
                    menu = template(data);
                    $('#wrapper-menuTPL').html(menu);
                    bindMenuClick();

                }catch(error){
                    
}
    }
    
function bindMenuClick(){
            //nav menu 
                $(".enable").click(function(evt){
                    if($(evt.currentTarget).hasClass("disable")){
                        $( ".menu-popup" ).popup( "open" );
                        return false;
                    }
                    bzLoaderShow();
               
                    //controle si il y a des contrat a bloquer et a signer
                    var a=$(evt.currentTarget).find(".notif-menu-ctsign");
                    var b=$(evt.currentTarget).find(".notif-menu-ctencours");
                    var spana=$(evt.currentTarget).find(".notif-menu-ctsign span");
                    var spanb=$(evt.currentTarget).find(".notif-menu-ctencours span");
                                   if(b.length>0 && $(spanb).text()=="0"){bzLoaderHide();;return false;}
                                   if(a.length>0 && $(spana).text()=="0"){bzLoaderHide(); return false;}
                    var z=activePage+".html";
                                   
                    if(z==$(evt.currentTarget).attr("href") || $(evt.currentTarget).attr("href")=="#" ){
                        bzLoaderHide();
                    }
                    $("#bz-menu").panel("close");
                    
                   
                  })
    
            //bt deconnexion
            $(".btout").off("click").on("click",function(evt){
                        localStorage.clear();
                        //$(":mobile-pagecontainer").pagecontainer("change", "/mindex/index/",{loadMsgDelay:0});
                        location.href="/mindex/index/";
            })
    
            //menu bas
            $(".footer a").click(function(evt){
                var a=$(evt.currentTarget).attr("href");
                var a=a.split(".")[0];
                                 
                    if(a=="marches"){
                                 
                                 a="infosmarches";
                                 if(!checkACL(a)){
                                    $(".menu-popup").popup("open");
                                    evt.preventDefault();
                                 }else{
                             
                                 $(".ui-loader").css("display","block")
                                 
                                    bzLoaderShow();
                                 }
                                 
                    }
                    if(a=="offres"){
                       
                                 if(!checkACL(a)){
                                 $(".menu-popup").popup("open");
                                 evt.preventDefault();
                                 }else{
                                 
                                 $(".ui-loader").css("display","block")
                                 
                        bzLoaderShow();
                                 }
                        
                                 
                    }
            
            })
    
            //bt-acc loader
            $(".bt-acc").off("tap").on("tap",function(){
                    if(activePage=="acc") return false;
                    $(".ui-loader").css("display","block")
                
            })

            /**
* aide site mobile
**/
  
$(".bt-aide").off("tap").on("tap",function(e){
  $(e.target).addClass("bt-aide-active");
  $("#popup-help-acc").popup("open");

})

$(".bt-close-help").off("tap").on("tap",function(e){
  $(".bt-aide").removeClass("bt-aide-active");
  $("#popup-help-acc").popup("close");

})



var activeHelp=1;
var numberHelpMax=6;
 $(document).on('swipeleft','#popup-help-acc', function(event) {
                    
                      
                      //check page No filter

                      if (event.handled !== true) // This will prevent event triggering more then once
                      {
                  
                            event.handled = true;
                            activeHelp=activeHelp<numberHelpMax?activeHelp+1:numberHelpMax;
                            alert("aide"+activeHelp);
                            if(activeHelp<=numberHelpMax) $( "#img-aide" ).attr("src","/mobiles/css/img/aide/aide"+activeHelp+".png");
                      
}
                      return false;
                      });
 $(document).on('swiperight','#popup-help-acc', function(event) {

                      //check page No filter

                      if (event.handled !== true) // This will prevent event triggering more then once
                      {
                  
                            event.handled = true;
                            activeHelp=activeHelp>1?activeHelp-1:1;
                            alert("aide"+activeHelp);
                            if(activeHelp>=1) $( "#img-aide" ).attr("src","/mobiles/css/img/aide/aide"+activeHelp+".png");
                      
                      }
                      return false;
                      });


  
}


// render filter
function templateRenderFilter(data){

                    try{
                        $(".filterInput").off("change");
                        $(".bt-cancel-filtre").off("click");
                        $(".bt-valid-filtre").off("click");
                        $("#bz-filter").panel("close");
                        $("#bz-filter").trigger("create");
                        $(".filterInput").trigger("create");
                        $("#bz-filter").panel("refresh");
                        //$(".filterInput").trigger("create");
                        //$(".filterInput").checkboxradio("refresh");

                    }catch(error){
                    
                    }
    
                    myConvert(data);
                    //console.log("data from local filter templateRenderFilter",data)
                    //var template = $('#filterTPL').html();
    try{ 
    var template=Handlebars.templates['filter'];
    var filterHtml=template(data);
    
                    //var html = Handlebars.compile(template);
                    //var filterHtml = html(data);
                    $('.wrapper-filterTPL').html(filterHtml);
                }catch(error){
                    
                }
                    //page camp header
                    setCampHeader();
                    //filter events
                      filterEvents();
    
                      try{
                          $("input[type='checkbox']").checkboxradio();
                          $("input[type='radio']").checkboxradio();
                     }catch(e){
                         
                     }
             

    
    }
    
/**
 * check les autorisation pour la navigation
 *return true if allow
 **/
function checkACL(rubrique){
    var me=JSON.parse(localStorage.menu).menu.element;
    var check=0;
    $.each(me,function(i,e){
           if(e.rubrique==rubrique && e.checked=="1"){
                //console.log("rubrique",rubrique)
                check=1;
           }
           
           
           
    })
    
    return check;
}

function filterEvents(){
                    //laissé en stand by
                   /* $(".bt-valid-filtre").click(function(e){
                            var idCamp=$("#F_camp input:checked").attr("idcamp");
                            getNewFilter(idCamp);
                    })
                    
                    $(".bt-cancel-filtre").click(function(e){
                            $("#bz-filter").panel("close");
                            templateRenderFilter(data);
                    })*/
                    
                    $(".filterInput").change(function(e,data){
                                 
                                             e.stopPropagation();
                                             
                        $(".ui-loader").css("display","block");
                        var filter=JSON.parse(localStorage.filter);
                        if(!onLine){
                                             alert("Réseau indisponible.");
                                             $(".ui-loader").css("display","none");
                                             $("#bz-filter").panel("close");
                                             return false;
                        }
                        //---- adaptation for swipe left right cht campagne appeller par trigger----//
                        //console.log("data from change event on filter",data);
                        var name;
                        var camp;
                        if(data){
                            ////console.log("from trigger event change",data)
                            name="camp";
                            camp=data.camp;
                        }else{
                           ////console.log("e from filter ",e)
                           name=$(e.currentTarget).attr("name");
                           camp=$(e.currentTarget).attr("idcamp");
                        }
                        switch(name){
                                
                                case "camp":
                                        $("#bz-filter").panel("close");
                                             var idCamp=camp;
                                             //console.log("idCamp",idCamp);
                                             
                                              $.ajax({
                                                            url:"/mfilter/get/format/json",
                                                            data:{"filter":0,"camp":idCamp},
                                                            type:"POST",
                                                            dataType:"json",
                                                            success:function(data){
                                                                        //console.log("data from filter get",data.filtre);

                                                                        if(data.result!="error"){
                                                                            
                                                                            data["lastCall"]=new Date().getTime();
                                                                            templateRenderFilter(data);
                                                                            localStorage.filter=JSON.stringify(data);
                                                                            refreshPage();
                                                                        }else{
                                                                            alert("erreur, vous allez être redirigé. ")
                                                                            $( ":mobile-pagecontainer" ).pagecontainer( "change","index.html");
                                                                        }

                                                            },
                                                            error:function(a,b,c){

                                                                console.log("a",a);
                                                                console.log("b",b);
                                                                console.log("c",c);
                                                                ajaxError(a.status,b);;


                                                            }

                                                        })
                                       
                                break;
                                case "cultures":
                                        var idCu=$(e.currentTarget).attr("idcu");
                                        $.each(filter.filtre.cultures.element,function(i,e){
                                            if(e.idcu==idCu){

                                               if(e.checked==="0"){
                                                    e.checked="1";
                                               }else{
                                                    e.checked="0";
                                               }
                                             }
                                             //console.log("result culture ",e.idcu+":"+e.checked )                                             
                                        })
                                        localStorage.filter =JSON.stringify(filter);
                                        refreshPage();
                                break;
                                case "structures":
                                        var idTi=$(e.currentTarget).attr("idti");
                                        $.each(filter.filtre.structures.element,function(i,e){
                                            if(e.idti==idTi){
                                                    if(e.checked==="0"){
                                                        e.checked="1";
                                                    }else{
                                                        e.checked="0";
                                                    }
                                             }
                                             
                                             //console.log("result culture ",e.idti+":"+e.checked )
                                        })
                                        localStorage.filter =JSON.stringify(filter);
                                        refreshPage();
                                break;

                        }
                        
                        //close panel
                        //$("#bz-filter").panel("close");
                        //notifications();
                    })
    
    }
    
    
function refreshPage(){
    setTimeout(function(){
               //event rechargement de la page
               switch(activePage){
               
               case "administration":
               $("#administration").trigger("filterReady");
               break;
               case "execution":
               $("#execution").trigger("filterReady");
               break;
               case "transaction":
               $("#transaction").trigger("filterReady");
               break;
               case "offres":
               $("#offres").trigger("filterReady");
               break;
               case "acc":
               $("#acc").trigger("filterReady");
               break;
               case "marches":
               $("#marches").trigger("filterReady");
               break;
               case "prospection":
               $("#prospection").trigger("filterReady");
               break;
               
               }

               notifications();
               
               
               },1000)
    
    }




/**
 * Init la navigation pour cette page
 *
 */
function setNavAcc(){
    
                         //navigation click / blocks
                    $(".block-marches").click(function() {
                                             
                                              if(!checkACL("infosmarches")){
                                                    $(".menu-popup").popup("open");
                                                    return false;
                                              }
                                              
                                              $(".ui-loader").css("display","block");
                        $(":mobile-pagecontainer").pagecontainer("change", "/mmarches/index/format/html",{loadMsgDelay:0});
                    })
                    $(".block-offres").click(function() {
                        if(!checkACL("offres")){
                                $(".menu-popup").popup("open");
                                return false;
                        }
                                             $(".ui-loader").css("display","block");
                        $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/offres/format/html",{loadMsgDelay:0});
                    })
                    $(".block-transaction").click(function() {
                      if(!checkACL("transaction")){
                                    $(".menu-popup").popup("open");
                                    return false;
                      }
                                                  $(".ui-loader").css("display","block");
                        $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/index/format/html",{loadMsgDelay:0});
                    })
                    $(".block-administration").click(function() {
                        if(!checkACL("administration")){
                                $(".menu-popup").popup("open");
                                return false;
                        }
                                                     $(".ui-loader").css("display","block");
                        $(":mobile-pagecontainer").pagecontainer("change", "/madministration/index/format/html",{loadMsgDelay:0});
                    })
                    $(".block-execution").click(function() {
                        if(!checkACL("execution")){
                                $(".menu-popup").popup("open");
                                return false;
                        }
                                                $(".ui-loader").css("display","block");
                        $(":mobile-pagecontainer").pagecontainer("change", "/mexecution/index/format/html",{loadMsgDelay:0});
                    })
                    $(".block-prospection").click(function() {
                                if(!checkACL("prospection")){
                                        $(".menu-popup").popup("open");
                                        return false;
                                }
                                                  $(".ui-loader").css("display","block");
                                $(":mobile-pagecontainer").pagecontainer("change", "/mprospection/index/format/html",{loadMsgDelay:0});
                    })

    
    
                }

function setCampHeader(){
                        var camp="";
    var length=$("#F_camp").find(".filterInput").length;
    var first=$("#F_camp").find(".filterInput")[0];
    var last=$("#F_camp").find(".filterInput")[length-1];
    minCamp=$(first).attr("idcamp");
    maxCamp=$(last).attr("idcamp");
    ////console.log("minCamp",minCamp);
    ////console.log("maxCamp",maxCamp);
                        $("#F_camp").find(".filterInput").each(function(i,e){

                                if($(this).attr("checked")=="checked"){
                                    camp=defaultCamp=$(this).attr("idcamp");
                                                               
                                }
                        })
                        
                        camp="CAMP 20"+camp;
                        $(".header-content-camp").html(camp);
    ////console.log("defaultCamp",defaultCamp)
                 }

 function deleteLocalStorageData(){
              
                        var idbzuser,pwd,menu,filter,rememberMe;

                        if(localStorage.idbzuser) idbzuser=localStorage.idbzuser;
                        if(localStorage.pwd) pwd=localStorage.pwd;
                        if(localStorage.rememberme) rememberMe=localStorage.rememberme;
                        if(localStorage.menu) menu=localStorage.menu;
                        if(localStorage.filter) filter=localStorage.filter;
                        
                        localStorage.clear();
                        //console.log("idbzuser",idbzuser)
                        localStorage.menu=menu;
                        localStorage.filter=filter;
                        if(idbzuser) localStorage.idbzuser=idbzuser;
                        if(pwd) localStorage.pwd=pwd;
                        if(rememberMe) localStorage.rememberme=rememberMe
               }

/**
 * show popup choix courbe ou liste contrats a bloquer
 * @param {type} data
 * @returns {createCandles}
 */
function clickMatifEche(isUnlock, ech) {
                    //console.log("unlock",isUnlock)
                    if (isUnlock == "unlock") {
                        //create and show popup 
                        var $popUp = $('<div data-role="popup" class="matif-popup"><a href="#" data-rel="back" data-role="button" data-theme="c"  data-iconpos="notext" class="ui-btn-right">X</a><span>Voulez-vous :</span><div id="show-graph" ech="1"><span class="popup-ico-graph"></span><span>Voir la courbe</span></div><div id="show-ct-to-lock" idct="1"><span class="popup-ico-ct"></span><span>Voir mes contrats en cours</span></div></div>').popup({
                        }).bind("popupafterclose", function() {
                            //remove the popup when closing
                            $(this).remove();
                        });

                        $popUp.popup("open");


                        $("#show-graph").bind("click", function() {
                            $(":mobile-pagecontainer").pagecontainer("change", "/mmarches/graph/format/html",{loadMsgDelay:0});
                        })

                        $("#show-ct-to-lock").bind("click", function() {
                            $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/contratsencours/format/html",{loadMsgDelay:0});
                        })

                        // var popup='<div data-role="popup" class="matif-popup"><a href="#" data-rel="back" data-role="button" data-theme="b" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a></div>'
                    } else {
                        
                        //show graph ech
                        $(":mobile-pagecontainer").pagecontainer("change", "/mmarches/graph/format/html",{loadMsgDelay:0});
                    }
                }
//function notification call
function notifications(){
    
    if(!onLine) return;
    
        var filter=getFilter(JSON.parse(localStorage.filter));

       $.ajax({
                url: "/mpush/notifications/format/json",
                data: {"filter":filter},
                type: "POST",
                dataType: "json",
                success: function(data) {
              
                             if(data.success=="error"){
                                 
                                                if(data.type=="timeout"){
                                  
                                                        timeOut(data.type);
                                                        notifications();
                                                        return;
                                                }else{
                                                        alert("Une erreur s'est produite, vous allez être redirigé.")
                                                        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index/");
                                                        return;
                                                }
                                  
                                        }

                    var mn=$(menu);

                    $(".notif-menu-ctencours",mn).html("<span>"+data[0].nbctblock+"</span>");
                    $(".notif-menu-ctsign",mn).html("<span>"+data[0].nbctsign+"</span>");
                    $(".notif-menu-ctencours").html("<span>"+data[0].nbctblock+"</span>");
                    $(".notif-menu-ctsign").html("<span>"+data[0].nbctsign+"</span>");
                    menu=mn;

                    //$(".notif-menu").css("visibility","visible");
                    //$(".menu-popup").trigger("create");
                },
              
                error: function(a,b,c) {
                    console.log(a);
                    console.log(b);
                    console.log(c);
                    ajaxError(a.status,b);;

                }
    }) 
}
//push 
function pushNotification(){
   
    
    setInterval(function(){
        
         if(activePage=="conn") return;
   
         notifications();

    },900000)
    
    
}
pushNotification();


function bzLoaderShow(){
  
    $(".bzLoader").css("display","block");
    $(".bt-init-appli").attr("disabled","disabled");
    
    //bind bt actu
    $(".bt-init-appli").off('click').on('click',function(){
            
        //$(":mobile-pagecontainer").pagecontainer("change", "index.html",{loadMsgDelay:0});
                                        window.location.href="/mindex/index/";
                                        
     })
    setTimeout(function(){
               
               $(".bt-init-appli").removeAttr('disabled');
     },5000);
}

function bzLoaderHide(){
    $(".ui-loader").css("display","none");
    $(".bzLoader").css("display","none");
    $(".bt-init-appli").attr("disabled","disabled");
    
}


/**
 * gere la redirection apres time out 
 */
function timeOut(data){

    switch(data){
                        case "timeout":
            
                                if(activePage.match(/^sous/i) || localStorage.bzuser==""){
                                        alert("Vous avez été déconnecté, vous allez être redirigé.")
                                        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index/",{loadMsgDelay:0});
                                        return;

                
                                }else{
                                    bzLoaderShow();
                                    
                                    var data={"identifiant":localStorage.idbzuser,"pwd":localStorage.pwd}
                                    $.ajax({
                                           
                                           url:"/mlogin/logindirect/format/json",
                                           data:data,
                                           type:"POST",
                                           dataType:"json",
                                           success:function(data){
                                                //console.log("data from login direct",data);
                                                if(data.result=="error"){
                                                    alert("Vous avez été déconnecté, vous allez être redirigé.")
                                                    $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index/",{loadMsgDelay:0});
                                                    return;
                                                }else{
                                                        bzLoaderHide();

                                                }

                                           },
                                           error:function(a,b,c){

                                                console.log("a",a);
                                                console.log("b",b);
                                                console.log("c",c);
                                                ajaxError(a.status,b);;

                                           }
                                           
                                 })

                        break;
                    }
    }
}

// events


function ajaxError(status,error){
    
    if(status=="500"){
        bzLoaderHide();
        alert("Une erreur s'est produite, vous allez être redirigé.");
        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index/");
        return;
    }
    
    if(error=="timeout" || error=="error" || error=="abort"){
        bzLoaderHide();
       alert("Réseau indisponible ou degradé.")
    }else if(error=="parsererror"){
        bzLoaderHide();
        alert("Une erreur s'est produite, vous allez être redirigé.");
        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index/");
        return;
        
    }
}

$(document).off('pagebeforeshow').on('pagebeforeshow', function(e,data) {
                     
                                     if(onLine){
                                        $(".offline").css("display","none");
                                     }else{
                                        $(".offline").css("display","block");
                                     }
                    
                    activePage = $.mobile.activePage.attr('id');
                    //console.log("pagebeforechange active page appli html",activePage);
                    prevPage=data.prevPage.attr('id');
                    //console.log("prev page  appli html",prevPage);
                   
                    if(activePage!="conn") bzLoaderHide();
                    
                    if(activePage=="acc"){
                                     $('[data-rel="back"]').addClass("ui-disabled");
                                     }else{
                                     $('[data-rel="back"]').removeClass("ui-disabled");
                                     }
                    
                    //close popup
                    $(".popup-actu-cts").popup("close");
                    $(".menu-popup").popup("close");
                    
                    //showPageHelp();
                    // delete timer
                    if(activePage!="list-ct") clearInterval(timingBloc);
                    if(activePage!="cttolocksurf" && activePage!="cttolockvalid"){ 
                        clearTimeout(formTimeOut);}
                    switch(activePage){
                        
                    }
                })







window.onbeforeunload = function(e) {
    //console.log("active page onebefore unload",activePage)
    if(activePage=="ctsign"){
        return;
    }else{
        return "Attention ! si vous quittez la page";
    }
 
};

 (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','public/mobiles/js/analytics.js','ga');



