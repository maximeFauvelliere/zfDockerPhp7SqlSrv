
<div data-role="page" id="offres">

    <div data-role="panel" id="bz-filter" data-display="overlay">
        <div  class="wrapper-filterTPL"></div>
        <script id="filterTPL" type="text/x-handlebars-template">
            <div  class="D-filter" >

            <div id="T_camp" class="T_F"><span>CAMPAGNES</span></div>
            <div id="F_camp">
            {{#each filtre.campagnes.element}}
            <input class="filterInput" type="radio" name="camp" {{#bzIf checked "1"}}checked="checked"{{/bzIf}} id="ca{{@index}}" idcamp="{{idcamp}}"/>
            <label  for="ca{{@index}}">{{camp}}</label>
            {{/each}}  
            </div>
            <div id="T_cult" class="T_F"><span>CULTURES</span></div>
            <div id="F_cult">
            {{#each filtre.cultures.element}}
            <label  for="c{{@index}}">{{nom}}</label>
            <input class="filterInput" idcu="{{idcu}}" {{#bzIf checked "1"}}checked="checked"{{/bzIf}} type="checkbox" name='cultures' id='c{{@index}}'/>
            {{/each}}
            </div>
            <div id="T_st" class="T_F"><span>STRUCTURES</span></div>
            <div id="F_struct">
            {{#each filtre.structures.element}}
            <label  for="s{{@index}}">{{nom}}</label>
            <input class="filterInput" type="checkbox" idti="{{idti}}" {{#bzIf checked "1"}}checked="checked"{{/bzIf}} name='structures' id='s{{@index}}' /> 
            {{/each}}
            </div>


            </div>
        </script>
    </div>
    <div data-role="popup" id="menu-popup"  class='ui-content-menu-popup menu-popup' data-theme="b">
        Vous n'avez pas accès à cette rubrique.
    </div>
    <div data-role="header" data-position="fixed" data-tap-toggle="false">
        <div data-role="panel" id="bz-menu" class="bzmenu"  class="bztest" data-display="overlay" data-position="right" data-theme="b" data-close="" > 
            <div class="bz-menu-html">

            </div>
        </div><!-- fin panel menu-->
        <div class="header-item header-left"><a href="#" data-rel="back"><img src="/mobiles/css/img/pictos/back.min.svg" width="30"/></a></div>
        <div class="header-item header-center"><a href="/maccueil/index/format/html" ><img src="/mobiles/css/img/pictos/ebz.min2.svg" width="80"/></a></div>
        <div class="header-item header-right"><a href="#bz-menu" ><img src="/mobiles/css/img/pictos/menu.min.svg" width="30"/></a></div>
        <div class="bt-aide" ></div>                 <div class="offline" style="display:none;">Vous êtes hors réseaux, les données affichées ne sont pas à jour, vous n'avez pas accés à la commercialisation.</div>
    </div><!-- /header -->
    <div class="clear"></div>
    <div data-role="content" >

        <script  id="offresTPL" type="text/x-handlebars-template">
            <div class="header-content">
            {{offres.camp}}
            </div>
            <div class="list-offre-comm">{{offres.txtbase}}</div>
            <ul class="offres-listview" data-role="listview" data-inset="true" data-theme="c">
            {{#each offres.cultures.element}}
            <li data-role="list-divider">{{nom}}</li>
            {{#eachoffre offres.element}}
            <li><a class="offre-detail" href="/mtransaction/offredetail/format/html" {{#if idoffre}}idoffre="{{idoffre}}"{{else}}idopti="{{idopti}}"{{/if}} produit="{{produit}}"> <span class="ico-custom-ebz ico-custom-{{produit}}"></span><span class="list-view-txt-center"> {{matif}}</span><span class="fixation">{{base}}</span></a></li>
            {{/eachoffre}}
            {{/each}}


            </ul>
        </script>
        <div id="wrapper-offresTPL"></div>
    </div><!-- /content -->

    <div class="footer" id="footer-offres" data-role="footer" data-position="fixed" data-tap-toggle="false">

    </div><!-- /footer -->
    <script>

        $("#footer-offres").html(footer);
        templateRenderFilter(JSON.parse(localStorage.filter))
        $(".bz-menu-html").html(menu);
        bindMenuClick();
        $(".menu-popup").trigger("create");
        $(".bt-offre").addClass("bt-menu-bas-actif");                

        //init var 
        var dataOptimizSecuriz="";
        var titre="";
        var txtBase="";
        var sousTitre="";
        var produit="";
        var idWo="";
        var idWos="";

        if(localStorage.offres ){
        //console.log("local storage offres")
        var data=JSON.parse(localStorage.offres);
        var lastCall=data.lastCall;
        if((new Date().getTime()-lastCall>maxLife) && onLine){
        //console.log("delais depassé");
        getOffres();
        }else{
        //console.log("dans le delais ou offLine")
        templateRenderOffres(data)
        }
        }else{
        //on charge les donnée
        //console.log("offres n'exite pas")                          
        getOffres(); 
        }

        function getOffres(){
        //console.log("get offres")
        //$(".ui-loader").css("display","block")
        $(".ui-loader").css("display","block")
        var filter=getFilter(JSON.parse(localStorage.filter));
        $.ajax({
        url: "/mtransaction/offres/format/json",
        data: {filter:filter},
        type: "POST",
        dataType: "json",
        success: function(data) {
        if(data.success=="error"){
        if(data.type=="timeout"){
        timeOut(data.type);
        getOffres()
        return;
        }else{
        alert("Une erreur s'est produite, vous allez être redirigé.")
        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index");
        return;
        }

        }
        $(".ui-loader").css("display","none")
        myConvert(data);
        console.log("data offres",data);
        data["lastCall"]=new Date().getTime();
        localStorage.offres =JSON.stringify(data);
        templateRenderOffres(data);
        },

        error: function(a,b,c) {
        console.log(a);
        console.log(b);
        console.log(c);
        ajaxError(a.status,b);;

        }
        })
        }

        getOffres();


        function templateRenderOffres(data){
        //console.log("render offre")
        /*var template = $('#offresTPL').html();
        var html = Handlebars.compile(template);
        var result = html(data);*/
        try{ var template=Handlebars.templates['offres'];
        var result = template(data);
        $('#wrapper-offresTPL').html(result); }catch(error){}

        $(".offres-listview").listview();
        $(".offre-detail").click(function(e){

        produit=$(e.currentTarget).attr("produit");
        idWo=$(e.currentTarget).attr("idoffre");
        idWoHb=$(e.currentTarget).attr("idopti");
        })

        }


        $("#offres").on("filterReady",function(){
        deleteLocalStorageData();
        getOffres();
        $(".ui-loader").css("display","none");
        })

        bzLoaderHide();
    </script>
</div><!-- /page -->



