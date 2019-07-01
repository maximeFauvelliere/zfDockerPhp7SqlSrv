<div data-role="page" data-ajax="false" id="conn">
       <div id="logo-ebz"><img src="/mobiles/css/img/pictos/ebz.min.svg" alt="logo"/></div>
<div class="alertes" style="display:none"><p></p></div>
<div style="text-align: center">
    <p style="text-align: center;width: 300px;margin: auto;">
        Pour vous connecter, vous devez avoir effectué votre 1ère connexion sur ordinateur. 
    </p>
</div>
<div class='login'>
    <form  id="id-form"  class=" loginForm">
        <label>Identifiant</label><input type="text" name="identifiant" id="identifiant"/>
        <label>Mot de passe</label><input type="password" name="pwd" id="pass"/>
        
       
	<label for="chck-conn">Se souvenir de moi</label>
                <input id="chck-conn" data-iconpos="right" type="checkbox" />
                <div style="width: 100%;text-align: right">
                    <a id="btPwdLost" href="">Mot de passe oublié</a>
                </div>
        <div id="menu-connex">
            <a href="tel:0033232672060"><img src="/mobiles/css/img/pictos/tel.min.svg"/></a>
            <input id="bt-connect" data-type="button" data-theme="c" type="submit" value="connexion"/>
            
        </div>
                
    </form>
    <div data-role="popup" id="popupDialog" data-overlay-theme="a" data-theme="b" style="max-width:400px;" class="ui-corner-all">
			<div data-role="header" data-theme="a" class="ui-corner-top">
				<h1>Application</h1>
			</div>
			<div data-role="content" data-theme="b" class="ui-corner-bottom ui-content">
				<p style="padding: 10px;font-size: 16pt;">Souhaitez vous télécharger notre application ?</p>
                                                                <div style="margin:auto;width:95%;text-align: center;">
                                                                 <a href="#" id="bt-valide-app" data-role="button" data-inline="true" data-rel="back" data-transition="flow" data-theme="b">Oui</a>
				<a href="#" id="bt-annule-app" data-role="button" data-inline="true" data-rel="back" data-theme="b">Non</a>    
				
                                                                <label for="chk-notrememberapp">Ne plus me demander </label>
                                                                <input type="checkbox" id="chk-notrememberapp" />
                                                                </div>
			</div>
		</div>
    
</div>
<div class="clear"></div>
<div style="height: 35px;width: 100%"></div>
<script>
 
 var application="sitemobile";
 
 //set global pour filtre sur toute les pages
 var filterData="";
    
 if (typeof(Storage)!=="undefined"){
        
        $(".bzLoader").css("display","none");
        if( localStorage.rememberme && localStorage.idbzuser!="" && localStorage.pwd!=""){
                 $("#identifiant").val(localStorage.idbzuser);
                 $("#pass").val(localStorage.pwd);
                 $("#chck-conn").attr("checked",true);
                
        }
        
        
 }else{
     $("#bt-connect").attr("disabled","disabled");
     $("#chrgt-text").html("Votre périphérie n'est pas compatible avec notre application. Veuillez contacter votre commercial.<br/> au : 02.32.67.20.60")

 }
    
$( "#id-form" ).submit(function( event ) {
    
    if($("#identifiant").val()=="" || $("#pass").val()==""){
         $(".alertes p").text("Vous devez entrer un identifiant et un mot de passe.");
         $(".alertes").slideDown("slow",function(){
                 $(".alertes").delay(10000).slideUp("slow");
         });
        return false;
    }

//$( ":mobile-pagecontainer" ).pagecontainer( "change", "appli.html");
   var data={"identifiant":$("#identifiant").val(),"pwd":$("#pass").val()}
   $.ajax({
            url:"/mlogin/login/format/json",
            data:data,
            type:"POST",
            dataType:"json",
            success:function(data){
                        console.log("data from login login",data);
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
                            data.menu["bzuser"]=$("#identifiant").val();
                            localStorage.menu =JSON.stringify(data.menu);
                            data.filter["lastCall"]=new Date().getTime();
                            localStorage.filter =JSON.stringify(data.filter);
                            }catch(error){
                            
                            }

                            if($("#chck-conn")[0].checked){
                                 
                                        localStorage.rememberme=true;
                                        if(localStorage.idbzuser!="" && localStorage.pwd!=""){
                                             // check inline help preference
                                            localStorage.idbzuser =$("#identifiant").val();
                                            localStorage.pwd=$("#pass").val();
                                            
                                        }

                                      $(":mobile-pagecontainer").pagecontainer("change", "/maccueil/index/format/html");
                                   
                           }else{
                               localStorage.rememberme=false;
                               $(":mobile-pagecontainer").pagecontainer("change", "/maccueil/index/format/html");
                           }
                    }
                    
            },
            error:function(a,b,c){
                console.log("a",a);
                console.log("b",b);
                console.log("c",c);
                
            }

        })
        //location.href="appli.html";
