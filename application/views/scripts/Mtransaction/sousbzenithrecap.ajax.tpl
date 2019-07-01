
<div  data-role="page" id="sous-recap-bzenith"><!-- recapitulatif-->
    <div data-role="popup" id="menu-popup"  class='ui-content-menu-popup menu-popup' data-theme="b">
        Vous n'avez pas accès à cette rubrique.
    </div>
    <div data-role="header" data-position="fixed" data-tap-toggle="false">
        <div data-role="panel" id="bz-menu" class="bzmenu"  data-display="overlay" data-position="right" data-theme="b" data-close="" > 


        </div><!-- fin panel menu-->
        <div class="header-item header-left"><a href="#" data-rel="back"><img src="/mobiles/css/img/pictos/back.min.svg" width="30"/></a></div>
        <div class="header-item header-center"><a class="bt-acc"  href="/maccueil/index/format/html"><img src="/mobiles/css/img/pictos/ebz.min2.svg" width="80"/></a></div>
        <div class="header-item header-right"><a href="#bz-menu" ><img src="/mobiles/css/img/pictos/menu.min.svg" width="30"/></a></div>
        <div class="bt-aide" ></div>                 <div class="offline" style="display:none;">Vous êtes hors réseaux, les données affichées ne sont pas à jour, vous n'avez pas accés à la commercialisation.</div>
    </div><!-- /header -->
    <div class="clear"></div>

    <div data-role="content" >
        <script id="sous-bzenith-recapTPL" type="text/x-handlebars-template">
            <div class="header-content">
            {{titre}}
            </div>
            <div class="list-offre-comm">{{txtbase}}</div>
            <h3 class="header-content header-block header-block-ct">{{soustitre}}</h3>
            <div class="block-ct">
            <h2><span class="ico-custom-ebz ico-titre-ebz ico-custom-{{produit}}"></span></h2>
            <table>
            <tbody>
            {{#bzeach recap.contrat.element}}
            <tr><td>{{lib}}</td><td>{{val}}</td></tr>
            {{/bzeach}}
            </tbody>
            </table>
            </div>
            {{#if recap.pdtsderives}}
            <div class="block-ct">
            <h2><span class="label-recap">Récapitulatif </span><span class="ico-custom-ebz ico-titre-ebz ico-custom-{{recap.pdtsderives.type}}"></span></h2>
            <table>
            <tbody>
            {{#bzeach recap.pdtsderives.element}}
            <tr><td>{{lib}}</td><td>{{val}}</td></tr>
            {{/bzeach}} 
            </tbody>
            </table>
            </div>
            {{/if}}

        </script>
        <div id="wrapper-sous-bzenith-recapTPL"></div>
    </div>
    <div class="footer" data-role="footer" data-position="fixed" data-tap-toggle="false">
        <div class="ui-grid-b nav-sous">                         <div data-role="popup" id="popup-help-acc" class="bzpopup overlay" data-corners="false" data-theme="d" data-overlay-theme="d" data-shadow="false" data-tolerance="0,0">                     <input type="button" class='bt-close-help' value="fermer l'aide" data-theme="d"/>                     <div class='wrapper-help-anime'>                     <div class="wrapper-aide"><img id="img-aide" src="/mobiles/css/img/aide/aide1.png"/></div>                 </div>                              </div>
            <div class="ui-block-a"><a href="/mtransaction/sousbzenith/format/html" data-role="button" data-theme="d" >Retour</a></div>
            <div class="ui-block-b"><a href="/mtransaction/offres/format/html" data-role="button" data-theme="d">Annuler</a></div>
            <div class="ui-block-c"><a href="" id="bt-valid-bzenith" data-role="button" data-theme="d">Suivant</a></div>
        </div>


    </div><!-- /footer -->
    <script>

        $(".bz-menu-html").html(menu);
        bindMenuClick();
        $(".menu-popup").trigger("create");
        var typeDerivesValid="";
        $(".ui-loader").css("display","block")
        var filter=getFilter(JSON.parse(localStorage.filter));
        $.ajax({
        url: "/mtransaction/sousbzenithrecap/format/json",
        data: {filter:filter,"pdt":produit,"idwo":idWo,"idwos":idWos,"get":true},
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
        $(".ui-loader").css("display","none")
        data["titre"]=titre;
        data["soustitre"]=sousTitre;
        data["txtbase"]=txtBase;
        data["produit"]=produit;
        try{
        typeDerivesValid=data.recap.pdtsderives.type;
        }catch(error){

        }
        //console.log("typederive",typeDerivesValid);
        //console.log("data from sous-bzenith-recap",data)

        /*var template = $('#sous-bzenith-recapTPL').html();
        var html = Handlebars.compile(template);
        var result = html(data);*/
        try{ var template=Handlebars.templates['sousBzenithRecap'];
        var result = template(data);
        $('#wrapper-sous-bzenith-recapTPL').html(result); }catch(error){}

        },

        error: function(a,b,c) {
        console.log(a);
        console.log(b);
        console.log(c);
        ajaxError(a.status,b);;

        }
        })  

        $("#bt-valid-bzenith").click(function(){
        if(!onLine){
        $(".offline").css("display","block");
        return false;
        }else{
        $(".offline").css("display","none");
        }
        $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sous5qt/format/html");
        return false;
        });
        $('.nav-sous a').off("tap",function(e){
        $(e.currentTarget).removeClass("ui-btn-active");
        }).on("tap",function(e){
        $(e.currentTarget).addClass("ui-btn-active");
        })
    </script>
</div><!-- /page -->
