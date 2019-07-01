<script>
    //clear function
    $("#preloader").css("display","none");
    function makeDataGrid(){};
    controller="<{$this->controller}>";
    action="<{$this->action}>";
    $("#titreNav").html('Administration');
    $("#suTitreNav").empty();
    try{
        $("#D_filter").wijdialog({disabled: false});
        $("#maskAcc").remove();
        
    }catch(error){};
    
     $(".navLeftMenu").css("display","none");

<{if $this->message}>
    alert("<{$this->message}>");
<{/if}>

     <{if $this->data}>
        var siloData=<{$this->data}>
    <{/if}>
</script> 



<div id="canvasCellFermes" style="width:410px;margin-left:180px">
</div>

<{if $this->ct>0}>
    <div id='wrapperNotifNbAnal' style="margin-left:320px;">
    <div id='pastilleAnal'><{$this->ct}></div>
    <input id="btContratsSigne" style="" type="button"  value="contrat(s) a signer"/>
</div>
<{/if}>

<!--affectation des data-->

 <script> 
 
   //initialise
   var camp;

   createSilo("canvasCellFermes","100%",410,70,70,92.655,277,"setGlobal",true,[siloData],true,"1_",true);
   
   $("#btContratsSigne").click(function(evt){
       
        location.hash="administration_contratsasigner";
       return;
        })

</script>


