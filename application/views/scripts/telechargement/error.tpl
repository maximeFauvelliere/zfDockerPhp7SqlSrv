

<div  style="width:100%;padding-top: 50px">
    <h4><{$this->msg}></h4>
</div>

<div style="width:100%;text-align: center">
    <input id="btretour" type="button" value="Retour accueil"/>
</div>


<script>
    
    $("#maskAcc").css("display","none");
    $("#preloader").css("display","none");
    
    
     //sub title
    $("#suTitreNav").text("");
    $("#titreNav").text("Erreur");
   
    $("#btretour").click(function(){
        //probleme de gestion de reotur en ajax , peut etre solution avec iframe pour telechargement
        //location.hash="<{$this->controller}>_<{$this->action}>";
        location.href="/";
    });
    
    
</script>    