event.preventDefault();
});


  $("#btPwdLost").click(function(){
    
        if($("#identifiant").val()==""){
            $(".alertes p").text("Vous devez entrer votre identifiant avant de demander le renouvellement de votre mot de passe.");
            $(".alertes").slideDown("slow",function(){
                    $(".alertes").delay(10000).slideUp("slow");
            });
            return false;
        }
        
        //show alerte
        //alert("Un email vient de vous être envoyé. Cliquez sur le lien pour modifier votre mot de passe.");
        //declenche envois email pour changement.
        var data={"login":$("#identifiant").val()};
        $.ajax({
            url:"/mindex/mpo/format/json",
            data:data,
            type:"POST",
            dataType:"json",
            success:function(data){
                $(".alertes p").text(data.message);
                $(".alertes").slideDown("slow",function(){
                    $(".alertes").delay(10000).slideUp("slow");
                });
                
                //$.cookie("pwdLost", "true", { expires: 365 * 10, path: '/' });

            }
        })
        
        return false;
    })
        
 function onOffLine(){
  alert("offline")
    onLine=false;
    setTimeout(function(){
               $(".offline").css("display","block");
    },300)
    if(activePage=="conn")indexInit();
    
}
 
 function onLine(){
 alert("online")
    onLine=true;
    setTimeout(function(){
               $(".offline").css("display","none");
    },300)
    
    if(activePage=="conn")indexInit();
} 



$(document).ready(function(){
      
        setTimeout(function(){
                var store="";
          
                if(navigator.userAgent.match(/iphone/gi)){
                      store="https://itunes.apple.com/us/app/sas-beuzelin-maison-e-bz/id883679765?l=fr&ls=1&mt=8";
                   
                   
                }else if(navigator.userAgent.match(/android/gi)){
                    store="https://play.google.com/store/apps/details?id=com.septcinquante";
                   
                }else{
                    return;
                }
                
                  if(!localStorage.rememberapp==true) $("#popupDialog").popup("open");
                  
                    $("#bt-annule-app").on("tap",function(){
                           if($('#chk-notrememberapp').is(':checked')) localStorage.rememberapp=true;
                    })
                    $("#bt-valide-app").on("tap",function(){
                          location.href=store;
                    })
                
                
         },500)
        console.log
       document.addEventListener("offline", onOffLine, false);
       document.addEventListener("online", onLine, false);
       
       ////console.log("ressource phone gap",window.Plugin)
       //-------------swipe------------//
       //event swipe
       $(document).on('swipeleft','.ui-content', function(event) {
                    
                      
                      //check page No filter
                      var flag=false;
                      $.each(pageNoFilter,function(i,e){
                             
                           
                             if(activePage==e) flag=true;
                             
                      })
                      
                      if(flag) return false;
                      
                      
                      
                      var camp=(parseInt(defaultCamp)+1)>maxCamp?maxCamp:(parseInt(defaultCamp)+1);
                      
                      if(defaultCamp==maxCamp)return false;
                      
                      if (event.handled !== true) // This will prevent event triggering more then once
                      {
                      event.handled = true;
                     
                      //ChangeCamp($(this).attr("id"), camp, "left")
                      $("#ca0").trigger("change",[{camp:camp}])
                      
                      }
                      return false;
                      });
                      
                      
        $(document).on('swiperight', '.ui-content', function(event) {
                                 
                                   
                                     
                       //check page No filter
                       var flag=false;
                       $.each(pageNoFilter,function(i,e){
                              
                              
                              if(activePage==e) flag=true;
                              
                              })
                       
                       if(flag) return false;

                                     
                                     var camp=(parseInt(defaultCamp)-1)<minCamp?minCamp:(parseInt(defaultCamp)-1);
                                     
                                     if(defaultCamp==minCamp)return false;
                                     
                                     if (event.handled!== true) // This will prevent event triggering more then once
                                     {
                    
                                     event.handled = true;
                                     //ChangeCamp($(this).attr("id"), camp, "right")
                                     
                                                $("#ca0").trigger("change",[{camp:camp}])
                                     
                                     
                                     
                                     
                                     }
                                     return false;
                                     });
        //----------fin swipe
        

})


    
</script>
</div>