
        <div  data-role="page" id="marches"><!-- marche a terme-->
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

                <div id="note-marches-collapse" data-role="collapsible" data-theme="c" data-inset="false"  data-iconpos="right">
                    <h3 class="header-content">          
                        NOTE DE MARCHES
                    </h3>
                    <div>
                        <div id="note-marches-content">
                        
                            <div id="wrapper-noteTPL"></div>
                        </div>
                    </div>
                </div>
                    <script id="noteTPL" type="text/x-handlebars-template">
                                <span id="txt-maj-info">{{note.maj}}</span>
                                {{#bzeach note.familles.element}}
                                <h2>{{nom}}</h2>
                                    {{#bzeach cultures.element}}
                                        <h3>{{nom}}</h3>
                                        <div class="note-content">
                                                {{titre}}
                                                {{text}}
                                        </div>
                                    {{/bzeach}}
                                {{/bzeach}}

                            </script>
                    <!------------------------->
                    <div id="eurodollar-marches-collapse" data-role="collapsible" data-theme="c" data-inset="false"  data-iconpos="right">
                        <h3 class="header-content">
                            €/$ - PETROLE
                        </h3>
                        <div>
                            <div id="eurodollar-marches-content">
            
                                <div id="wrapper-eurodollarTPL"></div>
                            </div>
                        </div>
                    </div>
                    <script id="eurodollarTPL" type="text/x-handlebars-template">
                         <div class="block-hor-layout">
                        <table>
                        <tbody>
                        
                            <tr>
                                <td>{{eurodollar.nom}}</td>
                                <td>{{eurodollar.valeur}}</td>
                            </tr>
                            <tr>
                                <td>{{petrole.nom}}</td>
                                <td>{{petrole.valeur}}</td>
                            </tr>
                        </tbody>
                        </table>
                        </div>
                    </script>
                    
                    
                    <!------------------------->
                    <div id="cbot-marches-collapse" data-role="collapsible" data-theme="c" data-inset="false"  data-iconpos="right">
                        <h3 class="header-content">
                            COTATION CBOT CHICAGO
                        </h3>
                        <div>
                            <div id="cbot-marches-content">
                                
                                <div id="wrapper-cbotTPL"></div>
                            </div>
                        </div>
                    </div>
                    <script id="cbotTPL" type="text/x-handlebars-template">
                        <div class="block-hor-layout">
                        <table>
                            <thead>
                                <tr>
                                    <th>Echéance</th>
                                    <th>Cloture cts/Bu</th>
                                    <th>Variation</th>
                                </tr>
                            </thead>
                            <tbody>
                            {{#bzeach chicago.echeances}}
                                <tr>
                                    <td>{{echeance}}</td>
                                    <td>{{valeur}}</td>
                                    <td>{{variation}}</td>
                                </tr>
                            {{/bzeach}}
                            </tbody>
                        </table>
                        </div>
                        </script>
                    <!------------------------->
                <script id="MarchesTPL" type="text/x-handlebars-template">
                <div  id="collapsemarches" data-role="collapsible" data-inset="false" data-theme="c" data-collapsed="false"  data-iconpos="right" >
                    <h3 class="header-content">
                        <a class="refresh-matif refresh-matif2" id="refresh-matif-marches"  href="#"></a>
                            {{title}}
                        <span class="line-two" style="display: block"> Ouverts de 10h45 à 18h30</span>
                    </h3>
                    <div>
                        {{#each cultures.element}}
                            <div class="ui-collapsible-heading-toggle marches-subtitle">{{title}}</div>
                             <table data-role="table"  data-mode="columntoggle" class="ui-responsive table-stroke t-marches">
                            <thead>
                                <tr>
                                    <th >Echéance</th>
                                    <th data-priority="2">Qté ach</th>
                                    <th data-priority="2">Achat</th>
                                    <th data-priority="2">Vente</th>
                                    <th data-priority="2">Qté Vte</th>
                                    <th>Dernier traité</th>
                                    <th>Var.</th>
                                    <th data-priority="2">+haut</th>
                                    <th data-priority="2">+bas</th>
                                    <th data-priority="3">Volume traité</th>
                                    <th data-priority="3">Pos Ouv.</th>
                                    <th data-priority="2">Cloture</th>
                                    <th>Ct en cours</th>
                                </tr>
                            </thead>
                            <tbody>
                            {{#each echeances.element}}
                                <tr ech="{{idech}}" libech="{{ech}}">
                                    <td >{{ech}}</td>
                                    <td>{{qteachat}}</td>
                                    <td>{{achat}}</td>
                                    <td>{{vente}}</td>
                                    <td>{{qtevte}}</td>
                                    <td>{{last}}</td>
                            {{#ifmarches var}}
                                    <td class="wrapper-inside-block-up">{{var}}</td>
                            {{else}}
                                    {{#ifmarches2 var}}
                                    <td class="wrapper-inside-block-low">{{var}}</td>
                                    {{else}}
                                    <td class="wrapper-inside-block-equal">{{var}}</td>
                                    {{/ifmarches2}}
                            {{/ifmarches}}
                                    <td>{{haut}}</td>
                                    <td>{{bas}}</td>
                                    <td>{{vol}}</td>
                                    <td>{{posouv}}</td>
                                    <td>{{clot}}</td>
                                    {{#ifunlock isunlock}}
                                    <td isunlock="unlock"  style="text-align: center"><span class="ct-cad-lock acc-marches-cad-unlock"></span></td>
                                    {{else}}
                                    <td isunlock="lock" style="text-align: center"><span class="ct-cad-lock"></span></td>
                                    {{/ifunlock}}
                                </tr>
                                 {{/each}}
                            </tbody>
                        </table>
                           
                        {{/each}}
                    </div>
                </div>
                </script>
                <div id="MarchesTPL2"></div>

            </div>
            <div class="footer" id="footer-marches" data-role="footer" data-position="fixed" data-tap-toggle="false">
              
            </div><!-- /footer -->
            <script>
                $("#footer-marches").html(footer);
                templateRenderFilter(JSON.parse(localStorage.filter))
                $(".bz-menu-html").html(menu);
                bindMenuClick();
                $(".menu-popup").trigger("create");
                $(".bt-matif").addClass("bt-menu-bas-actif");

   var ech = "";
   var libech="";

loadMarches();

 var noteLoaded=false;
 var eurocbotLoaded=false;
 $( "#note-marches-collapse" ).collapsible({
                        expand: function(event, ui) {
                            
                            if(noteLoaded) return;
                            
                            if(!localStorage.note && !onLine){
                                           $(".ui-loader").css("display","none")
                                           alert("Réseau indisponible.")
                                           return;
                            }
                                           
                            if(localStorage.note){
                                           var now=new Date().getTime();
                                           var lastCall_o=JSON.parse(localStorage.note).lastCall;
                                           //console.log("now",now)
                                           //console.log("lastcall",JSON.parse(localStorage.note).lastCall);
                                           
                                           var lastDate=new Date(lastCall_o);
                                           var lastDay=lastDate.getDay();
                                           ////console.log("lastDate",lastDate);
                                           ////console.log("lastday",lastDay);
                                           
                                           var diffToMonday = lastDate.getDate() - lastDay + (lastDay === 0 ? -6 : 1)
                                           
                                           ////console.log("diffMonday",diffToMonday);
                                           
                                           var lastLundi=new Date(lastDate.setDate(diffToMonday)).getTime();
                                           ////console.log("lastLundi",lastLundi)
                                           
                                           ////console.log("now-lastlundi>=1semaine",now-lastLundi>=604800000)
                                           
                                           ////console.log((now-lastLundi)>=604800000)
                                           
                                           if(!((now-lastLundi)>=604800000)){
                                           
                                                templateRenderNote(JSON.parse(localStorage.note));
                                                noteLoaded=true;
                                                return false;
                                           }
                                }
                            
                                   //alert('call ajax')
                            //add loader
                            //$("#note-marches-content").text("chargement en cour ...");
                        
                            $(".ui-loader").css("display","block")
                            $.ajax({
                                url: "/mmarches/note/format/json",
                                dataType: "json",
                                success: function(data) {
                                       if(data.success=="error"){
                                            if(data.type=="timeout"){
                                                timeOut(data.type);
                                                $("#note-marches-collapse").trigger( "collapsibleexpand");
                                                return;
                                            }else{
                                                alert("Une erreur s'est produite, vous allez être redirigé.")
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","index.html");
                                            return;
                                            }
                               
                                        }
                                   $(".ui-loader").css("display","none")
                                   //console.log("data from note",data)
                                   ////console.log("maj",data.note.maj)
                                   
                                   if(localStorage.note){
                                        var majDistant=data.note.maj;
                                        var majLocal=JSON.parse(localStorage.note).note.maj;
                                        var s_majDistant=majDistant.match(/\d{2}[/]\d{2}[/]\d{4}/)[0]
                                        var s_majLocal=majLocal.match(/\d{2}[/]\d{2}[/]\d{4}/)[0]
                                        if(s_majLocal===s_majDistant){
                                           templateRenderNote(data);
                                           noteLoaded=true;
                                            return;
                                       }
                                   }
                                   
                                    data["lastCall"]=new Date().getTime();
                                    localStorage.note =JSON.stringify(data);
                                    templateRenderNote(data);
                                    noteLoaded=true;
                                },
                                error:function(a,b,c){
                                    noteLoaded=false;
                                    ajaxError(a.status,b);;
                                }
                            })
                            
                            
                            
                        }
                });
                
                
                $( "#eurodollar-marches-collapse,#cbot-marches-collapse" ).collapsible({
                       expand: function(event, ui) {
                                            if(eurocbotLoaded) return;
                           
                            //add loader
                            //$("#note-marches-content").text("chargement en cour ...");
                           if(localStorage.eurocbot){
                              var data=JSON.parse(localStorage.eurocbot);
                              var lastCall_o=data.lastCall;
                              var now=new Date().getTime();
                              if(now-lastCall_o<36300000){
                                templateRenderEuroDollarCbot(data);
                                eurocbotLoaded=true;
                                 return;
                              }
                           }
                             
                            $(".ui-loader").css("display","block")
                            $.ajax({
                                url: "/mmarches/eurocbot/format/json",
                                dataType: "json",
                                success: function(data) {
                                       if(data.success=="error"){
                                            if(data.type=="timeout"){
                                                timeOut(data.type);
                                                $("#eurodollar-marches-collapse,#cbot-marches-collapse").trigger( "collapsibleexpand");
                                                return;
                                            }else{
                                                alert("Une erreur s'est produite, vous allez être redirigé.")
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","index.html");
                                            return;
                                            }
                               
                                        }
                                   $(".ui-loader").css("display","none")
                                   //console.log("data from eurocbot",data)
                                    data["lastCall"]=new Date().getTime();
                                    localStorage.eurocbot =JSON.stringify(data);
                                    templateRenderEuroDollarCbot(data);
                                    eurocbotLoaded=true;
                                },
                                error:function(a,b,c){
                                    eurocbotLoaded=false;
                                   ajaxError(a.status,b);;
                                }
                            })
                                                                                       
                       }
                
                })
                
function templateRenderNote(data){

                 /*var template = $('#noteTPL').html();
                 var html = Handlebars.compile(template);
                 var result = html(data);*/
                 try{ var template=Handlebars.templates['notemarches'];
                 var result = template(data);
                 $('#wrapper-noteTPL').html(result); }catch(error){}
                 //$("#note-marches-collapse").collapsible();
                 $(".note-content").each(function(i,e){
                        var a=$(e).text();
                        $(this).empty();
                        //console.log("a",a)
                        $(this).html(a);
                        $('bold').contents().unwrap().wrap('<b/>');

                 })
}
function templateRenderEuroDollarCbot(data){
    
   /* var template = $('#eurodollarTPL').html();
    var html = Handlebars.compile(template);
    var result = html(data);*/
    try{ var template=Handlebars.templates['eurodollar'];
    var result = template(data);
    $('#wrapper-eurodollarTPL').html(result); }catch(error){}
    
     /*template = $('#cbotTPL').html();
     html = Handlebars.compile(template);
     result = html(data);*/
    try{ template=Handlebars.templates['cbot'];
     result = template(data);
    $('#wrapper-cbotTPL').html(result); }catch(error){}
    
 
 
 
}



            $("#marches").on("filterReady",function(){
                               deleteLocalStorageData();
                               loadMarches();
                               $(".ui-loader").css("display","none");
            })

bzLoaderHide();
             </script>
           
        </div><!-- /page -->