
<div  data-role="page" id="prospection" class="unbindFilterReady"><!-- execution-->
    <div data-role="panel" id="bz-filter" data-display="overlay">
         <div  class="wrapper-filterTPL"></div>
            <script id="filterTPL" type="text/x-handlebars-template">
                        <div  class="D-filter" >
                   
                                <div id="T_camp" class="T_F"><span>CAMPAGNES</span></div>
                                <div id="F_camp">
                                {{#each filtre.campagnes.element}}
                                    <input class="filterInput" type="radio" name="camp" {{#bzIf checked "1"}}checked="checked"{{/bzIf}} id="ca{{@index}}" idcamp="{{idcamp}}"/>
                                    <label  for="ca{{@index}}">{{camp}}</label>
                                {{/each}}  
                                </div>
                                <div id="T_cult" class="T_F"><span>CULTURES</span></div>
                                <div id="F_cult">
                                {{#each filtre.cultures.element}}
                                    <label  for="c{{@index}}">{{nom}}</label>
                                    <input class="filterInput" idcu="{{idcu}}" {{#bzIf checked "1"}}checked="checked"{{/bzIf}} type="checkbox" name='cultures' id='c{{@index}}'/>
                                 {{/each}}
                                </div>
                                <div id="T_st" class="T_F"><span>STRUCTURES</span></div>
                                <div id="F_struct">
                                    {{#each filtre.structures.element}}
                                    <label  for="s{{@index}}">{{nom}}</label>
                                    <input class="filterInput" type="checkbox" idti="{{idti}}" {{#bzIf checked "1"}}checked="checked"{{/bzIf}} name='structures' id='s{{@index}}' /> 
                                    {{/each}}
                                </div>
                                
                    </div>
            </script>
    </div>
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
                <div class="header-item header-right"><a href="#bz-menu" ><img src="/mobiles/css/img/pictos/menu.min.svg" width="30"/></a></div>
               <div class="bt-aide" ></div>                 <div class="offline" style="display:none;">Vous êtes hors réseaux, les données affichées ne sont pas à jour, vous n'avez pas accés à la commercialisation.</div>
            </div><!-- /header -->
            <div class="clear"></div>

            <div data-role="content" >
                 <div class="header-content header-content-camp"> </div>
                <div id="pros-ferme-collaps" data-role="collapsible" data-theme="c" data-inset="false"  data-iconpos="right">
                    <h3 class="header-content">          
                        STOCK FERME
                    </h3>
                    <script id="pros-fermeTPL"  type="text/x-handlebars-template">
                    <div class="block-hor-layout">
                    {{#if ferme.structures}}
                    {{#bzeach ferme.structures.element}}
                        <h2>
                            {{titre}}
                        </h2>
                        <table>
                            <thead>
                                <tr>
                                    <th>Culture</th>
                                    <th>Solde</th>
                                    <th>Poids</th>
                                    <th>Surface</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id={{$index}}>
                            {{#bzeach lots.element}}
                                <tr class="pro-list-ferme" id="{{$index}}">
                                    <td>{{culture}}</td>
                                    <td>{{solde}}</td>
                                    <td>{{poids}}</td>
                                    <td>{{surface}}</td>
                                    <td><div  class="fleches-list-view"></div></td>
                                </tr>
                             {{/bzeach}}                        
                            </tbody>
                        </table>
                        {{/bzeach}}
                         {{else}}
                    Il n'y a pas de données à afficher.
                   {{/if}}
                    </div>
                    </script>
                    
                    <div id="wrapper-pros-fermeTPL"></div>
                   
                </div>
                <div id="pros-depots-collaps" data-role="collapsible" data-inset="false" data-theme="c"   data-iconpos="right" >
                    <h3 class="header-content">
                        DEPOTS
                    </h3>
                    <script id="pros-depotsTPL"  type="text/x-handlebars-template">
                    <div class="block-hor-layout">
                    {{#if depots.structures}}
                    {{#bzeach depots.structures.element}}
                        <h2 class="ui-collapsible-heading-toggle marches-subtitle">
                            {{titre}}
                        </h2>
                        <table>
                            <thead>
                                <tr>
                                    <th >Culture</th>
                                    <th>Brut</th>
                                    <th>Net</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id={{$index}}>
                            {{#bzeach depot.element}}
                            <tr class="pro-list-depot" id="{{$index}}">
                                <td>{{culture}}</td>
                                <td>{{brut}}</td>
                                <td>{{net}}</td>
                                <td><div  class="fleches-list-view"></div></td>
                            </tr>
                            {{/bzeach}}
                            </tbody>
                        </table>
                        {{/bzeach}}
                         {{else}}
                    Il n'y a pas de données à afficher.
                   {{/if}}
                    </div>
                    </script>
                    <div id="wrapper-pros-depotsTPL"></div>
                </div>
              
            </div>

           
            <div class="footer" id="footer-pros" data-role="footer" data-position="fixed" data-tap-toggle="false">
       
            </div><!-- /footer -->
    <script>
                 $("#footer-pros").html(footer);
                templateRenderFilter(JSON.parse(localStorage.filter))
                $(".bz-menu-html").html(menu);
                bindMenuClick();
                $("#menu-popup").trigger("create");
                //init var l'appel est fait uniquement si on quitte la page 
                 var dataProsFerme="";
                 var dataProsDepot="";
                 var indexDetailPro="";
                 var indexDetailFerme="";
                 
                 function loadFerme(){
                     if(!onLine){
                         $(".ui-loader").css("display","none");
                         alert("Réseau indisponible");
                         return;
                     }
              
                     $(".ui-loader").css("display","block")
                    var filter=getFilter(JSON.parse(localStorage.filter));
                     $.ajax({
                                    url: "https://www.e-bzgrains.com/mprospection/ferme/format/json",
                                    data: {filter:filter},
                                    type: "POST",
                                    dataType: "json",
                                    success: function(data) {
                            $(".ui-loader").css("display","none")
                                       //console.log("data from pros ferme",data)
                                          if(data.success=="error"){
                                            if(data.type=="timeout"){
                                                timeOut(data.type);
                                                $("#pros-ferme-collaps").trigger( "collapsibleexpand");
                                                return;
                                            }else{
                                                alert("Une erreur s'est produite, vous allez être redirigé.")
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","index.html");
                                            return;
                                            }
                               
                                        }
                                       data["lastCall"]=new Date().getTime();
                                       dataProsFerme=data;
                                       localStorage.prosferme =JSON.stringify(dataProsFerme);
                                       templateRenderProsFerme(data);
                                    },

                                    error: function(a,b,c) {
                                        console.log(a);
                                        console.log(b);
                                        console.log(c);
                                        ajaxError(a.status,b);;

                                    }
            })   
                 }
                 function loadDepots(){
                     if(!onLine){
                         $(".ui-loader").css("display","none");
                         alert("Réseau indisponible");
                         return;
                     }
                     
                     $(".ui-loader").css("display","block");
                       var filter=getFilter(JSON.parse(localStorage.filter));
                            $.ajax({
                                    url: "https://www.e-bzgrains.com/mprospection/depots/format/json",
                                    data: {filter:filter},
                                    type: "POST",
                                    dataType: "json",
                                    success: function(data) {
                                   $(".ui-loader").css("display","none")
                                       //console.log("data from pros depot",data);
                                          if(data.success=="error"){
                                            if(data.type=="timeout"){
                                                timeOut(data.type);
                                                $("#pros-depot-collaps").trigger( "collapsibleexpand");
                                                return;
                                            }else{
                                                alert("Une erreur s'est produite, vous allez être redirigé.")
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","index.html");
                                            return;
                                            }
                               
                                        }
                                       data["lastCall"]=new Date().getTime();
                                       dataProsDepot=data;
                                       localStorage.prodepot =JSON.stringify(dataProsDepot);
                                       templateRenderProsDepots(data);

                                    },
                                    error: function(a, b, c) {

                                        console.log(a);
                                        console.log(b);
                                        console.log(c);
                                        ajaxError(a.status,b);;

                                    }
                            }) 
                 }
    
                 
                  function templateRenderProsFerme(data){
                                        /*var template = $('#pros-fermeTPL').html();
                                        var html = Handlebars.compile(template);
                                        var result = html(data);*/
                                        try{ var template=Handlebars.templates['prosferme'];
                                        var result = template(data);
                                        $('#wrapper-pros-fermeTPL').html(result); }catch(error){}
                                        $(".pro-list-ferme").click(function(e){
                                                indexDetailFerme=$(e.currentTarget).parent().attr("id")+"-"+$(e.currentTarget).attr("id");
                                                //console.log("indexDetailFerme",indexDetailFerme)
                                                                 
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","pros-fermedetail.html");
                                                                   
                                                                   })
                                        
                                        
                  }   
                  function templateRenderProsDepots(data){
                       /*var template = $('#pros-depotsTPL').html();
                       var html = Handlebars.compile(template);
                       var result = html(data);*/
                       try{
                           var template=Handlebars.templates['prosdepot'];
                       var result = template(data);
                       $('#wrapper-pros-depotsTPL').html(result); }catch(error){}
                       $(".pro-list-depot").click(function(e){
                            indexDetailPro=$(e.currentTarget).parent().attr("id")+"-"+$(e.currentTarget).attr("id");
                            //console.log("indexDetailPro",indexDetailPro)
                            $( ":mobile-pagecontainer" ).pagecontainer( "change","pros-depotdetail.html");
                                                  
                        })
                      
                  }
    
    
                 $("#pros-ferme-collaps").on( "collapsibleexpand", function( event, ui ) {
                          
                                             
                                             
                        //call data for historique
                        if(dataProsFerme) return;
                                             $(".ui-loader").css("display","block")
                         if(localStorage.prosferme){

                                //console.log("local storage pros ferme")
                                var data=JSON.parse(localStorage.prosferme);
                                var lastCall=data.lastCall;
                                if((new Date().getTime()-lastCall>maxLife) && onLine){
                                    //console.log("delais depassé");
                                     loadFerme();
                                }else{
                                    //console.log("dans le delais ou offLine")
                                             templateRenderProsFerme(data);
                                             dataProsFerme=data;
                                             $(".ui-loader").css("display","none")
                                }
                        }else{
                                //on charge les donnée
                                //console.log("pros ferme  n'exite pas")
                                loadFerme();
                        }
                          
                 } );
                 $("#pros-depots-collaps").on( "collapsibleexpand", function( event, ui ) {

                        //call data for encour
                        if(dataProsDepot) return;
                        $(".ui-loader").css("display","block")
                         if(localStorage.prodepot ){
                                //console.log("local storage exeencours")
                                var data=JSON.parse(localStorage.prodepot);
                                var lastCall=data.lastCall;
                                if((new Date().getTime()-lastCall>maxLife) && onLine){
                                    //console.log("delais depassé");
                                     loadDepots();
                                     
                                }else{
                                    //console.log("dans le delais ou offLine")
                                               templateRenderProsDepots(data);
                                              dataProsDepot=data;
                                               $(".ui-loader").css("display","none")
                                }
                        }else{
                                //on charge les donnée
                                //console.log("pro depot n'exite pas")
                                loadDepots();
                        }
                           
                 } );
            
                 
                  $("#prospection").on("filterReady",function(){
                         dataProsDepot="";
                         dataProsFerme="";
                          $(".ui-collapsible").collapsible('collapse');
                         deleteLocalStorageData();
                         $(".ui-loader").css("display","none");
                 })
                 
                 //garde open after retour from detail
                 //on utilise activepage car prevpage pas encore fired
                 if(activePage=="depot-detail"){
                     setTimeout(function(){
                                try{
                                $("#pros-depots-collaps").collapsible("expand");
                                }catch(error){
                                
                                }
                                
                                },500)
                                
                 }
                $(".ui-loader").css("display","none");
    
            </script>
        </div><!-- /page -->