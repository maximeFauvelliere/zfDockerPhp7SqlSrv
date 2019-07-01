
<div  data-role="page" id="sous-validation"><!-- validation-->
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
        <script id="sous-7-validationTPL" type="text/x-handlebars-template">
            <div class="header-content">
            {{validation.titre}}
            </div>
            <div class="list-offre-comm">{{validation.txtbase}}</div>
            <h3 class="header-content header-block header-block-ct">{{validation.soustitre}}</h3>
            <div class="block-ct">
            <h2><span class="ico-custom-ebz ico-titre-ebz ico-custom-{{validation.produit}}"></span>{{#if validation.pdtsderives }}<span class="ico-custom-ebz ico-titre-ebz ico-custom-securiz"></span>{{/if}}</h2>
        </script>
        <div id="wrapper-sous-7-validationTPL"></div>
        <div>
            <div style="width: 70%;text-align: center;margin: auto;">Pour valider définitivement votre engagement, 
                entrez ci-dessous votre mot de passe.</div>
            <div style="width: 70%;text-align: center;margin:auto;padding-top: 50px;">Mot  de passe</div>
            <div style="width:70%;margin:auto;"><input data-clear-btn="false" name="pwd2" id="pass2" value="" type="password"></div>
        </div>

        <!-- pop up dialog box --->
        <div data-role="popup" id="offre-valid" data-theme="c" class="popup-list popup-valid-ct">
            <a href="offres.html" data-rel="back"  data-theme="c"  data-iconpos="notext" class="ui-btn-right">X</a>
            <h3>Engagement Confirmé</h3>
            <div id="popup-content">Votre engagement a était pris en compte.</div>
        </div>

    </div>
    <div class="footer" data-role="footer" data-position="fixed" data-tap-toggle="false">
        <div class="ui-grid-b nav-sous">                         <div data-role="popup" id="popup-help-acc" class="bzpopup overlay" data-corners="false" data-theme="d" data-overlay-theme="d" data-shadow="false" data-tolerance="0,0">                     <input type="button" class='bt-close-help' value="fermer l'aide" data-theme="d"/>                     <div class='wrapper-help-anime'>                     <div class="wrapper-aide"><img id="img-aide" src="/mobiles/css/img/aide/aide1.png"/></div>                 </div>                              </div>
            <div class="ui-block-a"><a href="" data-rel="back" data-role="button" data-theme="d" >Retour</a></div>
            <div class="ui-block-b"><a href="/mtransaction/offres/format/html" data-role="button" data-theme="d" >Annuler</a></div>
            <div class="ui-block-c"><a href="#offre-valid" id="bt-valid-def" data-role="button" data-theme="d"  data-rel="popup" data-position-to="window" data-transition="pop">Suivant</a></div>
        </div>

    </div><!-- /footer -->
    <script>
        $(".bz-menu-html").html(menu);
        bindMenuClick();
        $(".menu-popup").trigger("create");
        /**
        *On creer un objet car il faudrait sinon modifier sous 1 juste pour les logos
        **/
        var dataValidation={"validation":{"titre":titre,"textbase":txtBase,"soustitre":sousTitre,"produit":produit}};
        //if(typeDerivesValid) dataValidation.validation["pdtsderives"]=typeDerivesValid;
        ////console.log("data-7",dataValidation)
        /*var template = $('#sous-7-validationTPL').html();
        var html = Handlebars.compile(template);
        var result = html(dataValidation);*/
        try{ var template=Handlebars.templates['sous7'];
        var result = template(dataValidation);
        $('#wrapper-sous-7-validationTPL').html(result); }catch(error){}


        $("#bt-valid-def").click(function(){
        if(!onLine){
        $(".offline").css("display","block");
        return false;
        }else{
        $(".offline").css("display","none");
        }

        var pwd2=$("#pass2").val();

        if(dataOptimizSecuriz){
        var data={"pdt":produit,"pwd":pwd2,"params":dataOptimizSecuriz,"set":true};
        }else{
        var data={"pdt":produit,"pwd":pwd2,"idwo":idWo,"idwos":idWos,"set":true};
        }
        $(".ui-loader").css("display","block")
        $("#offre-valid" ).off("popupafterclose");
        $.ajax({
        url: "/mtransaction/sous7validation/format/json",
        data:data ,
        type: "POST",
        dataType: "json",
        success: function(data) {

        $(".ui-loader").css("display","none");
        if(data.success=="error"){
        $("#offre-valid h3").html("Erreur engagement");
        switch(data.type){
        case "pwd":
        $("#offre-valid div").html("Votre mot de passe n'est pas valide.");
        break;
        case "timeout":
        $("#offre-valid div").html("Vous avez dépassé le délais maximum, pour une contractualisation.Vous allez être redirigé.");
        break;

        default:
        $("#offre-valid div").html("Une erreur s'est produite pendant votre engagement.<br/>Si l'erreur persite contacter votre commercial au :<br/><span style='display: inline-block;font-size: 12pt;font-weight: bold;text-align: center;width: 100%;'>02.32.67.20.60</span>");
        break;
        }

        }else{
        $("#offre-valid h3").html("Confirmation engagement");
        $("#offre-valid div").html("Votre contrat a bien été enregistré sous le numéro : <br/><span style='display: inline-block;font-size: 12pt;font-weight: bold;text-align: center;width: 100%;'>"+data.numtran+"</span>");
        $("#offre-valid" ).on("popupafterclose",function() {
        $(".ui-loader").css("display","block");
        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mtransaction/offres/format/html");
        });
        }
        //console.log("data form validation json",data)
        $("#offre-valid").popup("open");
        },

        error: function(a,b,c) {
        console.log(a);
        console.log(b);
        console.log(c);
        ajaxError(a.status,b);;
        }
        })     

        return false;

        });
        $('.nav-sous a').off("tap",function(e){
        $(e.currentTarget).removeClass("ui-btn-active");
        }).on("tap",function(e){
        $(e.currentTarget).addClass("ui-btn-active");
        })


    </script>
</div>
</div><!-- /page -->
