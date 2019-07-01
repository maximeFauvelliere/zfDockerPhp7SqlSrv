<{$this->doctype()}>
<html>
    <head>
        <meta name="viewport" content="width=device-width,initial-scale=1.0"/> 
        <meta charset="UTF-8">
        <!--<meta http-equiv="Cache-Control" content="no-cache">
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv="Expires" content="0"> -->
        
        <!-- jquery --->
        <link rel="stylesheet" href="/mobiles/css/themes/themeEbzMobile.min.css" />
        <link rel="stylesheet" href="/mobiles/css/themes/jquery.mobile.icons.min.css" />
        <link rel="stylesheet" href="/mobiles/js/jquery.mobile.structure-1.4.2.min.css" />
        <!--style-->
        <link rel="stylesheet" href="/mobiles/css/style-m.css" />
        <!--custom theme-->

        <script src="/mobiles/js/jquery-1.10.2.min.js"></script>
        <!-- custom js -->
        <script src="/mobiles/js/jquery-ui-1.10.4.custom.min.js"></script>
        <script src="/mobiles/js/jquery.mobile-1.4.0.min.js"></script>
        <style>
            a:link,a:visited,a:hover,a:active{
                color:#000!important;
            }
        </style>
        



        
        

        <{$this->headScript()->appendFile('/javascript/library/forcepass.js')}>
        
        <script type="text/javascript">


        </script>
    </head>

<body>
    <div class="page">  
        <{$this->layout()->content}>
    </div>
   <div id="blockMentions" style="clear:both;left: center;font-size: 6pt;">
            <span>SAS Beuzelin 20 rue des Grès 27190 BEAUBRAY - Tél : 02 32 67 20 60 - Fax : 02 32 67 26 91 - Tous droits réservés - <a id="btmentions" href="#">Mentions légales</a> </span>
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

                                            