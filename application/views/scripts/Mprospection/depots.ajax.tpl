
<div  data-role="page" id="depot-detail"><!-- execution-->
    
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
                        <script id="pros-depot-detailTPL"  type="text/x-handlebars-template">
                      
                        <div class="ui-collapsible-heading-toggle marches-subtitle padding-bottom-plus detail-com-show">
                            {{titre}} {{soustitre}} <span class="ui-icon-plus-bz"></span>
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th >Date</th>
                                    <th>N° voy BZ n°bon</th>
                                    <th>Brut t</th>
                                    <th>Net t</th>
                                </tr>
                            </thead>
                            <tbody>
                            {{#bzeach detail.element}}
                                    <tr class="depotel">
                                        <td >{{date}}</td>
                                        <td >{{nvbznb}}</td>
                                        <td >{{brut}}</td>
                                        <td >{{net}}</td>
                                </tr>
                                <tr class="plus-com" style="display: none">
                                    <td colspan="4"><i>{{com}}</i></td>
                                </tr>
                                {{/bzeach}}
                            </tbody>
                        </table>
                        
                    </script>
                    <div id="wrapper-pro-depot-detailTPL"></div>
                    </div>
            </div>

           
           <div class="footer" id="footer-pros-detail" data-role="footer" data-position="fixed" data-tap-toggle="false">
               
           </div><!-- /footer -->

            <script>
                 $("#footer-pros-detail").html(footer);
                $(".bz-menu-html").html(menu);
                bindMenuClick();
                $(".menu-popup").trigger("create");
                
                setTimeout(function(){
                           
                           if(prevPage!="prospection" || !indexDetailPro) {
                                $(":mobile-pagecontainer").pagecontainer("change", "/mprospection/index/format/html",{loadMsgDelay:0});
                           }else{
                           //console.log("indexDetailPro",indexDetailPro);
                           var tab=indexDetailPro.split("-");
                           //console.log("dataProsDepot",dataProsDepot)
                           var dataSelectedStructure = convertElementToArray(dataProsDepot.depots.structures.element);
                           
                           dataSelectedStructure=dataSelectedStructure[tab[0]];
                           
                           var strutitre=dataSelectedStructure.titre;
                           var soustitre=dataSelectedStructure.soustitre;
                           
                           var dataSelectedDepot =  convertElementToArray(dataSelectedStructure.depot.element);
                           
                           dataSelectedDepot =  dataSelectedDepot[tab[1]];
                           
                           dataSelectedDepot['titre']=strutitre;
                           dataSelectedDepot['soustitre']=soustitre;
                           ////console.log("dataSelectedDepot",dataSelectedDepot)
                           /*var template = $('#pros-depot-detailTPL').html();
                            var html = Handlebars.compile(template);
                            var result = html(dataSelectedDepot);*/
                           try{ var template=Handlebars.templates['prosdepotdetail'];
                           var result = template(dataSelectedDepot);
                           $('#wrapper-pro-depot-detailTPL').html(result); }catch(error){}
                           
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
                