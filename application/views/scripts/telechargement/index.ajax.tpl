<div id="resultDonwloadError" style="width:600px;margin:auto">
    <p style="font-size: 12pt;color:red">Ce document n'est pas encore téléchargeable, son traitement est en cours.</br>Veuillez essayer ultérieurement.</p>
    <input id="btRetour" type="button" value="retour"/>
    <script>
        // change controller sinon location.hash pas declenchée
        
        $(document).ready(function(){
            
            $("#preloader").css("display","none");
            $("#btRetour").click(function(){
            alert("retour")
                //location.hash="<{$this->url}>";

                //$(window).trigger("hashchange");
                return false;
            })
        })

    </script>