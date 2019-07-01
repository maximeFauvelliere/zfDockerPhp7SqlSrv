
<{if $this->message}>
<script>
    alert("<{$this->message}>");
</script>
<{/if}>



<div id="canvasCellFermes" style="width:310px;margin-left:250px">
</div>
<!--<a href="/prospection/addferme">add stock ferme</a>-->
<{if $this->btAnalyse}>
   
<!--        <a href="/Analysesattentes/analyses/format/json">bt analyse en attente</a>-->
        
           
<!--        <a id="btAnalAttente" href="#">Analyse(s) en attente</a>-->
<div id='wrapperNotifNbAnal' style="margin-left:190px;">
    <div id='pastilleAnal'><{$this->nbAnal}></div>
    <input id="btAnalAttente" style="float: left;margin-right: 35px;" type="button"  value="Analyse(s) en attente d'affectation"/>
    <input id="btStFerme" type="button"  value="Ajouter un lot de stock ferme"/>
</div>
       
         <script>
             var nbAnal=<{$this->nbAnal}>;
             if(!nbAnal){
                
                $("#btAnalAttente").attr("disabled","disabled");
             }
             $("#btAnalAttente").click(function(evt){
                _gaq.push(['_trackEvent', 'propsection', 'analyses en attente','bouton accueil prospect']);
                    location.hash="analysesattentes_analyses";
             })
                 
                
        </script>
        
<!--    </div>-->
<{/if}>
<div id="dialog"></div>





<!--affectation des data-->

<{if $this->data}>
 <script> 
 $(".navLeftMenu").css("display","none");
 var siloData=<{$this->data}>;

 var camp;
 
 </script>
 
 
<{/if}>

<!--<div id='btStFerme' class="bt">Ajouter du stock ferme</div>-->





<script>
    
    //clear function
    function makeDataGrid(){};
    
    controller="<{$this->controller}>";
    action="index";
    $("#titreNav").html('Prospection');
    $("#suTitreNav").empty();
    try{
         $("#D_filter").wijdialog({disabled: false});
         $("#maskAcc").remove();
    }catch(error){};
 
   //initialise
    var url;


    createSilo("canvasCellFermes","100%",410,70,70,92.655,277,"setGlobal",true,[siloData],true,"1_",true);
   
   
   $(document).ready(function() {
     
       $("#preloader").css("display","none");

        //add stock ferme  
        $("#btStFerme").click(function(e){
                        /*$.get("/prospection/addferme/format/html",function(data){
                            $("#main").empty();
                            $("#main").append(data);       
                        })*/
                        location.hash="prospection_addferme";
                  })      
        })

        //notifications analyses en attentes gérer dans prospection controller
        //$.ajax({
            //url:"/analysesattentes/notifications/format/html",
            //success:function(data){
               // $("#pastilleAnal").text(data);
            //}
       // })
       
     
//location.hash="index/index";
   
</script>
