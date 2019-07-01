
<div  data-role="page" id="sous-pdts-derives"><!-- produits derivés-->
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

        <script id="sous-pdtsderivesTPL" type="text/x-handlebars-template">
            <div class="header-content">
            {{titre}}
            </div>
            <div class="list-offre-comm">{{txtbase}}</div>
            <h3 class="header-content header-block header-block-ct">{{soustitre}}</h3>
            <div class="block-ct">
            <h2><span class="ico-custom-ebz ico-titre-ebz ico-custom-{{produit}}"></span></h2>
            {{#bzeach produits.produit.element}}
            <div class="collapse-pdtsderives"  data-role="collapsible" data-inset="false" data-iconpos="right">
            <h6 id="secopt{{id}}">{{type}} - {{marchandise}}  {{prime}} </h6>
            {{#bzeach lignes.elements.element}}
            <div class="prod-deriv-content">{{text}} : {{val}}</div>
            {{/bzeach}}
            <div class="prod-deriv-content">
            Je prends ce Securiz : 
            <div data-role="fieldcontain" data-theme="d">
            <select class="pdt-flip" id="{{id}}" marchandise="{{type}}"   data-role="flipswitch" data-theme="c" data-track-theme="d">
            <option value="off">Non</option>
            <option value="on">Oui</option>
            </select> 
            </div>
            </div>
            </div>
            {{/bzeach }}
            </div>  

        </script>
        <div id="wrapper-sous-pdtsderivesTPL"></div>
    </div>        

    <div class="footer" data-role="footer" data-position="fixed" data-tap-toggle="false">
        <div class="ui-grid-b nav-sous">                         <div data-role="popup" id="popup-help-acc" class="bzpopup overlay" data-corners="false" data-theme="d" data-overlay-theme="d" data-shadow="false" data-tolerance="0,0">                     <input type="button" class='bt-close-help' value="fermer l'aide" data-theme="d"/>                     <div class='wrapper-help-anime'>                     <div class="wrapper-aide"><img id="img-aide" src="/mobiles/css/img/aide/aide1.png"/></div>                 </div>                              </div>
            <div class="ui-block-a"><a href="" data-rel="back" data-role="button" data-theme="d" >Retour</a></div>
            <div class="ui-block-b"><a href="/mtransaction/offres/format/html" data-role="button" data-theme="d">Annuler</a></div>
            <div class="ui-block-c"><a id="bt-qt" href="" data-role="button" data-theme="d">Suivant</a></div>
        </div>

    </div><!-- /footer -->
    <script>
        $(".bz-menu-html").html(menu);
        bindMenuClick();
        $(".menu-popup").trigger("create");
        $(".ui-loader").css("display","block")
        var filter=getFilter(JSON.parse(localStorage.filter));
        $.ajax({
        url: "/mtransaction/sous4pdtderives/format/json",
        data: {filter:filter,"pdt":produit,"idwo":idWo,"idwos":idWos,"get":true},
        type: "POST",
        dataType: "json",
        success: function(data) {
        if(data.success=="error"){
        if(data.type=="timeout"){
        timeOut(data.type);
        alert("Vous êtes déconnecté,vous allez être redirigé.")
        $( ":mobile-pagecontainer" ).pagecontainer( "change","offres.html");
        return;
        }else{
        alert("Une erreur s'est produite, vous allez être redirigé.")
        $( ":mobile-pagecontainer" ).pagecontainer( "change","index.html");
        return;
        }

        }
        $(".ui-loader").css("display","none")
        data["titre"]=titre;
        data["soustitre"]=sousTitre;
        data["txtbase"]=txtBase;
        data["produit"]=produit;
        //console.log("data sous pdts derives",data)

        /*var template = $('#sous-pdtsderivesTPL').html();
        var html = Handlebars.compile(template);
        var result = html(data);*/
        try{ var template=Handlebars.templates['sous4'];
        var result = template(data);
        $('#wrapper-sous-pdtsderivesTPL').html(result); }catch(error){}

        $(".collapse-pdtsderives").collapsible().trigger("create");


        $(".ui-flipswitch").click(function(evt){

        var flip=$(evt.currentTarget).find(".pdt-flip").attr("id");
        if($("#"+flip).val()=="off"){

        $(".secuopti-valid").remove();
        return;
        }
        var other=".pdt-flip:not(#"+flip+")";
        var thisId="#"+$(evt.currentTarget).attr("id");
        try{
        $(other).val('off').flipswitch("refresh");
        $(".secuopti-valid").remove();
        $("#secopt"+flip).append("<span class='secuopti-valid'>V</span>");

        }catch(error){

        }

        })



        },

        error: function(a,b,c) {
        console.log(a);
        console.log(b);
        console.log(c);
        ajaxError(a.status,b);;
        }
        }) 



        $("#bt-qt").click(function(e){
        if(!onLine){
        $(".offline").css("display","block");
        return false;
        }else{
        $(".offline").css("display","none");
        }

        var optidwohb,secidwohb;
        $.each($(".pdt-flip"),function(i,a){

        if($(a).val()=="on"){

        if($(a).attr("marchandise").toLowerCase()=="securiz"){
        secidwohb=$(a).attr("id");
        }else{
        optidwohb=$(a).attr("id");
        }
        }
        })

        ////console.log("optidwohb",optidwohb)
        ////console.log("secidwohb",secidwohb)


        var dataToSend={
        "secidwohb":secidwohb,
        "optidwohb":optidwohb,
        "idwo":idWo,
        "idwos":idWos,
        "pdt":produit
        }
        //console.log("dataTosend pdt derive",dataToSend)
        $(".ui-loader").css("display","block")
        //send result opti by ajax json
        $.ajax({
        url: "/mtransaction/sous4pdtderives/format/json",
        data: {filter:filter,"pdt":produit,"params":dataToSend,"set":true},
        type: "POST",
        dataType: "json",
        success:function(data){

        $(".ui-loader").css("display","none")
        if(data.success=="error"){
        switch(data.type){
        case "error":
        alert("Une erreur s'est produite. Vous allez être redirigé.")
        $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/offres/format/html");
        break;

        case "timeout":
        alert("Vous avez dépassé le délais maximum, pour une contractualisation.Vous allez être redirigé.")
        $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/offres/format/html");
        break
        }
        }else{
        //call page 
        $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sous5qt/format/html");
        }
        },
        error:function(a,b,c){
        ajaxError(a.status,b);;
        }
        })


        return false;
        })
        $('.nav-sous a').off("tap",function(e){
        $(e.currentTarget).removeClass("ui-btn-active");
        }).on("tap",function(e){
        $(e.currentTarget).addClass("ui-btn-active");
        })
    </script>
</div><!-- /page -->
