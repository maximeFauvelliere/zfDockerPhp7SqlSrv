<{$this->doctype()}>
<html>
<{$this->headMeta()->setCharset('UTF-8')}>
<{$this->headLink()->appendStylesheet('/styles/basic.css')}>
<{$this->headScript()->appendFile('/javascript/library/jquery1.7.2.js')}>


<body>
    <div id="header">
    <{$this->render('header.tpl')}>
    </div>
    
    
    <div class="content">
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
