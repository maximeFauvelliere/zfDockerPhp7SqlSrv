 
<div  data-role="page" id="sous-per-date"><!-- souscription periodes-->
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
        <script id="sous3TPL" type="text/x-handlebars-template">
            <div class="header-content">
            {{datasous.titre}}
            </div>
            <div class="list-offre-comm">{{datasous.txtbase}}</div>
            <h3 class="header-content header-block header-block-ct">{{datasous.soustitre}}</h3>
            <div class="block-ct">
            <h2><span class="ico-custom-ebz ico-titre-ebz ico-custom-{{datasous.produit}}"></span></h2>
            <div class="ui-field-contain">
            <label>Périodes d'éxecution</label>
            <select name="p-exec" id="p-exe">
            {{#bzeach datasous.perenlvt.periodes.periode}}
            <option value="{{idwocld}}" {{#ifchecked checked}}selected="selected"{{/ifchecked}} >{{periode}}</option>
            {{/bzeach}}
            </select>
            </div>

            </div>
        </script>

        <div id="wrapper-sous3TPL"></div>

        <div class="ui-field-contain">
            <label>Dates de paiement</label>
            <select name="d-paiement" id="d-paie">

            </select>
        </div>  
    </div>
    <div class="footer" data-role="footer" data-position="fixed" data-tap-toggle="false">
        <div class="ui-grid-b nav-sous">                         <div data-role="popup" id="popup-help-acc" class="bzpopup overlay" data-corners="false" data-theme="d" data-overlay-theme="d" data-shadow="false" data-tolerance="0,0">                     <input type="button" class='bt-close-help' value="fermer l'aide" data-theme="d"/>                     <div class='wrapper-help-anime'>                     <div class="wrapper-aide"><img id="img-aide" src="/mobiles/css/img/aide/aide1.png"/></div>                 </div>                              </div>
            <div class="ui-block-a"><a href="" data-rel="back" data-role="button" data-theme="d" >Retour</a></div>
            <div class="ui-block-b"><a href="/mtransaction/offres/format/html" data-role="button" data-theme="d">Annuler</a></div>
            <div class="ui-block-c"><a id="bt-valid-sous-3" href="" data-role="button" data-theme="d">Suivant</a></div>
        </div>

    </div><!-- /footer -->
    <script>

        $(".bz-menu-html").html(menu);
        bindMenuClick();
        $(".menu-popup").trigger("create");
        //console.log("data 3 from data 2",dataSous);

        /*var template = $('#sous3TPL').html();
        var html = Handlebars.compile(template);
        var result = html(dataSous);*/
        try{ var template=Handlebars.templates['sous3'];
        var result = template(dataSous);
        $('#wrapper-sous3TPL').html(result); }catch(error){}

        $("#p-exe").selectmenu();

        var selectedPexec= $( "#p-exe option:selected").val();

        fillPaiement(selectedPexec);
        //bind change on structure build exec
        $( "#p-exe").on("change",function(e){fillPaiement(selectedPexec)})

        //$('#structures').selectmenu( "refresh", true );





        //$(".offres-listview").trigger("create");




        //gestion des selects

        function fillPaiement(idpexe){

        var optionPaiement=$("#d-paie");


        //init
        optionPaiement.empty();

        var index=$("#p-exe")[0].selectedIndex;

        var periodes=convertElementToArray(dataSous.datasous.perenlvt.periodes.periode);
        var datesPaiements=convertElementToArray(periodes[index].datepaiement);
        $.each(datesPaiements,function(i,e){


        optionPaiement.append('<option value="'+e.idwopa+'" >'+e.paiement+'</option>')

        })


        $(optionPaiement).trigger("change");





        }




        //validation des data et envois serveur
        $("#bt-valid-sous-3").click(function(){
        if(!onLine){
        $(".offline").css("display","block");
        return false;
        }else{
        $(".offline").css("display","none");
        }

        //data to send for sous 3
        var paiementSelected=$( "#d-paie option:selected").val();
        var periodeSelected=$( "#p-exe option:selected").val();
        //all data to send 
        var dataToSend={
        "stru":structuresSelected,
        "exec":executionsSelected,
        "paiement":paiementSelected,
        "periode":periodeSelected,
        "idwo":idWo,
        "idwos":idWos,
        "pdt":produit,
        "silo":siloSelected
        }

        //console.log("dataTosend",dataToSend)
        $(".ui-loader").css("display","block")
        //send data to server 
        $.ajax({
        url: "/mtransaction/sous3peridate/format/json",
        data: {filter:filter,"params":dataToSend,"set":true},
        type: "POST",
        dataType: "json",
        success: function(data) {

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
        /*
        *switch en function des produit
        */
        if(dataSous.datasous.optimiz.checked==1 || dataSous.datasous.securiz.checked==1){

        $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sous4pdtderives/format/html");

        }else if(dataSous.datasous.produit=="bzenith" ){
        $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sousbzenith/format/html");

        }else if(dataSous.datasous.produit=="bzen" ){

        $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sousbzen/format/html");

        }else{
        $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sous5qt/format/html");
        }

        }
        },
        error:function(a,b,c){
        ajaxError(a.status,b);;
        }
        })





        //send to serveur

        return false;

        })
        $('.nav-sous a').off("tap",function(e){
        $(e.currentTarget).removeClass("ui-btn-active");
        }).on("tap",function(e){
        $(e.currentTarget).addClass("ui-btn-active");
        })
    </script>
</div><!-- /page -->
