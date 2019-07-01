<div  data-role="page" id="ctsign"><!-- contrats a signer-->
    <div data-role="popup" id="menu-popup"  class='ui-content-menu-popup menu-popup' data-theme="b">
        Vous n'avez pas accès à cette rubrique.
    </div>
                     <div data-role="header" data-position="fixed" data-tap-toggle="false">
                <div data-role="panel" id="bz-menu" class="bzmenu"  data-display="overlay" data-position="right" data-theme="b" data-close="" > 
                    <div class="bz-menu-html">
                        
                    </div>
                </div><!-- fin panel menu-->
                <div class="header-item header-left"><a href="#" data-rel="back"><img src="/mobiles/css/img/pictos/back.min.svg" width="30"/></a></div>
                <div class="header-item header-center"><a class="bt-acc"  href="/maccueil/index/format/html"><img src="/mobiles/css/img/pictos/ebz.min2.svg" width="80"/></a></div>
                <div class="header-item header-right"><a href="#bz-menu"  ><img src="/mobiles/css/img/pictos/menu.min.svg" width="30"/></a></div>
               <div class="bt-aide" ></div>                 <div class="offline" style="display:none;">Vous êtes hors réseaux, les données affichées ne sont pas à jour, vous n'avez pas accés à la commercialisation.</div>
            </div><!-- /header -->
            <div class="clear"></div>

            <div data-role="content" >
                    <div class="block-hor-layout">

                        <h2>
                            Contrats à signer
                        </h2>
                        <script id="contrat-to-signTPL" type="text/x-handlebars-template">
                            {{#if contratstosign.element}}
                        <table class="ctsign-list">
                            <thead>
                                <tr>
                                    <th >N° ct</th>
                                    <th>Date ct</th>
                                    <th>Qté / Surf</th>
                                    <th>Prix</th>
                                </tr>
                            </thead>
                            <tbody>
                                {{#bzeach contratstosign.element}}
                                 <tr  id="{{idct}}" etat="{{etat.etat}}" path="{{path}}" ctsign="{{ctsign}}">
                                        <td>{{nct}}</td>
                                        <td>{{datect}}</td>
                                        <td>{{qte}}</td>
                                        <td>{{prix}}</td>
                                </tr>
                                {{/bzeach}}
                            </tbody>
                        </table>
                        {{else}}
                            Il n'y a pas de données à afficher. 
                        {{/if}}
                    </script>
                    <div id="wrapper-contrat-to-signTPL"></div>
                    </div>
                
            </div>
            <div class="footer" id="footer-ctsign" data-role="footer" data-position="fixed" data-tap-toggle="false">
               
            </div><!-- /footer -->
            <script>
                 $("#footer-ctsign").html(footer);
                $(".bz-menu-html").html(menu);
                bindMenuClick();
                $(".menu-popup").trigger("create");
                function loadCtsign(){
                        var filter=getFilter(JSON.parse(localStorage.filter));
                        $(".ui-loader").css("display","block")
                        $.ajax({
                                url: "/madministration/contratsasigner/format/json",
                                data: {filter: filter},
                                type: "POST",
                                dataType: "json",
                                success: function(data) {
                               
                                        if(data.success=="error"){
                                            if(data.type=="timeout"){
                                                timeOut(data.type);
                                                loadCtsign()
                                                return;
                                            }else{
                                                alert("Une erreur s'est produite, vous allez être redirigé.")
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index");
                                            return;
                                            }
                               
                                        }
                               
                                    data["lastCall"]=new Date().getTime();
                                    localStorage.ctsign =JSON.stringify(data);
                                    //console.log("data ctsign",data);
                                    templateRenderCtsign(data);
                               $(".ui-loader").css("display","none")
                                },

                                error: function(a,b,c) {
                                    console.log(a);
                                    console.log(b);
                                    console.log(c);
                                    ajaxError(a.status,b);;

                                }
                    })
                }
                
                function templateRenderCtsign(data){
                            /*var template = $('#contrat-to-signTPL').html();
                            var html = Handlebars.compile(template);
                            var result = html(data);*/
                            try{ var template=Handlebars.templates['cttosign'];
                            var result = template(data);
                            $('#wrapper-contrat-to-signTPL').html(result); }catch(error){}

                            //bind click on table tr
                            $(".ctsign-list tr").click(function(e){
                                //check if contrat is waiting

                                //if($(e.currentTarget).attr("etat")=="0"){
                                if($(e.currentTarget).attr("etat")!="0"){
                                    alert("contrat en cour de validation");
                                    return false;
                                }
                                
                                                      // //console.log("check path")
                                                       
                                if(!$(e.currentTarget).attr("path").match(/^CT/g)){
                                    alert("Contrat non disponible à la signature.");
                                    return false;
                                }
                                
                                
                                var path=$(e.currentTarget).attr("path");
                                var idCt=$(e.currentTarget).attr("id");
                                var ctSign=$(e.currentTarget).attr("ctsign");
                            
                            clickCtsign(path,idCt,ctSign);

                        })
                }
                
                 if(localStorage.ctsign ){
                //if(false){
                                //console.log("local storage ctsign")
                                var data=JSON.parse(localStorage.ctsign);
                                var lastCall=data.lastCall;
                                if((new Date().getTime()-lastCall>maxLife) && onLine){
                                    //console.log("delais depassé");
                                     loadCtsign();
                                }else{
                                    //console.log("dans le delais ou offLine")
                                    templateRenderCtsign(data)
                                }
                        }else{
                                //on charge les donnée
                                //console.log("ct sign n'exite pas")                          
                                loadCtsign(); 
                        }
            
   
   function clickCtsign(path,idCt,ctSign) {
   
                //create and show popup 
                var $popUp = $('<div data-role="popup" class="matif-popup"><a href="#" data-rel="back" data-role="button" data-theme="c"  data-iconpos="notext" class="ui-btn-right">X</a><span>Voulez-vous :</span><div id="show-ct" ech="1"><span class="popup-ico-visu"></span><span>Visualiser le contrat</span></div><div id="sign-ct" idct="1"><span class="popup-ico-signct"></span><span>Signer le contrat</span></div></div>').popup({
                }).bind("popupafterclose", function() {
                    //remove the popup when closing
                    $(this).remove();
                });

                $popUp.popup("open");


                $("#show-ct").bind("click", function(e) {
                   
                    $popUp.popup("close");
                                   
                    window.open("/mtelechargement/directdownload/ctsign/1/path/"+path,"_blank");
                })

                $("#sign-ct").bind("tap", function() {
                    $popUp.popup("close");
                    setTimeout(function() {
                        var $popUpCtsign = $('<div data-role="popup" class="popup-list popup-valid-ct"><a href="#" data-rel="back" data-role="button" data-theme="c"  data-iconpos="notext" class="ui-btn-right">X</a></div>').popup({
                        }).bind("popupafterclose", function() {
                            //remove the popup when closing
                            $(this).remove();
                        });

                        var $popupHeader = $('<h3><span>Signature contrat en ligne</span></h3>');
                        $popUpCtsign.append($popupHeader);

                        var $content = $('<div class="valid-ctsign"><span>Vous souhaitez signer numériquement le contrat numéro :</span><br/><span>73301</span><label>Mot de passe</label><input id="ctsign-pwd" type="password" /><a href="#" class="to-refresh"  data-role="button" data-theme="d" data-rel="back">Annuler</a><a href="#" id="bt-ct-sign-valid" class="to-refresh"  data-role="button" data-theme="d">Valider</a></div>');
                        $popUpCtsign.append($content);

                        //refresh widget button
                        $('.to-refresh').button();

                        $popUpCtsign.popup("open");
                              
                               
                               
                       
                        $("#bt-ct-sign-valid").tap(function(evt){
                                                   if(!onLine){
                                                   $(".offline").css("display","block");
                                                   return false;
                                                   }else{
                                                   $(".offline").css("display","none");
                                                   }
                                    if($("#ctsign-pwd").val().length<=0){
                                        alert("Vous devez entrer un mot de passe.")
                                        return false;
                                    }else if($("#ctsign-pwd").val().length<9){
                                        alert("Votre mot de passe doit contenir au moins 9 caractères.")
                                        return false;
                                    }
                                    var pwd=$("#ctsign-pwd").val();
                                    var dataCtSign={"path":path,"ctsign":ctSign,"idct":idCt,"pwd":pwd}
                                      $(".ui-loader").css("display","block")
                                    $.ajax({
                                        url: "/madministration/ctvalidation/format/json",
                                        data: dataCtSign,
                                        type: "POST",
                                        dataType: "json",
                                        success: function(data) {
                                           if(data.success=="error"){
                                           $(".ui-loader").css("display","none")
                                                switch(data.type){
                                                    case "pwd":
                                                        alert("erreur mot de passe.");
                                                    break;
                                                    default:
                                                        alert("Une erreur s'est produite");
                                                        $popUpCtsign.popup("close");
                                                    break;
                                                
                                                }
                                           }else{
                                           $(".ui-loader").css("display","none")
                                                $(evt.currentTarget).addClass("ui-disabled");
                                                alert("Votre contrat a été signé.")
                                                var a=JSON.parse(localStorage.ctsign).contratstosign.element
                                                a=convertElementToArray(a);
                                           
                                                $.each(a,function(i,e){
                                                  
                                                       try{
                                                        if(e.idct==idCt){
                                                            a.splice(i,1)
                                                        }
                                                       }catch(error){
                                                  
                                                       }
                                                })
                                                a={"contratstosign":{"element":a}}
                                                a["lastCall"]=new Date().getTime();
                                                localStorage.ctsign =JSON.stringify(a);
                                                templateRenderCtsign(a);
                                                $popUpCtsign.popup("close");
                                                notifications();
                                           
                                           }
                                        },
                                        error:function(a,b,c){
                                           ajaxError(a.status,b);;
                                        }
                                    })
                        })


                    }, 200)



                })
            }
           

            
            </script>
        </div><!-- /page -->
