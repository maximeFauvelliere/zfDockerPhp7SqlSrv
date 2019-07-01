<script>
     // collapse le filtre si besoin
    try{
        if($("#D_filter").css("display")=="block"){

                $("#D_filter").wijdialog("toggle");
        }
        
        $("#D_filter").wijdialog({disabled:true});
    }catch(error){}
</script>
<div id="info" class="trash">
    <iframe id="modalIframeId" width="100%" height="100%" marginWidth="0" marginHeight="0" frameBorder="0" scrolling="auto" src="<{$this->urlAide}>49" />
</div>

