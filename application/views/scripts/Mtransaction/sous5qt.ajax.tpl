
<div  data-role="page" id="sous-qt"><!-- qt a engager-->
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
        <script id="sous-qtTPL" type="text/x-handlebars-template">
            <div class="header-content">
            {{datasous.titre}}
            </div>
            <div class="list-offre-comm">{{datasous.txtbase}}</div>
            <h3 class="header-content header-block header-block-ct">{{datasous.soustitre}}</h3>
            <div class="block-ct">
            <h2><span class="ico-custom-ebz ico-titre-ebz ico-custom-{{datasous.produit}}"></span></h2>
            <div style="width: 100%;text-align: center">Quantité à engager</div>
            <div style="width: 100%;text-align: center">Minimum engagement :{{#if datasous.mini }} {{datasous.mini}} {{else}}pas de minimum{{/if}}</div>
            <div style="width:70%;margin:auto;"><input  data-clear-btn="false" name="qt" id="qt" value="" type="number"></div>
            </div>
        </script>

        <div id="wrapper-sous-qtTPL"></div>


    </div>
    <div class="footer" data-role="footer" data-position="fixed" data-tap-toggle="false">
        <div class="ui-grid-b nav-sous">                         <div data-role="popup" id="popup-help-acc" class="bzpopup overlay" data-corners="false" data-theme="d" data-overlay-theme="d" data-shadow="false" data-tolerance="0,0">                     <input type="button" class='bt-close-help' value="fermer l'aide" data-theme="d"/>                     <div class='wrapper-help-anime'>                     <div class="wrapper-aide"><img id="img-aide" src="/mobiles/css/img/aide/aide1.png"/></div>                 </div>                              </div>
            <div class="ui-block-a"><a href="" data-rel="back" data-role="button" data-theme="d" >Retour</a></div>
            <div class="ui-block-b"><a href="/mtransaction/offres/format/html" data-role="button" data-theme="d">Annuler</a></div>
            <div class="ui-block-c"><a href="" id="bt-recap" data-role="button" data-theme="d">Suivant</a></div>
        </div>

    </div><!-- /footer -->
    <script>
        //console.log("qtmini",qtMini)
        //console.log("datasous",dataSous)
        var qt="";
        $(".bz-menu-html").html(menu);
        bindMenuClick();
        $(".menu-popup").trigger("create");
        //console.log("dataSousFrom Qt ",dataSous)
        /*var template = $('#sous-qtTPL').html();
        var html = Handlebars.compile(template);
        var result = html(dataSous);*/
        try{ var template=Handlebars.templates['sous5'];
        var result = template(dataSous);
        $('#wrapper-sous-qtTPL').html(result); }catch(error){}

        $("#bt-recap").click(function(){


        qt=parseFloat($("#qt").val());

        // pour optimiz pas de recap direct etape validation 
        if(produit=="optimiz"){

        if(dataOptimizSecuriz["qtha"]){
        dataOptimizSecuriz["qt"]=qt;
        }else{
        dataOptimizSecuriz["ha"]=qt;
        }

        $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sous7validation/format/html",{ type: "post","data":{"pdt":produit,"params":dataOptimizSecuriz}});
        }else{
        $(".ui-loader").css("display","block");
        var ha=qtMini.match(/hectares/)?"hectares":"tonnes";
        qtMini=parseFloat(qtMini);
        if( qtMini && qt<qtMini || typeof qt === 'string' || isNaN(qt)){
        $(".ui-loader").css("display","none");
        qtMini=qtMini+" "+ha;
        alert("Quantité insuffisante.")
        return false;
        }
        console.log("qt",qt);
        $.ajax({

        url: "/mtransaction/sous5qt/format/json",
        data: {filter:filter,"pdt":produit,"qt":qt,"haqt":ha,"set":true,"idwo":idWo,"idwos":idWos},
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
        $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sous6recap/format/html");
        }
        },
        error:function(a,b,c){
        ajaxError(a.status,b);;
        }
        })
        }


        return false;
        })
        $('.nav-sous a').off("tap",function(e){
        $(e.currentTarget).removeClass("ui-btn-active");
        }).on("tap",function(e){
        $(e.currentTarget).addClass("ui-btn-active");
        })
    </script>
</div><!-- /page -->
