
<div  data-role="page" id="sous-optimiz-ct"><!-- page souscription-->
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
        <script id="sous-opti-ctTPL" type="text/x-handlebars-template">
            <div class="header-content">
            {{titre}}
            </div>
            <div class="list-offre-comm">{{txtbase}}</div>
            <h3 class="header-content header-block header-block-ct">{{soustitre}}</h3>
            <div class="block-ct">
            <h2><span class="ico-custom-ebz ico-titre-ebz ico-custom-{{produit}}"></span></h2>
            <table data-role="table"   class="table-stroke">
            <thead>
            <tr>
            <th >{{contrats.headcontrat}}</th>
            <th>{{contrats.headpxactu}}</th>
            <th>{{contrats.headpxcouv}}</th>
            <th>Qté/ha</th>
            <th></th>
            </tr>
            </thead>
            <tbody>
            {{#bzeach contrats.contrat.element}}
            <tr>
            <td >{{idct}}</td>
            <td>{{pxactu}}</td>
            <td>{{pxcouv}}</td>
            <td>{{qte}}</td>
            <td><input type="checkbox" idct="{{idct}}" qt="{{qte}}"  class="chkct" name="chkct"/></td>
            </tr>
            {{/bzeach}}
            </tbody>
            </table>
            </div>
        </script>
        <div id="wrapper-sous-opti-ctTPL">
        </div>
    </div>
    <div class="footer" data-role="footer" data-position="fixed" data-tap-toggle="false">
        <div class="ui-grid-b nav-sous">                         <div data-role="popup" id="popup-help-acc" class="bzpopup overlay" data-corners="false" data-theme="d" data-overlay-theme="d" data-shadow="false" data-tolerance="0,0">                     <input type="button" class='bt-close-help' value="fermer l'aide" data-theme="d"/>                     <div class='wrapper-help-anime'>                     <div class="wrapper-aide"><img id="img-aide" src="/mobiles/css/img/aide/aide1.png"/></div>                 </div>                              </div>
            <div class="ui-block-a"><a href="" data-rel="back" data-role="button" data-theme="d">Retour</a></div>
            <div class="ui-block-b"><a href="/mtransaction/offres/format/html" data-role="button" data-theme="d">Annuler</a></div>
            <div class="ui-block-c"><a id="bt-opti-qt" href="" data-role="button" data-theme="d">Suivant</a></div>
        </div>
        <script>
            //--------------------template-------------------------------------
            $(".bz-menu-html").html(menu);
            bindMenuClick();
            $(".menu-popup").trigger("create");

            console.log("idwo from sousopti",idWo);
            console.log("idwohb from sousopti",idWoHb);
            var mini="";       
            $(".ui-loader").css("display","block")
            var filter=getFilter(JSON.parse(localStorage.filter));
            $.ajax({
            url: "/mtransaction/sousoptimiz/format/json",
            data: {filter:filter,"pdt":produit,"idwo":idWo,"idwohb":idWoHb,"get":true},
            type: "POST",
            dataType: "json",
            success: function(data) {
            if(data.success=="error"){
            if(data.type=="timeout"){
            timeOut(data.type);
            alert("Vous êtes déconnecté,vous allez être redirigé.")
            $( ":mobile-pagecontainer" ).pagecontainer( "change","/mtransaction/offres/format/html");
            return;
            }else{
            alert("Une erreur s'est produite, vous allez être redirigé.")
            $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index");
            return;
            }

            }
            //console.log("data fromoptimiz ct",data)
            $(".ui-loader").css("display","none")
            try{
            mini=data.contrats.mini;
            }catch(error){
            mini="";
            }

            //console.log("mini opti",mini);
            data["titre"]=titre;
            data["soustitre"]=sousTitre;
            data["txtbase"]=txtBase;
            data["produit"]=produit;

            dataSous={"datasous":data};

            ////console.log("data fromoptimiz ct",data)

            /*var template = $('#sous-opti-ctTPL').html();
            var html = Handlebars.compile(template);
            var result = html(data);*/
            try{ var template=Handlebars.templates['sousOptimiz'];
            var result = template(data);
            $('#wrapper-sous-opti-ctTPL').html(result); }catch(error){}


            //$('.chkct').checkboxradio().trigger("create");
            //$(".offres-listview").trigger("create");

            $("#bt-opti-qt").click(function(){
            if(!onLine){
            $(".offline").css("display","block");
            return false;
            }else{
            $(".offline").css("display","none");
            }

            //init dataOptimizSecuriz
            dataOptimizSecuriz="";
            //verifie si une au moins un check
            if(!$( ".chkct:checked" ).length==1){
            alert("Vous devez sélectionner un contrat, avant de poursuivre.");
            return false;
            }
            var ct=[];
            $.each($( ".chkct:checked" ),function(i,e){
            ct.push({"ct":$(e).attr("idct"),"qt":$(e).attr("qt")})
            })

            console.log("ct object",ct)

            //var ct =$( ".chkct:checked" ).attr("idct");
            var qt =$( ".chkct:checked" ).attr("qt").match(/t/)?1:0;


            dataOptimizSecuriz={
            "idwo":idWo,
            "idwohb":idWoHb,
            "pdt":produit,
            "idct":ct,
            "qtha":qt
            }

            console.log("idwohb",idWoHb);
            console.log("idct",ct);
            if(dataOptimizSecuriz["qtha"]){
            dataOptimizSecuriz["qt"]=qt;
            }else{
            dataOptimizSecuriz["ha"]=qt;
            }

            $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sous7validation/format/html",{ type: "post","data":{"pdt":produit,"params":dataOptimizSecuriz}});



            })






            },

            error: function(a,b,c) {
            console.log(a);
            console.log(b);
            console.log(c);
            ajaxError(a.status,b);;

            }
            });

            $('.nav-sous a').off("tap",function(e){
            $(e.currentTarget).removeClass("ui-btn-active");
            }).on("tap",function(e){
            $(e.currentTarget).addClass("ui-btn-active");
            })       


        </script>

    </div><!-- /footer -->
</div><!-- /page -->
