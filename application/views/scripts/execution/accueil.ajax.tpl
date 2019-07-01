<script>
    //clear function
    function makeDataGrid(){};
    controller="<{$this->controller}>";
    action="<{$this->action}>";
    $("#titreNav").html('Exécution');
    $("#suTitreNav").empty();
    try{
         $("#D_filter").wijdialog({disabled: false});
         $("#maskAcc").remove();
    }catch(error){}
   
</script>

<{if $this->message}>
<script>
    alert("<{$this->message}>");
</script>
<{/if}>

<script>
   $(".navLeftMenu").css("display","none");
</script> 

<div id="canvasCellFermes" style="width:410px;margin-left:180px">
</div>


<!--affectation des data-->

<{if $this->data}>
 <script> 
 
 var siloData=<{$this->data}>
     
 </script>
 
<{/if}>



<script>
    
   //initialise
     
   //url requete ajax 
   //var url;   
   //camp
   var camp;

   createSilo("canvasCellFermes","100%",410,70,70,92.655,277,"setGlobal",true,[siloData],true,"1_",true);
   
</script>


