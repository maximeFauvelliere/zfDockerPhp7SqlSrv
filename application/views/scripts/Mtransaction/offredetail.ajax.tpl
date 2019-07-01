
<div  data-role="page" id="sous-detail"><!-- page souscription-->
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
        <script id="offredetailTPL" type="text/x-handlebars-template">
            <div class="header-content">
            {{offredetail.titre}}
            </div>
            <div class="list-offre-comm">{{offredetail.txtbase}}</div>
            <h3 class="header-content header-block header-block-ct">{{offredetail.soustitre}}</h3>
            <div class="block-ct">
            <h2><span class="ico-custom-ebz ico-titre-ebz ico-custom-{{offredetail.produit}}"></span></h2>
            <table>
            <tbody>
            {{#bzeach offredetail.lignes.element}}
            <tr>
            <td>{{lib}}</td>
            <td>{{val}}</td>
            </tr>
            {{/bzeach}}
            </tbody>
            </table>
            </div>
        </script>
        <div id="wrapper-offredetailTPL">
        </div>
    </div>
    <div class="footer" data-role="footer" data-position="fixed" data-tap-toggle="false">
        <div class="ui-grid-b nav-sous">                         <div data-role="popup" id="popup-help-acc" class="bzpopup overlay" data-corners="false" data-theme="d" data-overlay-theme="d" data-shadow="false" data-tolerance="0,0">                     <input type="button" class='bt-close-help' value="fermer l'aide" data-theme="d"/>                     <div class='wrapper-help-anime'>                     <div class="wrapper-aide"><img id="img-aide" src="/mobiles/css/img/aide/aide1.png"/></div>                 </div>                              </div>
            <div class="ui-block-a"><a href="" data-rel="back" data-role="button" data-theme="d">Retour</a></div>
            <div class="ui-block-b"><a href="offres.html" data-role="button" data-theme="d">Annuler</a></div>
            <div class="ui-block-c"><a id="bt-engage" href="" data-role="button" data-theme="d">Engager</a></div>
        </div>
        <script>
            //--------------------template-------------------------------------//
            $(".bz-menu-html").html(menu);
            bindMenuClick();
            $(".menu-popup").trigger("create");
            var qtMini="";

            function getOffreDetail(){
            $("#bt-engage").removeClass("ui-disabled");
            if(!onLine){
            $("#wrapper-offredetailTPL").append("<div>Réseau indisponible ou dégradé, Nous ne pouvons pas répondre à votre demande.</div>");
            $("#bt-engage").addClass("ui-disabled");
            return;
            }
            console.log("idwo1",idWo)
            console.log("idwohb1",idWoHb)
            var filter=getFilter(JSON.parse(localStorage.filter));
            $(".ui-loader").css("display","block");
            $.ajax({
            url: "/mtransaction/offredetail/format/json",
            data: {filter:filter,"pdt":produit,"idwo":idWo,"idwohb":idWoHb},
            type: "POST",
            dataType: "json",
            success: function(data) {

            if(data.success=="error"){
            if(data.type=="timeout"){
            timeOut(data.type);
            $( ":mobile-pagecontainer" ).pagecontainer( "change","/mtransaction/offres/format/html");
            return;
            }else{
            alert("Une erreur s'est produite, vous allez être redirigé.")
            $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index");
            return;
            }

            }
            $(".ui-loader").css("display","none")
            idWoHb="";
            qtMini=data.offredetail.qtmini;

            if(data.offredetail.idwohb){
            idWo="";
            idWoHb=data.offredetail.idwohb;
            idWo=data.offredetail.idwo;
            }

            console.log("idwo",idWo)
            console.log("idwohb",idWoHb)

            //convert tab 
            //myConvert(data);
            console.log("data offredetail",data)
            titre=data.offredetail.titre;
            txtBase=data.offredetail.txtbase;
            sousTitre=data.offredetail.soustitre;
            produit=data.offredetail.produit;

            templateRenderOffreDetail(data);





            },
            error: function(a,b,c) {
            console.log(a);
            console.log(b);
            console.log(c);
            ajaxError(a.status,b);;

            }
            }) 

            }
            getOffreDetail();
            function templateRenderOffreDetail(data){

            /*var template = $('#offredetailTPL').html();
            var html = Handlebars.compile(template);
            var result = html(data);*/
            try{ var template=Handlebars.templates['offresDetail'];
            var result = template(data);
            $('#wrapper-offredetailTPL').html(result); }catch(error){}

            //$(".offres-listview").trigger("create");

            $("#bt-engage").click(function(e){
            if(!onLine){
            $(".offline").css("display","block");
            return false;
            }else{
            $(".offline").css("display","none");
            }

            if(!checkACL("contratencours")){
            $(".menu-popup").popup("open");
            evt.preventDefault();
            }

            ////console.log("pdt",produit)
            //gestion nav en function de l'offre
            if(produit.toLocaleLowerCase()=="optimiz"){
            $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sousoptimiz/format/html");
            return false;
            }else{
            $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sous2struexec/format/html");
            return false;
            }

            })

            }
            $('.nav-sous a').off("tap",function(e){
            $(e.currentTarget).removeClass("ui-btn-active");
            }).on("tap",function(e){
            $(e.currentTarget).addClass("ui-btn-active");
            })


        </script>

    </div><!-- /footer -->
</div><!-- /page -->
