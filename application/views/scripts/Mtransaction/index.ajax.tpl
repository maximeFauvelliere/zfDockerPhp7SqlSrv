
<div  data-role="page" id="transaction"><!-- transaction-->
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
        <div class="header-content header-content-camp"> </div>
        <script id="transactionTPL" type="text/x-handlebars-template">
            <div>
            <h3 class="header-content header-block header-block-ct">
            TRANSACTION
            </h3>
            {{#if transactions.structures}}
            {{#bzeach transactions.structures.element }}
            <div class="block-hor-layout">
            <h2>{{nom}}</h2>
            <table idti="{{idti}}" class="transaction-list">
            <thead>
            <tr>
            <th >Culture</th>
            <th>Qté</th>
            <th>Surf</th>
            <th>Prix</th>
            <th>Tx d'eng</th>
            </tr>
            </thead>
            <tbody>
            {{#bzeach transactions.element}}
            <tr idcu={{idcu}}>
            <td>{{culture}}</td>
            <td>{{qte}}</td>
            <td>{{surf}}</td>
            <td>{{prix}}</td>
            <td>{{txengage}}</td>
            </tr>
            {{/bzeach}}
            </tbody>
            </table>

            </div>
            {{/bzeach}}
            {{else}}
            Il n'y a pas de données à afficher.
            {{/if}}
            </div>
        </script>

        <div id="wrapper-transactionTPL"></div>

    </div>
    <div class="footer" id="footer-tran" data-role="footer" data-position="fixed" data-tap-toggle="false">

    </div><!-- /footer -->
    <script>
        $("#footer-tran").html(footer);
        templateRenderFilter(JSON.parse(localStorage.filter))
        $(".bz-menu-html").html(menu);
        bindMenuClick();
        $(".menu-popup").trigger("create");

        function loadTran(){
        var filter=getFilter(JSON.parse(localStorage.filter));
        $(".ui-loader").css("display","block")
        $.ajax({
        url: "/mtransaction/transaction/format/json",
        data: {filter:filter},
        type: "POST",
        dataType: "json",
        success: function(data) {
        $(".ui-loader").css("display","none")
        if(data.success=="error"){
        if(data.type=="timeout"){
        timeOut(data.type);
        loadTran();
        return;
        }else{
        alert("Une erreur s'est produite, vous allez être redirigé.")
        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index");
        return;
        }

        }
        data["lastCall"]=new Date().getTime();
        localStorage.tran =JSON.stringify(data);
        //console.log("data transaction",data)
        templateRenderTran(data);
        },

        error: function(a,b,c) {
        console.log(a);
        console.log(b);
        console.log(c);
        ajaxError(a.status,b);;

        }
        })
        }

        function templateRenderTran(data){
        /*var template = $('#transactionTPL').html();
        var html = Handlebars.compile(template);
        var result = html(data);*/
        try{ var template=Handlebars.templates['transaction'];
        var result = template(data);
        $('#wrapper-transactionTPL').html(result); }catch(error){}

        $(".transaction-list tr").click(function(e) {
        var idTi =$(e.currentTarget).parent().parent().attr("idti");
        var idCu=$(e.currentTarget).attr("idcu");

        clickTransactionList(idTi,idCu);
        })

        }

        function initTran(){

        if(localStorage.tran ){

        //console.log("local storage tran")
        var data=JSON.parse(localStorage.tran);
        var lastCall=data.lastCall;
        if((new Date().getTime()-lastCall>maxLife) && onLine){
        //console.log("delais depassé");
        loadTran();
        }else{
        //console.log("dans le delais ou offLine")
        templateRenderTran(data)
        }
        }else{
        //on charge les donnée
        //console.log("tran n'exite pas")                          
        loadTran(); 
        }  
        }


        initTran();

        /**
        * click ligne transaction pour detail
        *
        **/
        function clickTransactionList(idTi,idCu) {

        //call liste detail des transaction list contrats
        $(".ui-loader").css("display","block")
        var filter=getFilter(JSON.parse(localStorage.filter));
        $.ajax({
        url: "/mtransaction/transactiondetail/format/json",
        data: {filter:filter,"idti":idTi,"idcu":idCu},
        type: "POST",
        dataType: "json",
        success: function(data) {
        if(data.success=="error"){
        if(data.type=="timeout"){
        timeOut(data.type);
        loadTran();
        return;
        }else{
        alert("Une erreur s'est produite, vous allez être redirigé.")
        $( ":mobile-pagecontainer" ).pagecontainer( "change","/mindex/index");
        return;
        }

        }
        $(".ui-loader").css("display","none")
        //console.log("data transaction-detail",data)
        var $popUp = $('<div data-role="popup" class="popup-list"><a href="#" data-rel="back" data-role="button" data-theme="c"  data-iconpos="notext" class="ui-btn-right">X</a></div>').popup({
        }).bind("popupafterclose", function() {
        //remove the popup when closing
        $(this).remove();
        });

        var $popupHeader = $('<h3><span>LISTE CONTRATS</span><br/><span>'+data.nom+'</span><br/><span>'+data.culture+'</span></h3>');
        $popUp.append($popupHeader);

        var contrats=convertElementToArray(data.contrats.element);
        var tbody="";
        $.each(contrats,function(i,e){
        tbody+="<tr><td>"+e.numct+"</td><td>"+e.type+"</td><td>"+e.qtesurf+"</td><td>"+e.pxbase+"</td></tr>";
        })

        var $content = $('<div class="block-hor-layout transaction-detail"><table><thead><th>N°CT</th><th>Type</th><th>Qté/Surf</th><th>Prix/Base</th></thead><tbody></tbody></table></div>');
        $content.find("tbody").append(tbody);
        $popUp.append($content);
        $popUp.popup("open");

        },

        error: function(a,b,c) {
        console.log(a);
        console.log(b);
        console.log(c);
        ajaxError(a.status,b);;

        }

        })
        }


        $("#transaction").on("filterReady",function(){
        deleteLocalStorageData();
        initTran();
        $(".ui-loader").css("display","none");
        })
        $(".ui-loader").css("display","none");          

    </script>
</div><!-- /page -->
