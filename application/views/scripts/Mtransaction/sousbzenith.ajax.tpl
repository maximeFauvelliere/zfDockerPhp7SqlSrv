
<div  data-role="page" id="sous-bzenith"><!-- page souscription-->
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

        <h3 class="header-content header-block header-block-ct">Offre B-Zenith</h3>
        <div class="block-ct">
            <h2><span class="ico-custom-ebz ico-titre-ebz ico-custom-bzenith"></span></h2>
            <div id="wrapper-form">
                <label>Prix d'objectif</label>
                <input id="bzenith-pxobjectif" type="number"></input>
                <label>fin du B-Zenith (6 mois maximum)</label>
                <label>Choix date</label>
                <input id="bzenithdatepicker" type="date" min="2013-10-01" max="2013-10-20" class="date-input" data-inline="false"></input>
                <label>Choix heure</label>
                <select name="choixheure" disabled="disabled" id="choix-heure">          

                </select>

            </div>
        </div>
    </div>
    <div class="footer" data-role="footer" data-position="fixed" data-tap-toggle="false">
        <div class="ui-grid-b nav-sous">                         <div data-role="popup" id="popup-help-acc" class="bzpopup overlay" data-corners="false" data-theme="d" data-overlay-theme="d" data-shadow="false" data-tolerance="0,0">                     <input type="button" class='bt-close-help' value="fermer l'aide" data-theme="d"/>                     <div class='wrapper-help-anime'>                     <div class="wrapper-aide"><img id="img-aide" src="/mobiles/css/img/aide/aide1.png"/></div>                 </div>                              </div>
            <div class="ui-block-a"><a href="" data-rel="back" data-role="button" data-theme="d">Retour</a></div>
            <div class="ui-block-b"><a href="/mtransaction/offres/format/html" data-role="button" data-theme="d">Annuler</a></div>
            <div class="ui-block-c"><a id="bt-bzenith" href="" data-role="button" data-theme="d">Suivant</a></div>
        </div>
        <script>
            $(".bz-menu-html").html(menu);
            bindMenuClick();
            $(".menu-popup").trigger("create");
            var pxObjectif="";
            var dateHeure="";

            //min
            /*var today=new Date();
            $( "#bzenithdatepicker" ).attr("min",today);
            $( "#bzenithdatepicker" ).attr("max",new Date(today.setMonth(today.getMonth()+6)))*/

            $('#bzenithdatepicker').change(function(){
            //console.log("date picker change")
            if($('#bzenithdatepicker').val()=="") return false;
            var today=new Date();
            var maxDate=new Date(today.setMonth(today.getMonth()+6));
            //console.log("today",today)
            ////console.log("selected date",new Date($('#bzenithdatepicker').val()));
            ////console.log("+6",new Date(today.setMonth(today.getMonth()+6)))
            if(new Date($('#bzenithdatepicker').val())>maxDate){

            var d=maxDate.getDate()<10?d="0"+maxDate.getDate():d=maxDate.getDate();
            var m=maxDate.getMonth()<10?m="0"+(maxDate.getMonth()+1):m=(maxDate.getMonth()+1);

            $('#bzenithdatepicker').val(maxDate.getFullYear()+"-"+m+"-"+d);

            }
            if(new Date($('#bzenithdatepicker').val())<new Date()){

            var a=new Date();
            var d= a.getDate()<10?d="0"+a.getDate():d=a.getDate();
            var m=a.getMonth()<10?m="0"+(a.getMonth()+1):m=(a.getMonth()+1);
            $('#bzenithdatepicker').val(a.getFullYear()+"-"+m+"-"+d);

            }
            setTimeout(function(){

            //verifie date
            var d=new Date($( "#bzenithdatepicker" ).val());
            var b=new Date();
            //create select

            $("#choix-heure").empty();
            //console.log("date jour b", b.toLocaleDateString())
            //console.log("date jour d", d.toLocaleDateString())
            //console.log("text date",d.toLocaleDateString()===b.toLocaleDateString())
            if(d.toLocaleDateString()===b.toLocaleDateString()){

            var hourNow=b.getHours();
            for(var i=11;i<=18;i++){
            if(i<=hourNow ){
            continue;
            }
            $("#choix-heure").append("<option value='"+i+":00' >"+i+":00 </option>");
            }
            }else{

            for(var i=11;i<=18;i++){
            $("#choix-heure").append("<option value='"+i+":00' >"+i+":00 </option>");
            }

            }

            $("#choix-heure").removeAttr("disabled");
            $("#choix-heure").trigger("create");
            $( "#choix-heure" ).selectmenu( "enable" );
            $( "#choix-heure" ).selectmenu( "refresh" );

            },200)


            })


            $("#bt-bzenith").click(function(){

            if(!onLine){
            $(".offline").css("display","block");
            return false;
            }else{
            $(".offline").css("display","none");
            }
            //check
            if(isNaN(parseInt($("#bzenith-pxobjectif").val()))){
            alert("Vous devez entrer un prix d'objectif.")
            return false;
            }else if($("#bzenithdatepicker").val()==""){
            alert("Vous devez entrer une date.")
            return false;
            }

            pxObjectif=$("#bzenith-pxobjectif").val();
            var a=new Date($("#bzenithdatepicker").val());
            dateHeure=a.getDate()+"/"+(a.getMonth()+1)+"/"+a.getFullYear()+" "+$("#choix-heure option:selected").text();


            //all data to send 
            var dataToSend={
            "pxobjectif":pxObjectif,
            "dateheure":dateHeure,
            "idwo":idWo,
            "idwos":idWos,
            "pdt":produit
            }
            $(".ui-loader").css("display","block")
            $.ajax({
            url: "/mtransaction/sousbzenith/format/json",
            data: {"pdt":produit,"params":dataToSend,"set":true},
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
            $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sousbzenithrecap/format/html");
            }
            },
            error:function(a,b,c){
            ajaxError(a.status,b);;
            }
            })

            return false;

            })

            $("#bzenithdatepicker").on("tap",function(evt){
            $(".footer").css("display","none");

            })

            $("#bzenithdatepicker").on("blur",function(){
            $(".footer").css("display","block");
            });

            $('.nav-sous a').off("tap",function(e){
            $(e.currentTarget).removeClass("ui-btn-active");
            }).on("tap",function(e){
            $(e.currentTarget).addClass("ui-btn-active");
            })



        </script>

    </div><!-- /footer -->
</div><!-- /page -->
