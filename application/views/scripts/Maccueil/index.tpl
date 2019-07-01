
        <div data-role="page" id="acc">
            <div class="bzLoader"><img src="/mobiles/css/img/pictos/ebz.min.svg" width="100"/><br/><span>Chargement de vos données.</span></div>   
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
                                <div class=" bt-filter">
                                    <div class=" bt-cancel-filtre"><a href="#"  class="ui-btn ui-corner-all ui-mini bt-annul-panel">Annuler</a></div>
                                    <div class=" bt-valid-filtre"><a href="#" class="ui-btn ui-corner-all ui-mini bt-annul-panel">Valider</a></div>
                                </div>

                    </div>
            </script>

            </div><!-- /panel -->
            
            <div data-role="header" data-position="fixed" data-tap-toggle="false">
                <div data-role="panel" id="bz-menu" class="bzmenu" data-display="overlay" data-position="right" data-theme="b" data-close="" > 
                    <script id="menuTPL" type="text/x-handlebars-template">
                    <div class="bz-menu">
                        <div data-role="popup"  class='ui-content-menu-popup menu-popup' data-theme="b">
                            Vous n'avez pas accès à cette rubrique.
                        </div>
                        <div class="bz-menu-header"><img class="close-menu" src="/mobiles/css/img/pictos/menu.min.svg"/><img  src="/mobiles/css/img/pictos/ebz.min2.svg"/></div>
                        
            {{#bzeach menu.element}}
                {{#bzIf rubrique  "transaction"}}
                    <a href="/mtransaction/index/format/html" class="enable  {{#bzIf checked  "0"}}disable{{/bzIf}}" ><div class="menu-list " >Transaction</div></a>
                {{/bzIf}}
                {{#bzIf rubrique "execution"}}
                    <a href="/mexecution/index/format/html" class="enable  {{#bzIf checked  "0"}}disable{{/bzIf}}"><div class="menu-list " >Exécution</div></a>
                {{/bzIf}}
                {{#bzIf rubrique "administration"}}
                    <a href="/madministration/index/format/html" class="enable {{#bzIf checked  "0"}}disable{{/bzIf}}"><div class="menu-list">Administration</div></a>
                {{/bzIf}}
                {{#bzIf rubrique "contratsasigner"}}
                    <a href="/madministration/contratsasigner/format/html" class="enable {{#bzIf checked  "0"}}disable{{/bzIf}}"><div class="menu-list ">Contrats à signer <span class="notif-menu notif-menu-ctsign"><span>21</span></span></div></a>
                {{/bzIf}}
                {{#bzIf rubrique "contratencours"}}
                    <a href="/mtransaction/contratsencours/format/html" class="enable  {{#bzIf checked  "0"}}disable{{/bzIf}}"><div class="menu-list">Contrats en cours <span class="notif-menu notif-menu-ctencours"><span>2</span></span></div></a>
                {{/bzIf}}
            {{/bzeach}}

             <a href="#" class="enable"><div class="menu-list">Déconnexion</div></a>
                        
                    </div>
                </script>
                <div id="wrapper-menuTPL"></div>
                </div><!-- fin panel menu-->
                <div class="header-item header-left"><a href="#" data-rel="back"><img src="/mobiles/css/img/pictos/back.min.svg" width="30"/></a></div>
                <div class="header-item header-center"><a class="bt-acc"  href="/maccueil/index/format/html"><img src="/mobiles/css/img/pictos/ebz.min2.svg" width="80"/></a></div>
                <div class="header-item header-right"><a href="#bz-menu" ><img src="/mobiles/css/img/pictos/menu.min.svg" width="30"/></a></div>
            </div><!-- /header -->
            <div class="clear"></div>

            <div data-role="content">
                <script  id="accTPL" type="text/x-handlebars-template">
                <div class="header-content">
                    {{acc.camp}}
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
                                        <div class="inside-block inside-block-last"><div class="acc-marches-cad {{$isunlock}}"></div></div>
                                    </div>
                                    <span class="taux">{{cours}}</span>
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
                                <div class="acc-offre-ico"><img src="/mobiles/css/img/pictos/{{nom}}.min.svg" width="60"/></div>
                                <div class="ui-grid-b-offres-cult">{{cult}}</div>
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
                                {{#each acc.admin.element}}
                                <tr>
                                    <td>{{cult}} </td>
                                    <td>{{px}}</td>
                                    <td>{{date}}</td>
                                </tr>
                              {{/each}}
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


            </div><!-- /content -->
  
            <div class="footer" id="footer-acc" data-role="footer" data-position="fixed" data-tap-toggle="false">
                <div class="footer-item"><a href="#bz-filter" class="link-footer"><div class="bt-filtre"></div></a></div>
                <div class="footer-item"><a href="/mmarches/index/format/html" class="link-footer"><div class="bt-matif"></div></a></div>
                <div class="footer-item"><a href="/mtransaction/offres/format/html" class="link-footer"><div class="bt-offre"></div></a></div>
                <div class="footer-item"><a href="tel:0033232672060" class="link-footer"><div class="bt-tel"></div></a></div>
            </div><!-- /footer -->
            
            
                     
<script>

                //flag pour savoir si localstorage actif
                bzLocalStorage=true;
                //init maxLife
                maxLife=60000;
                
                var menu="";
                
                var footer=$("#footer-acc").html();
                
                 var filterData = {
                    "camp": "",
                    "cultures": "",
                    "modified": false,
                    "structure": ""
                }

                //loader and initialisation
function initAcc(){
                if (typeof(Storage)!=="undefined") {
                        //creation des object data si ils n'existe pas 
                        if(localStorage.acc){
                            
                            var data=JSON.parse(localStorage.acc);
                            
                            lastCall=data.lastCall;

                            //depuis combien de temps cet objet est stocké
                            var bzNow=new Date().getTime();
                            if(bzNow-lastCall>maxLife){
                                
                                    //on recharge les données
                                    console.log("acc+maxLife depassé")
                                    LoadAcc();
                            }else{
                                console.log("intervalle temps OK ");
                                    templateRenderAcc(data)
                            }
                            
                            $(".bzLoader").hide();
                            
                        }else{
                            //on charge les donnée
                            console.log("acc n'exite pas")
                            LoadAcc();
                        }
                        
                        
                    
                } else {
                    
                    bzLocalStorage=false;
                }
                
    } 
    
initAcc();

//load filter 

if(localStorage.filter ){
                 
                        var data=JSON.parse(localStorage.filter);
                        console.log("data filter ",data)
                        var lastCall=data.lastCall;
                        console.log(" filter from local storage ");
                        templateRenderFilter(data)
                        
                            
            }


    
    loadMenu();
    

                //init variables and function
               
                var flagPageHelp = true, activePage, defaultCamp, minCamp, maxCamp;

 
                //filter ready
                 $("#acc").off("filterReady").on("filterReady",function(){
                 
                        deleteLocalStorageData();
                 
                         initAcc();
                         //setCampHeader();

                 })

     

            </script>
                  
         
        </div><!-- /page -->

     <script>
/**
 * N'est pas bindé si ajax request binder si http request
 * donc les script qui siuvent doivent etre present dans la page connexion si celle ci est affiché 
 * (cas application , pas pour site mobile ou la page est tout le temps appelée)
 */

            
            
            

            $(document).on("pageinit", function(event) {

                //close menu 
                $(".close-menu").click(function(e) {
                    //dans l'obligation d'utiliser une class pour le fermeture ou le panel ne se ferme pas 
                    $(".bzmenu").panel("close");
                })
                
                //filtre cancel
                $(".bt-cancel-filtre").click(function(e){
                    $("#bz-filter").panel("close");
                })
                
                 //filtre valid
                $(".bt-cancel-filtre").click(function(e){
                    //call new data 
                    //reload data and widget
                })

               



                //add event click to matif list
                /*$(".t-marches tr").click(function(e) {
                 var hasUnlock = $(e.currentTarget).children().last().attr("hasunlock");
                 var ech = $(e).first().attr("ech");
                 console.log("hasUnlock", hasUnlock);
                 console.log("ech", ech);
                 clickMatifEche(hasUnlock, ech);
                 })*/



               

                // click contrat to lock
                $(".bt-ct-to-lock").click(function(e) {
                    $(":mobile-pagecontainer").pagecontainer("change", "#contrat-to-lock");
                })
            })//fin ready;


    
                
                

            //event swipe 
            $(document).on('swipeleft', '.ui-content', function(event) {
                if ($.mobile.activePage.attr('id') == "mygraph")
                    return false;
                alert("left");
                if (event.handled !== true) // This will prevent event triggering more then once
                {
                    ChangeCamp($(this).attr("id"), camp, "left")
                    event.handled = true;
                }
                return false;
            });


            $(document).on('swiperight', '.ui-content', function(event) {
                if ($.mobile.activePage.attr('id') == "mygraph")
                    return false;
                alert("right");
                if (event.handled !== true) // This will prevent event triggering more then once
                {

                    ChangeCamp($(this).attr("id"), camp, "right")
                    event.handled = true;
                }
                return false;
            });


            //functions

            function ChangeCamp(activePage, activeCamp, direction) {

                //decrémente ou incremente la campagne
                direction == "right" ? newCamp = parseInt(activeCamp) + 1 : newCamp = parseInt(activeCamp) - 1;

                $.ajax({
                    url: "connexion.php",
                    dataType: "JSON",
                    type: "POST",
                    data: {"camp": newCamp},
                    success: function(data) {
                        camp = data.camp;
                        var camp_tpl = $('#campTPL').html();
                        var html = Mustache.to_html(camp_tpl, data);
                        $('.header-camp').html(html);
                    }

                })
            }

            

            function showPageHelp() {

                if (!flagPageHelp)
                    return;
                // empeche le popup d'etre ouvert 2 x
                if ($(".ui-page-active .ui-popup-active").length > 0)
                    return;


                $('#popup-help-acc').popup();
                setTimeout(function() {
                    $("#popup-help-acc-screen").append()
                    //$("#popup-help-acc").popup( "open" );

                    $(".doigt-up").addClass("doigt-up-begin");
                }, 500)

            }



            $(".doigt-up").on('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend',
                    function(e) {

                        //alert("animation end");

                    });

         

          

            //detruit les popup si ils trainent
            //if ($(".ui-page-active .ui-popup-active").length > 0) $( ".bzpopup" ).popup( "destroy" );





        </script>




        <script>
            setTimeout(function() {
                //createCandles(data)
            }, 3000);

            /**
             * Determine whether the file loaded from PhoneGap or not
             */
            


            



        </script>



