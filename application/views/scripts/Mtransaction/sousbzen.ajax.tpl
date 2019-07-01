
<div  data-role="page" id="sous-bzen"><!-- page souscription-->
    <div data-role="header" data-position="fixed" data-tap-toggle="false">
        <div data-role="panel" id="bz-menu" class="bzmenu"  data-display="overlay" data-position="right" data-theme="b" data-close="" > 
            <div class="bz-menu-html">

            </div>
        </div><!-- fin panel menu-->
        <div class="header-item header-left"><a href="#" data-rel="back"><img src="/mobiles/css/img/pictos/back.min.svg" width="30"/></a></div>
        <div class="header-item header-center"><a class="bt-acc"  href="/maccueil/index/format/html"><img src="/mobiles/css/img/pictos/ebz.min2.svg" width="80"/></a></div>
        <div class="header-item header-right"><a href="#bz-menu" ><img src="/mobiles/css/img/pictos/menu.min.svg" width="30"/></a></div>
    </div><!-- /header -->
    <div class="clear"></div>

    <div data-role="content" >
        <script id="sous1TPL" type="text/x-handlebars-template">
            <div class="header-content">
            {{sous1.titre}}
            </div>
            <div class="list-offre-comm">{{sous1.txtbase}}</div>
            <h3 class="header-content header-block header-block-ct">{{sous1.soustitre}}</h3>
            <div class="block-ct">
            <h2><span class="ico-custom-ebz ico-titre-ebz ico-custom-{{sous1.produit}}"></span></h2>
            <table>
            <tbody>
            {{#bzeach sous1.lignes.element}}
            <tr>
            <td>{{lib}}</td>
            <td>{{val}}</td>
            </tr>
            {{/bzeach}}
            </tbody>
            </table>
            </div>
        </script>
        <div id="wrapper-sous1TPL">
        </div>
    </div>
    <div class="footer" data-role="footer" data-position="fixed" data-tap-toggle="false">
        <div class="ui-grid-b nav-sous">                         <div data-role="popup" id="popup-help-acc" class="bzpopup overlay" data-corners="false" data-theme="d" data-overlay-theme="d" data-shadow="false" data-tolerance="0,0">                     <input type="button" class='bt-close-help' value="fermer l'aide" data-theme="d"/>                     <div class='wrapper-help-anime'>                     <div class="wrapper-aide"><img id="img-aide" src="/mobiles/css/img/aide/aide1.png"/></div>                 </div>                              </div>
            <div class="ui-block-a"><a href="" data-rel="back" data-role="button" data-theme="d">Retour</a></div>
            <div class="ui-block-b"><a href="/mtransaction/offres/format/html" data-role="button" data-theme="d">Annuler</a></div>
            <div class="ui-block-c"><a id="bt-bzen" href="" data-role="button" data-theme="d">Engager</a></div>
        </div>
        <script>

            $(".bz-menu-html").html(menu);
            bindMenuClick();
            $(".menu-popup").trigger("create");

            //--------------------template-------------------------------------


            var filter=getFilter(JSON.parse(localStorage.filter));
            $.ajax({
            url: "/mtransaction/sous6recap/format/json",
            data: {filter:filter,"pdt":produit,"idwo":idWo},
            type: "POST",
            dataType: "json",
            success: function(data) {

            //convert tab 
            //myConvert(data);
            //console.log("data sous1",data)
            titre=data.sous1.titre;
            txtBase=data.sous1.txtbase;
            sousTitre=data.sous1.soustitre;
            produit=data.sous1.produit;

            var template = $('#sous1TPL').html();
            var html = Handlebars.compile(template);
            var result = html(data);
            $('#wrapper-sous1TPL').html(result);






            },
            error: function(a, b, c) {
            console.log(a);
            console.log(b);
            console.log(c);
            }
            }) 

            var pobs=""

            $("#bt-bzen").click(function(){
            pobs=
            $(":mobile-pagecontainer").pagecontainer("change", "/mtransaction/sous2struexec/format/html");
            })


        </script>

    </div><!-- /footer -->
</div><!-- /page -->
