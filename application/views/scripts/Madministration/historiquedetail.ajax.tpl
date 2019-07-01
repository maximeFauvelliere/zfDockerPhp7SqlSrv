
<div  data-role="page" id="administration-detail"><!-- execution-->
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
                    <script id="adm-histo-detailTPL"  type="text/x-handlebars-template">
                        <div class="ui-collapsible-heading-toggle marches-subtitle padding-bottom-plus">
                            {{titre}} <br/> <span>{{culture}} - {{banque}} - {{dateregl}}</span>
                        </div>
                        <table>
                            <thead>
                                <tr>
                                    <th >N°Ct</th>
                                    <th>N° Fac</th>
                                    <th>Qté t</th>
                                    <th>Mtt net €</th>
                                </tr>
                            </thead>
                            <tbody>
                            {{#bzeach detail.element}}
                                    <tr id="{{idfa}}">
                                    <td >{{nct}}</td>
                                    <td >{{nfac}}</td>
                                    <td >{{qte}}</td>
                                    <td >{{mttnet}}</td>
                                </tr>
                              {{/bzeach}}
                            </tbody>
                        </table>
                    </script>
                    <div id="wrapper-adm-histo-detailTPL"></div>
                    </div>
            </div>

           
            <div class="footer" id="footer-adm-detail" data-role="footer" data-position="fixed" data-tap-toggle="false">

            </div><!-- /footer -->
            <script>
                 $("#footer-adm-detail").html(footer);
                $(".bz-menu-html").html(menu);
                bindMenuClick();
                $(".menu-popup").trigger("create");
                
                  //timeout sinon prevPage pas encore dispatch 
        setTimeout(function(){
            
            if(prevPage!="administration" || !indexDetailHisto) {
                    $(":mobile-pagecontainer").pagecontainer("change", "/madministration/index/format/html",{loadMsgDelay:0});
            }else{
            //console.log("indexDetailHisto",indexDetailHisto);
                  var tab=indexDetailHisto.split("-");

                  var dataSelectedStructure = convertElementToArray(dataAdmHisto.historique.structures.element);

                  dataSelectedStructure=dataSelectedStructure[tab[0]];
                   
                  var strutitre=dataSelectedStructure.titre;

                  var dataSelectedReglement =  convertElementToArray(dataSelectedStructure.reglements.element);

                  dataSelectedReglement =  dataSelectedReglement[tab[1]];

                  dataSelectedReglement['titre']=strutitre;

                  /*var template = $('#adm-histo-detailTPL').html();
                  var html = Handlebars.compile(template);
                  var result = html(dataSelectedReglement);*/
                   try{ var template=Handlebars.templates['adminHistoDetail'];
                   var result = template(dataSelectedReglement);
                  $('#wrapper-adm-histo-detailTPL').html(result); }catch(error){}
            }
            
        },150)
               
        /*
        *prévoir telechargement facture au click sur la ligne 
        *
        */
        
        
                  
               
            </script>
        </div><!-- /page -->
  