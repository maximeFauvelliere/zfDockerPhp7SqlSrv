<{$this->doctype()}>
<html>
    <head>
    <{$this->headMeta()->setCharset('UTF-8')}>
    <{$this->headLink()->appendStylesheet('/styles/wijmo/css/jquery.wijmo-complete.all.2.3.9.min.css')
                  ->appendStylesheet('/styles/wijmo/css/jquery.wijmo-open.2.3.9.css')
                  ->appendStylesheet('/styles/IE8.css','all','IE 8')
                  ->appendStylesheet('/styles/bztheme/bztheme.css')
                  ->appendStylesheet('/styles/style.css')
                  ->appendStylesheet('/styles/basic.css')
                  ->appendStylesheet('https://fonts.googleapis.com/css?family=Abel')
                  ->appendStylesheet('https://fonts.googleapis.com/css?family=Ubuntu')
                  
                 
    }>
    
    <{$this->headScript()->appendFile('/javascript/library/jquery1.8.3.js')
                        ->appendFile('/javascript/library/jquery-ui-1.9.2.custom.min.js')
                        ->appendFile('/javascript/library/jquery.ba-hashchange.min.js')
                        ->appendFile('/javascript/library/wijmo/jquery.wijmo-open.all.2.3.9.min.js')
                        ->appendFile('/javascript/library/wijmo/jquery.wijmo-complete.all.2.3.9.min.js')
                        ->appendFile('/javascript/library/globalize.culture.fr-FR.js')
                        ->appendFile('/javascript/library/cellule.js')
                        ->appendFile('/javascript/library/S7_functions.js')
                        ->appendFile('/javascript/library/jqUITool.js')
                        ->appendFile('/javascript/library/init-layout.js')
                        ->appendFile('/javascript/library/menuSilo.js')
                        ->appendFile('/javascript/library/silo/accsilo.js')
                        ->appendFile('/javascript/library/silo/siloAccEvent.js')
                        ->appendFile('/javascript/library/highchart/highstock.js')
                        
    }>
    
        <script type="text/javascript">

          var _gaq = _gaq || [];
          _gaq.push(['_setAccount', 'UA-38085304-2']);
          _gaq.push(['_trackPageview','accueil']);
          (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
          })();
          
        </script>
    
    </head>
    <body>
   <!-- url du site pour js-->
    <script>
        baseUrl="<{$this->serverUrl()}>"
        var silo=null;
    </script>
        <{$this->render('header.tpl')}>

        <div id="c_left">
           
        </div>
        <!--main div-->
        <div id="preloader">Chargement en cours</div>
        <div id="main">
            <{$this->layout()->content}>
        </div>
        <div id="blockMentions" style="clear:both;text-align: center">
            <span style="width: 850px;">SAS Beuzelin 20 rue des Grès 27190 BEAUBRAY - Tél : 02 32 67 20 60 - Fax : 02 32 67 26 91 - Tous droits réservés - <a id="btmentions" href="#">Mentions légales</a> </span>
             <div id="mentions" style="display: none">
                Le présent site est la propriété de la SAS BEUZELIN, 20 rue des Grès 27190 BEAUBRAY, au capital de 3 300 000 euros, téléphone : 02 32 67 20 60 <br/>Inscrite au Registre du Commerce et des Sociétés d’EVREUX sous le n° B 342 153 996
<br/>Le responsable de la rédaction de ce présent site est M. BATANCOURT Benoît, Directeur Étude et Développement

<br/>L’hébergement de ce présent site est assuré par Orange 78 rue Olivier de Serres, 75505 PARIS cedex 15 Informations techniques<br/> Téléphone : +33 1 53 90 85 00

<br/>DROITS D’AUTEUR – COPYRIGHT L’ensemble de ce site relève de la législation française et internationale sur le droit d’auteur et la propriété intellectuelle.<br/> Tous les droits de reproduction sont réservés, y compris pour les documents téléchargeables et les représentations iconographiques et photographiques. La reproduction de tout ou partie de ce site sur un support électronique, quel qu’il soit, est formellement interdite sauf autorisation expresse du directeur de la publication.

            </div>
        </div>
        <script>
            $("#btmentions").click(function(){
                $("#mentions").slideToggle( "slow");
                return false;
                
                
            })
        </script>
    </body>

</html>

