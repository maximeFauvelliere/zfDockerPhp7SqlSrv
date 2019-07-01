
        <div data-role="page" id="acc">
       
            <div data-role="panel" id="bz-filter" data-display="overlay">
               
                <div class="wrapper-filterTPL" ></div>
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

            </div><!-- /panel -->
            <div data-role="popup" id="menu-popup"  class='ui-content-menu-popup menu-popup' data-theme="b">
                Vous n'avez pas accès à cette rubrique.
            </div>
            <div data-role="header" data-position="fixed" data-tap-toggle="false">
                <div data-role="panel" id="bz-menu" class="bzmenu" data-display="overlay" data-position="right" data-theme="b" data-close="" > 
                    <script id="menuTPL" type="text/x-handlebars-template">
                    <div class="bz-menu">
                        <div class="bz-menu-header">
                            <!--<img class="close-menu" src="/mobiles/css/img/pictos/menu.min.svg"/>-->
                            <img  src="/mobiles/css/img/pictos/ebz.min2.svg"/>
                        </div>
                        
            {{#bzeach menu.element}}
                {{#bzIf rubrique  "transaction"}}
                    <a href="/mtransaction/index/format/html" class="enable  {{#bzIf checked  "0"}}disable{{/bzIf}}" ><div class="menu-list " >Transaction</div></a>
                {{/bzIf}}
                {{#bzIf rubrique "execution"}}
                    <a href="/mexecution/index/format/html" class="enable  {{#bzIf checked  "0"}}disable{{/bzIf}}"><div class="menu-list " >Exécution</div></a>
                {{/bzIf}}
                {{#bzIf rubrique "prospection"}}
                <a href="/mprospection/index/format/html" class="enable  {{#bzIf checked  "0"}}disable{{/bzIf}}"><div class="menu-list " >Prospection</div></a>
                {{/bzIf}}
                {{#bzIf rubrique "administration"}}
                    <a href="/madministration/index/format/html" class="enable {{#bzIf checked  "0"}}disable{{/bzIf}}"><div class="menu-list">Administration</div></a>
                {{/bzIf}}
                {{#bzIf rubrique "contratsasigner"}}
                    <a href="/madministration/contratsasigner/format/html" class="enable {{#bzIf checked  "0"}}disable{{/bzIf}}"><div class="menu-list ">Contrats à signer <span class="notif-menu notif-menu-ctsign"><span></span></span></div></a>
                {{/bzIf}}
                {{#bzIf rubrique "contratencours"}}
                    <a href="/mtransaction/contratsencours/format/html" class="enable"><div class="menu-list">Contrat(s) indexe(s) <span class="notif-menu notif-menu-ctencours"><span></span></span></div></a>
                {{/bzIf}}
                
            {{/bzeach}}

<a href="#" data-ajax="false" class="btout"  class="enable"><div class="menu-list">Déconnexion<br/><span class="dbzuser">{{bzuser}}</span></div></a>
    
                        
                    </div>
                </script>
                <div id="wrapper-menuTPL"></div>
                </div><!-- fin panel menu-->
                <div class="header-item header-left"><a href="#" data-rel="back"><img src="/mobiles/css/img/pictos/back.min.svg" width="30"/></a></div>
                <div class="header-item header-center"><a class="bt-acc"  href="/maccueil/index/format/html"><img src="/mobiles/css/img/pictos/ebz.min2.svg" width="80"/></a></div>
                <div class="header-item header-right"><a href="#bz-menu" ><img src="/mobiles/css/img/pictos/menu.min.svg" width="30"/></a></div>
                <div class="bt-aide" ></div>
                <div class="offline" style="display:none;">Vous êtes hors réseaux, les données affichées ne sont pas à jour, vous n'avez pas accés à la commercialisation.</div>
            </div><!-- /header -->
            <div class="clear"></div>

            <div data-role="content">
                
                <script  id="accTPL" type="text/x-handlebars-template">
                <div class="header-content header-content-camp">
                    CAMP {{acc.camp}}
                    
                </div>
                <!-- block marches-->
                <div class="blocks block-marches">

                    <div class="header-block header-block-two-lines" id="header-block-marche">
                        <div class="refresh-matif " id="refresh-matif-acc"></div>
                        <span>MARCHES A TERME</span><br>
                        <span class="line-two">{{acc.subtitle}}</span>
                    </div>
                   
                    <div class="content-block" >
                        <div class="ui-grid-b ui-grid-b-marches">
                        {{#if acc.marches}}
                             {{#foreachmarches acc.marches.element}}
                                <div class="ui-block-{{$block }}">
                                    <div class="inside-block-wrapper wrapper-inside-block-{{$var}}">
                                        <div class="inside-block inside-block-first"><div class="acc-indice-marches acc-indice-marches-{{$var}}"></div></div>
                                        <div class="inside-block acc-cult-marches"><span>{{cult}}</span></div>
                                        <div class="inside-block inside-block-last"><div class="acc-marches-cad {{#bzIf isunlock "0"}} ct-cad-lock {{else}}  acc-marches-cad-unlock ct-cad-lock{{/bzIf}}"></div></div>
                                    </div>
                                    <span class="taux">{{cours}}</span>
                                    <span class="taux ech">{{ech}}</span>
                                </div>
                            {{/foreachmarches}}
                         {{else}}
                            Il n'y a pas de données à afficher.
                         {{/if}}
                        </div>
                    </div>
                    <div class="block-vertical-spacer"></div>


                </div>

                <!-- ------------------------------------------------------------------->
                <!-- block offres --->
                <div class="blocks block-offres">
                    <div class="header-block" id="header-block-offres">
                        <span>OFFRES BZ</span>
                    </div>
                    
                    <div class="content-block" >
                        <div class="ui-grid-b ui-grid-b-offres">
                        {{#if acc.offres}}
                           {{#foreach acc.offres.element}}
                            <div class="ui-block-{{$block}}">
                                <div class="ui-grid-b-offres-cult">{{cult}}</div>
                                <div class="acc-offre-ico"><img src="/mobiles/css/img/pictos/{{nom}}.min.svg" width="60"/></div>
                                <div class="">{{marches}}</div>
                            </div>
                            {{/foreach}}
                            {{else}}
                                Il n'y a pas de données à afficher.
                            {{/if}}
                    
                        </div>
                    </div>
                 
                    <div class="block-vertical-spacer"></div>

                </div>
                
                

                <!-- troisieme block transaction -->
                <div class="blocks block-transaction">
                    <div class="header-block" id="header-block-offres">
                        <span>TRANSACTION</span>
                    </div>
                    <div class="content-block" >
                        <div class="ui-grid-b ui-grid-b-offres">
                            {{#if acc.transac}}
                            {{#foreach acc.transac.element}}
                                <div class="ui-block-{{$block}}">
                                    <div class="ui-grid-b-offres-cult">{{cult}}</div>
                                    <div class="">{{qt}}</div>
                                    <div class="ui-grid-b-offres-cult">{{px}}</div>
                                </div>
                            {{/foreach}}
                            {{else}}
                            Il n'y a pas de données à afficher. 
                            {{/if}}
                        </div>
                    </div>
                    <div class="block-vertical-spacer"></div>

                </div>
</script>
<div id="wrapper-acc-TPL"></div>
                <!-- quatrieme block administration en cours-->
                <div class="blocks block-administration">

                    <div class="header-block" id="header-block-transac">
                        <span>ADMINISTRATION EN COURS</span>
                    </div>
                    <div id="admin-wrapper-TPL" class="content-block" >
                        
                    </div>
                </div>

                <script id="adminTPL" type="text/x-handlebars-template">
                    <table>
                            <tbody>
                            {{#if acc.admin}}
                                {{#bzeach acc.admin.element}}
                                <tr>
                                    <td>{{cult}} </td>
                                    <td>{{px}}</td>
                                    <td>{{date}}</td>
                                </tr>
                              {{/bzeach}}
                              {{else}}
                              Il n'y a pas de données à afficher.
                              {{/if}}
                            </tbody>
                        </table>
                </script>

                <!-- cinquieme block execution en cours-->
                <div class="blocks block-execution">

                    <div class="header-block" id="header-block-transac">
                        <span>EXECUTION EN COURS</span>
                    </div>
                    <div id="exe-wrapper-TPL" class="content-block" >
                        
                    </div>


                </div>
                 <script id="exeTPL" type="text/x-handlebars-template">
                    <table>
                            <tbody>
                            {{#if  acc.exec}}
                                {{#bzeach acc.exec.element}}
                                <tr>
                                    <td>{{cult}} </td>
                                    <td>{{px}}</td>
                                    <td>{{date}}</td>

                                </tr>
                              {{/bzeach}}
                              {{else}}
                              Il n'y a pas de données à afficher.
                              {{/if}}
                            </tbody>
                        </table>
                </script>
                 <!-- sixieme block execution en cours-->
                 <div class="blocks block-prospection">
                     
                     <div class="header-block" id="header-block-transac">
                         <span>PROSPECTION</span>
                     </div>
                     <div id="pro-wrapper-TPL" class="content-block" >
                         
                     </div>
                     
                     
                 </div>
                 <script id="proTPL" type="text/x-handlebars-template">
                     <table>
                     <tbody>
                     {{#if  acc.pro}}
                     {{#bzeach acc.pro.element}}
                     <tr>
                     <td>{{cult}} </td>
                     <td>{{brut}}</td>
                     <td>{{net}}</td>
                     
                     </tr>
                     {{/bzeach}}
                     {{else}}
                     Il n'y a pas de données à afficher.
                     {{/if}}
                     </tbody>
                     </table>
                     </script>


            </div><!-- /content -->
  
            <div class="footer" id="footer-acc" data-role="footer" data-position="fixed" data-tap-toggle="false">
                <div class="footer-item"><a href="#bz-filter" class="link-footer"><div class="bt-filtre"></div></a></div>
                <div class="footer-item"><a href="/mmarches/index/format/html" class="link-footer"><div class="bt-matif"></div></a></div>
                <div class="footer-item"><a href="/mtransaction/offres/format/html" class="link-footer"><div class="bt-offre"></div></a></div>
                <div class="footer-item"><a href="tel:0033232672060" class="link-footer"><div class="bt-tel"></div></a></div>
            
                   <div data-role="popup" id="popup-help-acc" class="bzpopup overlay" data-corners="false" data-theme="d" data-overlay-theme="d" data-shadow="false" data-tolerance="0,0">
                    <input type="button" class='bt-close-help' value="fermer l'aide" data-theme="d"/>
                    <div class='wrapper-help-anime'>
                    <div class="wrapper-aide"><img id="img-aide" src="/mobiles/css/img/aide/aide1.png"/></div>
                </div>
                
            </div>
            
            </div><!-- /footer -->
            
            
                     
<script>
    
                //flag pour savoir si localstorage actif
                bzLocalStorage=true;
                //init maxLife
                maxLife=600000;
                
                var footer=$("#footer-acc").html();
                
                 var filterData = {
                    "camp": "",
                    "cultures": "",
                    "modified": false,
                    "structure": ""
                }
                
                var filterHtml="";

//loader and initialisation
initAcc();
//load filter 
if(localStorage.filter ){
                 
                        var data=JSON.parse(localStorage.filter);
                        //console.log("data filter ",data)
                        var lastCall=data.lastCall;
                        //console.log(" filter from local storage ");
                        templateRenderFilter(data)
                        
                            
            }
            
//notifications();

loadMenu();
    

                //filter ready
                 $("#acc").off("filterReady").on("filterReady",function(){
                 
                        deleteLocalStorageData();
                 
                         initAcc();
                         $(".ui-loader").css("display","none");

                 })
    bzLoaderHide();
   
//init notifications pour affichage dès acc
notifications();


//google analytics 
  ga('create', 'UA-51906031-2', 'auto');
  ga('send', 'accueil');
  
</script>

         
        </div><!-- /page -->




