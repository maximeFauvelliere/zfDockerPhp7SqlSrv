
<div  data-role="page" id="list-ct"><!-- liste des ct en cours-->
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
        <div class="bt-aide" ></div>                 
        <div class="offline" style="display:none;">Vous êtes hors réseaux, les données affichées ne sont pas à jour, vous n'avez pas accés à la commercialisation.</div>
    </div><!-- /header -->
    <div class="clear"></div>

    <div data-role="content" >
        <h3 class="header-block header-block-ct">          
            Contrats en cours
        </h3>
        <span id="txt-horaire">Fixation de prix et blocage d'optimiz sont possibles entre 11h et 18h</span>
        <script id="contratsencoursTPL" type="text/x-handlebars-template">
            {{#if contratsencours.marchesref}}
            {{#bzeach contratsencours.marchesref.element}}
            <div class="sticky-header">{{marcheref}}</div>
            {{#if contrats.element}}
            {{#bzeach contrats.element}}
            <div class="block-ct">

            <h2>{{titre}}</h2>

            <table idchb="{{idchb}}" idct="{{idct}}" produit="{{produit}}" titre="{{titre}}"  qtmini="{{qtmini}}" qtha="{{qte}}" pxech="{{pxech}}" pxnet="{{pxech}}" {{#if gainp}}gainp="{{gainp}}"{{/if}} indexct="$index">
            <tbody>
            {{#bzeach lignes.element}}
            <tr>
            <td>{{text}}</td>
            <td>{{val}}</td>
            {{#if $index}}

            {{else}}
            <td rowspan=10 class="td-wrapper-bt"><div class="bt-ct-to-lock"></div></td>
            {{/if}}
            </tr>
            {{/bzeach}}

            </tbody>
            </table>
            </div>
            {{/bzeach}}
            {{/if}}
            {{/bzeach}}
            {{else}}
            Il n'y a pas de données à afficher.
            {{/if}}
        </script>
        <div id="wrapper-contratsencoursTPL"></div>

    </div>
    <div class="footer" id="footer-contratencours" data-role="footer" data-position="fixed" data-tap-toggle="false">

    </div><!-- /footer -->
    <script>
        $("#footer-contratencours").html(footer);
        $(".bz-menu-html").html(menu);
        bindMenuClick();
        $(".menu-popup").trigger("create");
        var typeBloq="";
        var qtBloq="";
        function loadListct(){
        $(".ui-loader").css("display","block")
        var filter=getFilter(JSON.parse(localStorage.filter));
        $.ajax({
        url: "/mtransaction/contratsencours/format/json",
        data: {filter: filter},
        type: "POST",
        dataType: "json",
        success: function(data) {
        console.log("data list ct en cours",data);

        if(data.success=="error"){
        if(data.type=="timeout"){
        timeOut(data.type);
        loadListct();
        return;
        }else{
        alert("Une erreur s'est produite, vous allez être redirigé.")
        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index");
        return;
        }

        }

        data["lastCall"]=new Date().getTime();
        localStorage.listct =JSON.stringify(data);


        templateRenderListct(data);
        setTimeout(function(){
        $(".popup-actu-cts").popup("close");
        $(".popup-actu-cts").remove();
        },1500)
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
        //parametre pour validation du contrat a bloquer
        var paramCtBloq={};
        var recapBloquage="";
        function templateRenderListct(data){
        /*var template = $('#contratsencoursTPL').html();
        var html = Handlebars.compile(template);
        var result = html(data);*/
        try{ var template=Handlebars.templates['ctencours'];
        var result = template(data);
        $('#wrapper-contratsencoursTPL').html(result); }catch(error){}



        /*
        *click contrat to lock
        */
        $(".bt-ct-to-lock").click(function(e){
        if(!onLine){
        $(".offline").css("display","block");
        return false;
        }else{
        $(".offline").css("display","none");
        }

        var el=$(e.currentTarget).closest("table");

        if(!checkACL("contratencours")){
        $(".menu-popup").popup("open");
        evt.preventDefault();
        }else{
        bzLoaderShow();
        }

        if(el.attr("gainp") && parseInt(el.attr("gainp")<=0)){
        alert("Le gain potentiel est nul, vous ne pouvez pas bloquer ce contrat.")
        bzLoaderHide();
        $(".offline").css("display","none");
        return false;
        }



        if(parseInt(el.attr("pxech"))<=0  && parseInt($(el).attr("pxnet"))<=0 ){
        alert("Le marché n'est pas ouvert");
        bzLoaderHide();
        $(".offline").css("display","none");
        return false;
        }

        var myDate=new Date();
        var heure=myDate.getHours();
        var minutes=myDate.getMinutes();
        var nowHours=myDate.setHours(heure,minutes,0,0);
        var dateUp=new Date();
        var dateDown=new Date();

        var upHours=dateUp.setHours(18,00,0,0);
        var downHours=dateDown.setHours(11,00,0,0);

        if(nowHours<downHours || nowHours>upHours){
        alert("Le marché n'est pas ouvert")
        return false;
        }



        paramCtBloq={"idct":$(el).attr("idct"),
        "idchb":$(el).attr("idchb"),
        "pxech":el.attr("pxech"),
        "pxnet":$(el).attr("pxnet"),
        "qt":$(el).attr("qtha"),
        "titre":$(el).attr("titre"),
        "produit":$(el).attr("produit"),
        "qtmini":$(el).attr("qtmini"),
        "recap":el.html()
        }

        formTimeOut=setTimeout(function(){

        //clear time out
        clearTimeout(formTimeOut);

        alert("Vous avez dépassé les 2 minutes pour finaliser votre commercialisation. Nous devons réactualiser les prix du marché.");

        $.mobile.changePage("/mtransaction/contratsencours/format/html");


        },120000);                


        $.mobile.changePage("/mtransaction/cttolocksurf/format/html");
        // 2mn max to market




        })
        }


        loadListct(); 











        function timingBloc(){
        timingBloc=setInterval(function(){
        var $popUp = $('<div data-role="popup" class="popup-actu-cts" class="matif-popup"><div><span>Actualisation des contrats.</span></div></div>').popup({
        })

        $popUp.popup("open");

        loadListct();
        },30000);
        }

        timingBloc();

    </script>
</div><!-- /page -->









