<div  data-role="page" id="administration" class="unbindFilterReady"><!-- admin-->
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
                <div id="adm-histo-collaps" data-role="collapsible" data-theme="c" data-inset="false"  data-iconpos="right">
                    <h3 class="header-content">          
                        ADMINISTRATION HISTORIQUE
                    </h3>
                    
                    <div class="block-hor-layout">
                        <script id="adm-histoTPL"  type="text/x-handlebars-template">
                  {{#if historique.structures}}
                            {{#bzeach historique.structures.element}}
                        <div class="ui-collapsible-heading-toggle marches-subtitle padding-bottom-plus">
                            {{titre}}
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th {{$indexparent}}>Culture</th>
                                    <th>Banque</th>
                                    <th>Date règl.</th>
                                    <th>Mtt net €</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id={{$index}}>
                            {{#bzeach reglements.element}}
                                    <tr class="adm-list-histo" id="{{$index}}">
                                    <td>{{culture}}</td>
                                    <td>{{banque}}</td>
                                    <td>{{dateregl}}</td>
                                    <td>{{mttnet}}</td>
                                    <td><div  class="fleches-list-view"></div></td>
                                </tr>
                              {{/bzeach}}
                            </tbody>
                        </table>
                       {{/bzeach}}
                   {{else}}
                    Il n'y a pas de données à afficher.
                   {{/if}}
                    </script>
                    <div id="wrapper-adm-histoTPL"></div>
                    </div>
                </div>
                <div id="adm-encours-collaps" data-role="collapsible" data-inset="false" data-theme="c"   data-iconpos="right" >
                    <h3 class="header-content">
                       ADMINISTRATION EN COURS
                    </h3>
                    <div class="block-hor-layout">
                        <script id="adm-encoursTPL"  type="text/x-handlebars-template">
                        {{#if encours.structures}}
                            {{#bzeach encours.structures.element}}
                        <div class="ui-collapsible-heading-toggle marches-subtitle padding-bottom-plus">
                            {{titre}}
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th >Culture</th>
                                    <th>N° Fac</th>
                                    <th>Date règl.</th>
                                    <th>Mtt Net €</th>
                                </tr>
                            </thead>
                            <tbody>
                                {{#bzeach reglements.element}}
                                <tr>
                                    <td>{{culture}}</td>
                                    <td>{{nfac}}</td>
                                    <td>{{dateregl}}</td>
                                    <td>{{mttnet}}</td>
                                </tr>
                                <tr class="exe-analyses-line">
                                    <td colspan="4" style="text-align:center">{{resume}}</td>
                                </tr>
                                {{/bzeach}}
                            </tbody>
                        </table>
                        {{/bzeach}}
                        {{else}}
                    Il n'y a pas de données à afficher.
                   {{/if}}
                        </script>
                        <div id="wrapper-adm-encoursTPL"></div>
                    </div>
                </div>
                <div id="adm-previ-collaps" data-role="collapsible" data-theme="c" data-inset="false"  data-iconpos="right">
                    <h3 class="header-content">          
                       ADMINISTRATION PREVISIONNEL
                    </h3>
                    <div class="block-hor-layout">
                        <script id="adm-previTPL"  type="text/x-handlebars-template">
                            {{#if previ.structures}}
                            {{#bzeach previ.structures.element}}
                        <div class="ui-collapsible-heading-toggle marches-subtitle padding-bottom-plus">
                            {{titre}}
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th>Culture</th>
                                    <th>Banque</th>
                                    <th>Date règl.</th>
                                    <th>Mtt calculé* €</th>
                                </tr>
                            </thead>
                            <tbody>
                            {{#bzeach reglements.element}}
                                    <tr>
                                    <td>{{culture}}</td>
                                    <td>{{banque}}</td>
                                    <td>{{dateregl}}</td>
                                    <td>{{mttcal}}</td>
                                </tr>
                                <tr>
                                    <td colspan="4" style="text-align:center">{{resume}}<br/><span class="asterix">*Ces prix s'entendent bruts sans prendre en compte d'éventuels réfactions, bonifications, frais ou taxes.</span></td>
                                </tr>
                            {{/bzeach}}
                            </tbody>
                        </table>
                        {{/bzeach}}
                        {{else}}
                    Il n'y a pas de données à afficher.
                   {{/if}}
                    </script>
                    <div id="wrapper-adm-previTPL"></div>
                    </div>
                </div>
               

            </div>

           
            <div class="footer" id="footer-admin" data-role="footer" data-position="fixed" data-tap-toggle="false">

            </div><!-- /footer -->
            
            <script>
                $('#adm-histo-collaps').trigger('expand');
                $("#footer-admin").html(footer);
                templateRenderFilter(JSON.parse(localStorage.filter));
                $(".bz-menu-html").html(menu);
                bindMenuClick();
                $("#menu-popup").trigger("create");
                //init var l'appel est fait uniquement si on quitte la page 
                 var dataAdmHisto="";
                 var dataAdmEncours="";
                 var dataAdmPrevi="";
                 var indexDetailHisto="";
                 
                 function loadAdmHisto(){
                     if(!onLine){
                        
                         return;
                     }
                           var filter=getFilter(JSON.parse(localStorage.filter));
                           $(".ui-loader").css("display","block")
                           $.ajax({
                                    url: "/madministration/historique/format/json",
                                    data: {"filter":filter},
                                    type: "POST",
                                    dataType: "json",
                                    success: function(data) {
                                        //console.log("data from adm histo",data)
                                        if(data.success=="error"){
                                 
                                                if(data.type=="timeout"){
                                  
                                                        timeOut(data.type);
                                                        $("#adm-histo-collaps").trigger( "collapsibleexpand");
                                                        return;
                                                }else{
                                                        alert("Une erreur s'est produite, vous allez être redirigé.")
                                                        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index/");
                                                        return;
                                                }
                                  
                                        }
                                
                                       data["lastCall"]=new Date().getTime();
                                       dataAdmHisto=data;
                                       localStorage.admhisto =JSON.stringify(dataAdmHisto);
                                        templateRenderAdmHisto(data);
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
                 function loadAdmEncours(){
                        var filter=getFilter(JSON.parse(localStorage.filter));
                        $(".ui-loader").css("display","block")
                        $.ajax({
                                    url: "/madministration/encours/format/json",
                                    data: {filter:filter},
                                    type: "POST",
                                    dataType: "json",
                                    success: function(data) {
                                       
                                       //console.log("data from adm encours",data)
                                       if(data.success=="error"){
                                           if(data.type=="timeout"){
                                           
                                                    timeOut(data.type);
                                                    $("#adm-encours-collaps").trigger( "collapsibleexpand");
                                                    return;
                                           }else{
                                                    alert("Une erreur s'est produite, vous allez être redirigé.")
                                                    $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index/");
                                                    return;
                                           }

                                        }
                                       data["lastCall"]=new Date().getTime();
                                       dataAdmEncours=data;
                               
                                       localStorage.admencours =JSON.stringify(dataAdmEncours);
                                       templateRenderAdmEncours(data)   
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
                 function loadAdmPrevi(){
                        $(".ui-loader").css("display","block")
                        var filter=getFilter(JSON.parse(localStorage.filter));
                        $.ajax({
                                    url: "/madministration/previsionnel/format/json",
                                    data: {filter:filter},
                                    type: "POST",
                                    dataType: "json",
                                    success: function(data) {
                                       //console.log("data from adm previ",data);
                                        if(data.success=="error"){
                                            if(data.type=="timeout"){
                                                timeOut(data.type);
                                                $("#adm-previ-collaps").trigger( "collapsibleexpand");
                                                return;
                                            }else{
                                                alert("Une erreur s'est produite, vous allez être redirigé.")
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index/");
                                            return;
                                            }
                               
                                        }
                                       data["lastCall"]=new Date().getTime();
                                       dataAdmPrevi=data;
                                       localStorage.admprevi =JSON.stringify(dataAdmPrevi);
                                       templateRenderAdmPrevi(data);
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
        
                 function templateRenderAdmHisto(data){
                                        /*var template = $('#adm-histoTPL').html();
                                        var html = Handlebars.compile(template);
                                        var result = html(data);*/
                                        try{ var template=Handlebars.templates['adminHisto'];
                                        var result = template(data);
                                        $('#wrapper-adm-histoTPL').html(result); }catch(error){}
                                        $(".adm-list-histo").click(function(e){
                                             indexDetailHisto=$(e.currentTarget).parent().attr("id")+"-"+$(e.currentTarget).attr("id");
                                             $( ":mobile-pagecontainer" ).pagecontainer( "change","/madministration/historiquedetail/format/html");
                                             
                                        })
                                       
        }
        
                 function  templateRenderAdmEncours(data){
                        /*var template = $('#adm-encoursTPL').html();
                        var html = Handlebars.compile(template);
                        var result = html(data);*/
                        try{ var template=Handlebars.templates['adminEncours'];
                        var result = template(data);
                        $('#wrapper-adm-encoursTPL').html(result); }catch(error){}
        }
        
                function  templateRenderAdmPrevi(data){
                     /*var template = $('#adm-previTPL').html();
                     var html = Handlebars.compile(template);
                     var result = html(data);*/
                     try{ var template=Handlebars.templates['adminPrevi'];
                     var result = template(data);
                     $('#wrapper-adm-previTPL').html(result); }catch(error){}
                }
                 
                 
                 
                 $("#adm-histo-collaps").on( "collapsibleexpand", function( event, ui ) {
                        //pas de chargement a chaque extend
                        if(dataAdmHisto) return;
                        
                        $(".ui-loader").css("display","block")
                          
                         if(localStorage.admhisto){
                                //console.log("local storage admhisto")
                                var data=JSON.parse(localStorage.admhisto);
                                //console.log("objecct adm histo local",data)
                                var lastCall=data.lastCall;
                                if((new Date().getTime()-lastCall>maxLife) && onLine){
                                    //console.log("delais depassé");
                                     loadAdmHisto();
                    
                                }else{
                                    //console.log("dans le delais ou offLine")
                                    templateRenderAdmHisto(data)
                                    dataAdmHisto=data;
                                    $(".ui-loader").css("display","none")
                                }
                        }else{
                                //on charge les donnée
                                //console.log("adm histo n'exite pas")                          
                                loadAdmHisto(); 
                        }
                         
                         
                 } );
                 $("#adm-encours-collaps").on( "collapsibleexpand", function( event, ui ) {
                        //call data for encour
                        if(dataAdmEncours) return;
                                              $(".ui-loader").css("display","block")
                         if(localStorage.admencours ){
                                //console.log("local storage admencours exist")
                                var data=JSON.parse(localStorage.admencours);
                                var lastCall=data.lastCall;
                                if((new Date().getTime()-lastCall>maxLife) && onLine){
                                    //console.log("delais depassé");
                                     loadAdmEncours();
                                }else{
                                    //console.log("dans le delais ou offLine")
                                              templateRenderAdmEncours(data);
                                              $(".ui-loader").css("display","none")
                                }
                        }else{
                                //on charge les donnée
                                //console.log("adm encours n'exite pas")
                                loadAdmEncours();
                        }
                     
                 } );
                 $("#adm-previ-collaps").on( "collapsibleexpand", function( event, ui ) {
                        //call data for previ
                        
                        if(dataAdmPrevi) return;
                                            $(".ui-loader").css("display","block")
                            if(localStorage.admprevi){
                                //console.log("local storage admenprevi exist")
                                var data=JSON.parse(localStorage.admprevi);
                                var lastCall=data.lastCall;
                                if((new Date().getTime()-lastCall>maxLife) && onLine){
                                    //console.log("delais depassé");
                                     loadAdmPrevi();
                                }else{
                                    //console.log("dans le delais ou offLine")
                                            templateRenderAdmPrevi(data);
                                            $(".ui-loader").css("display","none")
                                }
                        }else{
                                //on charge les donnée
                                //console.log("adm previ n'exite pas")
                                loadAdmPrevi();
                        }
                       
                 } );
                 
                 
                 //garde open after retour from detail
                 //on utilise activepage car prevpage pas encore fired
                 if(activePage=="administration-detail"){
                     setTimeout(function(){
                                try{
                                $("#adm-histo-collaps").collapsible("expand");
                                }catch(error){
                                
                                }
                                
                                },500)
                     
                 }
            
                $("#administration").off("filterReady").on("filterReady",function(){

                         dataAdmHisto="";
                         dataAdmEncours="";
                         dataAdmPrevi="";
                         indexDetailHisto="";
                         $(".ui-collapsible").collapsible('collapse');
                         deleteLocalStorageData();
                         setCampHeader();
                         $(".ui-loader").css("display","none");

                 })
                 
         
                 $(".ui-loader").css("display","none");
    
               
             </script>
        </div><!-- /page -->
        