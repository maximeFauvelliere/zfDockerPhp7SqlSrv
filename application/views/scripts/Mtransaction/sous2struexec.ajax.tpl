
<div  data-role="page" id="sous-stru-exec"><!-- souscription choix structure-->
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

        <script id="sous2TPL" type="text/x-handlebars-template">
            <div class="header-content">
            {{titre}}
            </div>
            <div class="list-offre-comm">{{datasous.txtbase}}</div>
            <h3 class="header-content header-block header-block-ct">{{datasous.soustitre}}</h3>
            <div class="block-ct">
            <h2><span class="ico-custom-ebz ico-titre-ebz ico-custom-{{datasous.produit}}"></span></h2>
            <div class="ui-field-contain">
            <label>Structures</label>
            <select name="structures" id="structures">
            {{#bzeach datasous.structures.structure}}
            <option value="{{idti}}"  {{#ifchecked checked}}selected="selected"{{/ifchecked}} >{{denom}}{{nom}}</option>
            {{/bzeach}}
            </select>
            </div>

            </div>
        </script>

        <div id="wrapper-sous2TPL">

        </div>
        <div class="ui-field-contain">
            <label>Executions</label>
            <select name="execution" id="executions">
                <optgroup id="depFerme" label="DEPART FERME">

                </optgroup>
                <optgroup id="renduSilo" label="RENDU SILO">

                </optgroup>
            </select>
        </div>
    </div>
    <div class="footer" data-role="footer" data-position="fixed" data-tap-toggle="false">
        <div class="ui-grid-b nav-sous">                         <div data-role="popup" id="popup-help-acc" class="bzpopup overlay" data-corners="false" data-theme="d" data-overlay-theme="d" data-shadow="false" data-tolerance="0,0">                     <input type="button" class='bt-close-help' value="fermer l'aide" data-theme="d"/>                     <div class='wrapper-help-anime'>                     <div class="wrapper-aide"><img id="img-aide" src="/mobiles/css/img/aide/aide1.png"/></div>                 </div>                              </div>
            <div class="ui-block-a"><a href="" data-rel="back" data-role="button" data-theme="d" >Retour</a></div>
            <div class="ui-block-b"><a href="/mtransaction/offres/format/html" data-role="button" data-theme="d">Annuler</a></div>
            <div class="ui-block-c"><a id="valid-etape2" href="" data-role="button" data-theme="d">Suivant</a></div>
        </div>
        <script>
            $(".bz-menu-html").html(menu);
            bindMenuClick();
            $(".menu-popup").trigger("create");
            var dataSous="";

            //parse le retour de la base pour condition
            Handlebars.registerHelper("ifchecked",function(condition,options) {

            condition=parseInt(condition);
            if(condition){
            return options.fn(this);
            }

            });



            var filter=getFilter(JSON.parse(localStorage.filter));
            $(".ui-loader").css("display","block")
            $.ajax({
            url: "/mtransaction/sous2struexec/format/json",
            data: {filter:filter,"pdt":produit,"idwo":idWo},
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

            //myConvert(data);
            dataSous={"datasous":data};

            if(qtMini)dataSous.datasous.mini=qtMini;
            //console.log("data from sous2",dataSous)
            //init idwos
            idWos=dataSous.datasous.idsous;

            /*var template = $('#sous2TPL').html();
            var html = Handlebars.compile(template);
            var result = html(dataSous);*/
            try{ var template=Handlebars.templates['sous2'];
            var result = template(dataSous);
            $('#wrapper-sous2TPL').html(result); }catch(error){}

            $("#structures").selectmenu();

            var selectedStru= $( "#structures option:selected").val();
            ////console.log("selectedStru",selectedStru)
            fillExec(selectedStru);
            //bind change on structure build exec
            $( "#structures").on("change",function(e){fillExec(selectedStru)})

            //$('#structures').selectmenu( "refresh", true );





            //$(".offres-listview").trigger("create");


            },

            error: function(a,b,c) {
            console.log(a);
            console.log(b);
            console.log(c);
            ajaxError(a.status,b);;

            }
            })     

            //gestion des selects

            function fillExec(idStru){

            var optionFerme=$("#depFerme");
            var optionSilo=$("#renduSilo");

            //init
            optionFerme.empty();

            var index=$("#structures")[0].selectedIndex;
            ////console.log("index",index)
            ////console.log("datasous 2",dataSous)
            var structures=convertElementToArray(dataSous.datasous.structures.structure);

            var exec=convertElementToArray(structures[index].execution);

            ////console.log("exec",exec);

            //depart ferme 
            $.each(exec,function(i,e){

            var selected=(parseInt(e.checked))?"selected=selected ":" ";
            optionFerme.append('<option '+selected +' value="'+e.idex+'" >'+e.adr1+' '+e.adr2+' '+e.ville+'</option>')

            })


            //rendu silo
            // si, le rendu silo est déjà charger on zappe
            if(optionSilo.children().length==0){
            var rendusilo=convertElementToArray(dataSous.datasous.silos.silo);
            $.each(rendusilo,function(i,e){

            var selected=(parseInt(e.checked))?"selected=selected ":" ";
            optionSilo.append('<option class="silo" '+selected +' value="'+e.idsilo+'" >'+e.nom+'</option>');

            })

            }

            $("#executions").trigger("change");



            }

            //init variable de l'etape 2 a retourner apres l'etape 3
            var structuresSelected="";
            var executionsSelected="";
            var siloSelected="";
            $("#valid-etape2").click(function(){
            if(!onLine){
            $(".offline").css("display","block");
            return false;
            }else{
            $(".offline").css("display","none");
            }
            //init var
            structuresSelected="";
            executionsSelected="";
            siloSelected="";

            structuresSelected=$( "#structures option:selected").val();

            if($( "#executions option:selected").hasClass("silo")){
            siloSelected=$( "#executions option:selected").val();
            }else{
            executionsSelected=$( "#executions option:selected").val();
            }

            //console.log("structuresSelected : ",structuresSelected);
            //console.log("execution selected :",executionsSelected);
            //console.log("siloselected ",siloSelected);

            $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sous3peridate/format/html");
            return false;

            })

            $('.nav-sous a').off("tap",function(e){
            $(e.currentTarget).removeClass("ui-btn-active");
            }).on("tap",function(e){
            $(e.currentTarget).addClass("ui-btn-active");
            })
        </script>
    </div><!-- /footer -->
</div><!-- /page -->
