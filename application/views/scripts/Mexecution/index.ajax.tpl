
<div  data-role="page" id="execution" class="unbindFilterReady"><!-- execution-->
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
                <div id="exec-histo-collaps" data-role="collapsible" data-theme="c" data-inset="false"  data-iconpos="right">
                    <h3 class="header-content">          
                        EXECUTION HISTORIQUE
                    </h3>
                    <script id="exec-histoTPL"  type="text/x-handlebars-template">
                             <div class="block-hor-layout">
                        {{#if executions.structures}}
                        {{#bzeach executions.structures.element}}
                        <div class="ui-collapsible-heading-toggle marches-subtitle">
                            {{titre}}
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th >Culture</th>
                                    <th>N°ct/dépot</th>
                                    <th>Qté liv t</th>
                                    <th>Qté/Surf Ct</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                            {{#bzeach contrats.element}}
                                    <tr class="list-histo" idct="{{idct}}">
                                    <td>{{culture}}</td>
                                    <td>{{nctdep}}</td>
                                    <td>{{qteliv}}</td>
                                    <td>{{qtesurfct}}</td>
                                    <td><div class="fleches-list-view"></div></td>
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
                    
                    <div id="wrapper-exec-histoTPL"></div>
                   
                </div>
                <div id="exec-encours-collaps" data-role="collapsible" data-inset="false" data-theme="c"   data-iconpos="right" >
                    <h3 class="header-content">
                        EXECUTION EN COURS
                    </h3>
                    <script id="exec-encoursTPL"  type="text/x-handlebars-template">
                    <div class="block-hor-layout">
                    {{#if encours.structures}}
                    {{#bzeach encours.structures.element}}
                        <div class="ui-collapsible-heading-toggle marches-subtitle">
                            {{titre}}
                            <span class="line-two" style="display: block">{{add}}</span>
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th >Culture</th>
                                    <th>Date</th>
                                    <th>N°voy/n°bon</th>
                                    <th>Brut t</th>
                                </tr>
                            </thead>
                            <tbody>
                            {{#bzeach contrats.element}}
                                <tr>
                                    <td>{{culture}}</td>
                                    <td>{{date}}</td>
                                    <td>{{nvoybznbon}}</td>
                                    <td>{{brut}}</td>
                                </tr>
                                <tr class="exe-analyses-line">
                                    <td colspan="4">{{qualite}}</td>
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
                    <div id="wrapper-exec-encoursTPL"></div>
                </div>
                <div id="exec-previ-collaps" data-role="collapsible" data-theme="c" data-inset="false"  data-iconpos="right">
                    <h3 class="header-content">          
                        EXECUTION PREVISIONNEL
                    </h3>
                    <script id="exec-previTPL"  type="text/x-handlebars-template">
                    <div class="block-hor-layout">
                    {{#if previ.structures}}
                        {{#bzeach previ.structures.element}}
                        <div class="ui-collapsible-heading-toggle marches-subtitle">
                            {{titre}}
                            <span class="line-two" style="display: block">{{add}}</span>
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th>Culture</th>
                                    <th>Période</th>
                                    <th>N°ct</th>
                                    <th>Qté Ct</th>
                                </tr>
                            </thead>
                            <tbody>
                              {{#bzeach contrats.element}}
                                    <tr>
                                        <td>{{culture}}</td>
                                        <td>{{periode}}</td>
                                        <td>{{nct}}</td>
                                        <td>{{qtelivct}}</td>
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
                    <div id="wrapper-exec-previTPL"></div>
                </div>

            </div>

           
            <div class="footer" id="footer-exec" data-role="footer" data-position="fixed" data-tap-toggle="false">
       
            </div><!-- /footer -->
    <script>
                $("#footer-exec").html(footer);
                templateRenderFilter(JSON.parse(localStorage.filter))
                $(".bz-menu-html").html(menu);
                bindMenuClick();
                $("#menu-popup").trigger("create");
                //init var l'appel est fait uniquement si on quitte la page 
                 var dataExeHisto="";
                 var dataExeEncours="";
                 var dataExePrevi="";
                 var idct="";
                 
                 function loadExeHisto(){
                     $(".ui-loader").css("display","block")
                    var filter=getFilter(JSON.parse(localStorage.filter));
                     $.ajax({
                                    url: "/mexecution/historique/format/json",
                                    data: {filter:filter},
                                    type: "POST",
                                    dataType: "json",
                                    success: function(data) {
                            $(".ui-loader").css("display","none")
                                       //console.log("data from exec histo",data)
                                          if(data.success=="error"){
                                            if(data.type=="timeout"){
                                                timeOut(data.type);
                                                $("#exec-histo-collaps").trigger( "collapsibleexpand");
                                                return;
                                            }else{
                                                alert("Une erreur s'est produite, vous allez être redirigé.")
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index");
                                            return;
                                            }
                               
                                        }
                                       data["lastCall"]=new Date().getTime();
                                       dataExeHisto=data;
                                       localStorage.exehisto =JSON.stringify(dataExeHisto);
                                       templateRenderExeHisto(data);    
                                    },
                                    error: function(a, b, c) {

                                        console.log(a);
                                        console.log(b);
                                        console.log(c);
                                        ajaxError(a.status,b);;
                                    }
            })   
                 }
                 function loadExeEncours(){
                     $(".ui-loader").css("display","block")
                       var filter=getFilter(JSON.parse(localStorage.filter));
                            $.ajax({
                                    url: "/mexecution/encours/format/json",
                                    data: {filter:filter},
                                    type: "POST",
                                    dataType: "json",
                                    success: function(data) {
                                   $(".ui-loader").css("display","none")
                                       //console.log("data from exec encours",data);
                                          if(data.success=="error"){
                                            if(data.type=="timeout"){
                                                timeOut(data.type);
                                                $("#exec-encours-collaps").trigger( "collapsibleexpand");
                                                return;
                                            }else{
                                                alert("Une erreur s'est produite, vous allez être redirigé.")
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index");
                                            return;
                                            }
                               
                                        }
                                       data["lastCall"]=new Date().getTime();
                                       dataExeEncours=data;
                                       localStorage.exeencours =JSON.stringify(dataExeEncours);
                                       templateRenderExeEncours(data);

                                    },
                                    error: function(a, b, c) {

                                        console.log(a);
                                        console.log(b);
                                        console.log(c);
                                        ajaxError(a.status,b);;

                                    }
                            }) 
                 }
                 function loadExePrevi(){
                     $(".ui-loader").css("display","block")
                               var filter=getFilter(JSON.parse(localStorage.filter));
                            $.ajax({
                                    url: "/mexecution/previsionnel/format/json",
                                    data: {filter:filter},
                                    type: "POST",
                                    dataType: "json",
                                    success: function(data) {
                                   $(".ui-loader").css("display","none")
                                       //console.log("data from exec previ",data);
                                          if(data.success=="error"){
                                            if(data.type=="timeout"){
                                                timeOut(data.type);
                                                $("#exec-previ-collaps").trigger( "collapsibleexpand");
                                                return;
                                            }else{
                                                alert("Une erreur s'est produite, vous allez être redirigé.")
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index");
                                            return;
                                            }
                               
                                        }
                                       data["lastCall"]=new Date().getTime();
                                       dataExePrevi=data;
                                       localStorage.exeprevi =JSON.stringify(dataExePrevi);
                                       templateRenderExePrevi(data)
                                    },
                                    error: function(a, b, c) {

                                        console.log(a);
                                        console.log(b);
                                        console.log(c);
                                        ajaxError(a.status,b);;

                                    }
                        })
                 }
                 
                  function templateRenderExeHisto(data){
                                        /*var template = $('#exec-histoTPL').html();
                                        var html = Handlebars.compile(template);
                                        var result = html(data);*/
                                        try{ var template=Handlebars.templates['exeHisto'];
                                        var result = template(data);
                                        $('#wrapper-exec-histoTPL').html(result); }catch(error){}
                                        
                                        $(".list-histo").click(function(evt){
                                            idct=$(evt.currentTarget).attr("idct");
                                            $( ":mobile-pagecontainer" ).pagecontainer( "change","/mexecution/historiquedetail/format/html/idct/"+idct);
                                           
                                        })
                  }   
                  function templateRenderExeEncours(data){
                       /*var template = $('#exec-encoursTPL').html();
                       var html = Handlebars.compile(template);
                       var result = html(data);*/
                       try{ var template=Handlebars.templates['exeEncours'];
                       var result = template(data);
                       $('#wrapper-exec-encoursTPL').html(result); }catch(error){}  
                  }
                  function templateRenderExePrevi(data){
                            /*var template = $('#exec-previTPL').html();
                            var html = Handlebars.compile(template);
                            var result = html(data);*/
                            try{ var template=Handlebars.templates['exePrevi'];
                            var result = template(data);
                            $('#wrapper-exec-previTPL').html(result); }catch(error){}             
                  }
                 
                 $("#exec-histo-collaps").on( "collapsibleexpand", function( event, ui ) {
                        //call data for historique
                        if(dataExeHisto) return;
                                             $(".ui-loader").css("display","block")
                         if(localStorage.exehisto ){

                                //console.log("local storage exehisto")
                                var data=JSON.parse(localStorage.exehisto);
                                var lastCall=data.lastCall;
                                if((new Date().getTime()-lastCall>maxLife) && onLine){
                                    //console.log("delais depassé");
                                     loadExeHisto();
                                }else{
                                    //console.log("dans le delais ou offLine")
                                             templateRenderExeHisto(data);
                                             $(".ui-loader").css("display","none")
                                }
                        }else{
                                //on charge les donnée
                                //console.log("exe histo n'exite pas")                          
                                loadExeHisto(); 
                        }
                          
                 } );
                 $("#exec-encours-collaps").on( "collapsibleexpand", function( event, ui ) {
                        //call data for encour
                        if(dataExeEncours) return;
                                               $(".ui-loader").css("display","block")
                         if(localStorage.exeencours ){
                                //console.log("local storage exeencours")
                                var data=JSON.parse(localStorage.exeencours);
                                var lastCall=data.lastCall;
                                if((new Date().getTime()-lastCall>maxLife) && onLine){
                                    //console.log("delais depassé");
                                     loadExeEncours();
                                }else{
                                    //console.log("dans le delais ou offLine")
                                               templateRenderExeEncours(data);
                                               $(".ui-loader").css("display","none")
                                }
                        }else{
                                //on charge les donnée
                                //console.log("exe encours n'exite pas")                          
                                loadExeEncours(); 
                        }
                           
                 } );
                 $("#exec-previ-collaps").on( "collapsibleexpand", function( event, ui ) {
                        //call data for historique
                        if(dataExePrevi) return;
                                             $(".ui-loader").css("display","block")
                        if(localStorage.exeprevi ){
                                //console.log("local storage exeprevi")
                                var data=JSON.parse(localStorage.exeprevi);
                                var lastCall=data.lastCall;
                                if((new Date().getTime()-lastCall>maxLife) && onLine){
                                    //console.log("delais depassé");
                                     loadExePrevi();
                                }else{
                                    //console.log("dans le delais ou offLine")
                                             templateRenderExePrevi(data);
                                             $(".ui-loader").css("display","none")
                                }
                        }else{
                                //on charge les donnée
                                //console.log("exe previ n'exite pas")                          
                                loadExePrevi(); 
                        }
                 } );
                 
                  $("#execution").on("filterReady",function(){
                         dataExeHisto="";
                         dataExeEncours="";
                         dataExePrevi="";
                          $(".ui-collapsible").collapsible('collapse');
                         deleteLocalStorageData();
                         $(".ui-loader").css("display","none");
                 })
                 
                 //garde open after retour from detail
                 //on utilise activepage car prevpage pas encore fired
                 if(activePage=="execution-detail"){
                     setTimeout(function(){
                                try{
                                    $("#exec-histo-collaps").collapsible("expand");
                                }catch(error){
                                
                                }
                                
                                },500)
                                
                 }
                $(".ui-loader").css("display","none");
                 
            </script>
        </div><!-- /page -->