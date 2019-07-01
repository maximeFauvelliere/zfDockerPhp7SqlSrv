<div  data-role="page" id="cttolocksurf"><!-- blocage contrats surf qt-->
    <div data-role="popup" id="menu-popup"  class='ui-content-menu-popup menu-popup' data-theme="b">
        Vous n'avez pas accès à cette rubrique.
    </div>
    <div data-role="header" data-position="fixed" data-tap-toggle="false">
        <div data-role="panel" id="bz-menu" class="bzmenu"  data-display="overlay" data-position="right" data-theme="b" data-close="" > 
            <div class="bz-menu-html">

            </div>
        </div><!-- fin panel menu-->
        <div class="header-item header-left"><a href="#" data-rel="back"><img src="/mobiles/css/img/pictos/back.min.svg" width="30"/></a></div>
        <div class="header-item header-center"><a href="/maccueil/index/format/html"><img src="/mobiles/css/img/pictos/ebz.min2.svg" width="80"/></a></div>
        <div class="header-item header-right"><a href="#bz-menu" ><img src="/mobiles/css/img/pictos/menu.min.svg" width="30"/></a></div>
        <div class="bt-aide" ></div>                 <div class="offline" style="display:none;">Vous êtes hors réseaux, les données affichées ne sont pas à jour, vous n'avez pas accés à la commercialisation.</div>
    </div><!-- /header -->
    <div class="clear"></div>

    <div data-role="content" >
        <div class="header-content">

        </div>
        <h6 id="titre-bloc-chx-qtha" class="header-content header-block header-block-ct"></h6>
        <div class="block-ct">
            <h2><span id="titre-qtha"></span></h2>
            <span id="line-qt-mini">*Minimum engagement pour cette culture :<span id="b-qtmini"></span></span>
            <div>
                <div style="width:70%;margin:auto;"><input data-clear-btn="false" name="qt" id="qt-to-lock" value="" type="number"></div>
            </div>


        </div>
    </div>
    <div class="footer" data-role="footer" data-position="fixed" data-tap-toggle="false">
        <div class="ui-grid-b nav-sous">                         <div data-role="popup" id="popup-help-acc" class="bzpopup overlay" data-corners="false" data-theme="d" data-overlay-theme="d" data-shadow="false" data-tolerance="0,0">                     <input type="button" class='bt-close-help' value="fermer l'aide" data-theme="d"/>                     <div class='wrapper-help-anime'>                     <div class="wrapper-aide"><img id="img-aide" src="/mobiles/css/img/aide/aide1.png"/></div>                 </div>                              </div>
            <div class="ui-block-a"><a href="" data-rel="back" data-role="button" data-theme="d" >Retour</a></div>
            <div class="ui-block-b"><a href="/mtransaction/contratsencours/format/html" data-role="button" data-theme="d">Annuler</a></div>
            <div class="ui-block-c"><a href="/mtransaction/cttolockvalid/format/html" id="bt-qt-to-bloc" data-role="button" data-theme="d">Suivant</a></div>
        </div>

    </div><!-- /footer -->
    <script>

        $(".bz-menu-html").html(menu);
        bindMenuClick();
        $(".menu-popup").trigger("create");
        $("#titre-bloc-chx-qtha").text(paramCtBloq['titre']);
        if(paramCtBloq['qt'].match("t")){
        $("#titre-qtha").text("Quantité à bloquer(t)");
        }else{
        $("#titre-qtha").text("Surface à bloquer(ha)");
        }
        $("#b-qtmini").text(paramCtBloq['qtmini']);
        $("#qt-to-lock").val(parseFloat(paramCtBloq['qt']));
        $("#bt-qt-to-bloc").click(function(){
        if(!onLine){
        $(".offline").css("display","block");
        return false;
        }else{
        $(".offline").css("display","none");
        }
        if(!$.isNumeric($("#qt-to-lock").val())){
        alert("Vous devez entrer une valeur numerique.")
        return false;
        }else if($("#qt-to-lock").val()==""){
        alert("Vous devez entrer une valeur numerique.")
        return false;    
        }else if(parseFloat($("#qt-to-lock").val())<parseFloat(paramCtBloq['qtmini'])){
        alert("Quantité ou surface insuffisante, minimum : "+paramCtBloq['qtmini'])
        return false;    
        }
        // record val
        paramCtBloq['qt']=$("#qt-to-lock").val();
        })

    </script>

</div><!-- /page -->
