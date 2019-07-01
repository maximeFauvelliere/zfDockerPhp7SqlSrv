
<div  data-role="page" id="execution-detail"><!-- execution-->
    
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
                        <script id="exec-histo-detailTPL"  type="text/x-handlebars-template">
                         {{#if historiquedetail.structure}}
                        <div class="ui-collapsible-heading-toggle marches-subtitle padding-bottom-plus detail-anal-show">
                            {{historiquedetail.structure.nom}} {{historiquedetail.structure.soustitre}} <span class="ui-icon-plus-bz"></span>
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
                            {{#bzeach historiquedetail.structure.mouvements.element}}
                                    <tr class="histoel">
                                        <td >{{date}}</td>
                                        <td >{{nvoybznbon}}</td>
                                        <td >{{brut}}</td>
                                        <td >{{net}}</td>
                                </tr>
                                <tr class="plus-analyses" style="display: none">
                                    <td colspan="4"><i>{{qualite}}</i></td>
                                </tr>
                                {{/bzeach}}
                            </tbody>
                        </table>
                        {{else}}
                            Il n'y a pas de données à afficher.
                        {{/if}}
                    </script>
                    <div id="wrapper-exec-histo-detailTPL"></div>
                    </div>
            </div>

           
            <div class="footer" id="footer-exe-detail" data-role="footer" data-position="fixed" data-tap-toggle="false">

            </div><!-- /footer -->
            <script>
                $("#footer-exe-detail").html(footer);
                $(".bz-menu-html").html(menu);
                bindMenuClick();
                $(".menu-popup").trigger("create");
                function loadExeHistoDetail(){
                    $(".ui-loader").css("display","block")
                    var filter=getFilter(JSON.parse(localStorage.filter));
                     $.ajax({
                                    url: "/mexecution/historiquedetail/format/json",
                                    data: {filter:filter,"idct":idct},
                                    type: "POST",
                                    dataType: "json",
                                    success: function(data) {
                                       
                                        if(data.success=="error"){
                                            if(data.type=="timeout"){
                                                timeOut(data.type);
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","/mexecution/index/format/html");
                                                return;
                                            }else{
                                                alert("Une erreur s'est produite, vous allez être redirigé.")
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index/");
                                            return;
                                            }
                               
                                        }
                                       
                                       data["lastCall"]=new Date().getTime();
                                       localStorage.exehistodetail =JSON.stringify(data);
                                       //console.log("data from exec histo detail",data)
                                       templateRenderExeHistoDetail(data);
                                      $(".ui-loader").css("display","none")
                                      
                                    },
                                    error: function(a, b, c) {

                                        console.log(a);
                                        console.log(b);
                                        console.log(c);
                                        ajaxError(a.status,b);;

                                    }
                    })
                }
                function templateRenderExeHistoDetail(data){
                        /*var template = $('#exec-histo-detailTPL').html();
                        var html = Handlebars.compile(template);
                        var result = html(data);*/
                        try{ var template=Handlebars.templates['exeHistoDetail'];
                        var result = template(data);
                        $('#wrapper-exec-histo-detailTPL').html(result); }catch(error){}

                        $(".detail-anal-show,.histoel").on("click",function(e){

                                if( $(".detail-anal-show span").hasClass("ui-icon-plus-bz")){
                                    //open
                                    $(".detail-anal-show span").addClass("ui-icon-minus-bz");
                                    $(".detail-anal-show span").removeClass("ui-icon-plus-bz");
                                    //$(".detail-anal-show table tr").hide();
                                    //$(".detail-anal-show tr:not(plus-analyses)").last().addClass("not-border-td");
                                }else{
                                    //close
                                     $(".detail-anal-show span").addClass("ui-icon-plus-bz");
                                    $(".detail-anal-show span").removeClass("ui-icon-minus-bz");
                                }

                                $(".plus-analyses").toggle();

                          })
                }
                
                
                            
                                //on charge les donnée
                                //console.log("exe histo n'exite pas")                          
                                loadExeHistoDetail(); 
                           
                
                
                   
            </script>
        </div><!-- /page -->

