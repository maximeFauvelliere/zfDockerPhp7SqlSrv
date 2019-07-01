
<div  data-role="page" id="ferme-detail"><!-- execution-->
    
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

                    <div class="block-hor-layout">
                        <script id="pros-ferme-detailTPL"  type="text/x-handlebars-template">
                      
                        <div class="ui-collapsible-heading-toggle marches-subtitle padding-bottom-plus detail-com-show">
                            {{titre}} <span class="ui-icon-plus-bz"></span>
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th>Nom lot</th>
                                    <th>Type</th>
                                    <th>Solde</th>
                                </tr>
                            </thead>
                            <tbody>
                            {{#bzeach detail.element}}
                                    <tr class="depotel">
                                        <td >{{nom}}</td>
                                        <td >{{#if detail.element.type}}{{type}}{{/if}}</td>
                                        <td >{{solde}}</td>
                                    </tr>
                                    <tr class="plus-com" style="display: none">
                                        <td colspan="4"><i>{{com}}</i></td>
                                    </tr>
                            {{/bzeach}}
                            </tbody>
                        </table>
                        
                    </script>
                    <div id="wrapper-pro-ferme-detailTPL"></div>
                    </div>
            </div>

           
           <div class="footer" id="footer-ferme-detail" data-role="footer" data-position="fixed" data-tap-toggle="false">
               
           </div><!-- /footer -->

            <script>
                 $("#footer-ferme-detail").html(footer);
                $(".bz-menu-html").html(menu);
                bindMenuClick();
                $(".menu-popup").trigger("create");
                
                setTimeout(function(){
                           
                           if(prevPage!="prospection" || !indexDetailFerme) {
                                $(":mobile-pagecontainer").pagecontainer("change", "/mprospection/index/format/html",{loadMsgDelay:0});
                           }else{
                           //console.log("indexDetailFerme",indexDetailFerme);
                    
                           var tab=indexDetailFerme.split("-");
                           //console.log("dataProsDepot",dataProsFerme)
                           var dataSelectedStructure = convertElementToArray(dataProsFerme.ferme.structures.element);
                           
                           dataSelectedStructure=dataSelectedStructure[tab[0]];
                           
                           var strutitre=dataSelectedStructure.titre;
                        
                           
                           var dataSelectedFerme =  convertElementToArray(dataSelectedStructure.lots.element);
                           
                           dataSelectedFerme =  dataSelectedFerme[tab[1]];
                           
                           
                           dataSelectedFerme['titre']=strutitre;

                           //console.log("dataSelectedFerme",dataSelectedFerme)
                           /*var template = $('#pros-ferme-detailTPL').html();
                            var html = Handlebars.compile(template);
                            var result = html(dataSelectedFerme);*/
                           try{
                            var template=Handlebars.templates['prosfermedetail'];
                            var result = template(dataSelectedFerme);
                           $('#wrapper-pro-ferme-detailTPL').html(result);
                           
                           }catch(error){}
                           
                           $(".detail-com-show , .depotel").on("click",function(e){
                                                       
                               if( $(".detail-com-show span").hasClass("ui-icon-plus-bz")){
                                   //open
                                   $(".detail-com-show span").addClass("ui-icon-minus-bz");
                                   $(".detail-com-show span").removeClass("ui-icon-plus-bz");

                               }else{
                                   //close
                                   $(".detail-com-show span").addClass("ui-icon-plus-bz");
                                   $(".detail-com-show span").removeClass("ui-icon-minus-bz");
                               }
                               
                               $(".plus-com").toggle();
                                                       
                            })

                           
                           }
                           
                           },150)
                
                
                            
                
                   
            </script>
        </div><!-- /page -->
                