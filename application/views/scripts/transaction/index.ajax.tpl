<script>
   //clear function
    function makeDataGrid(){};
    $("#titreNav").html('Transaction');
    $("#suTitreNav").empty();
    $("#suTitreNav").html('Contrats engagés');
    try{
        $("#D_filter").wijdialog({disabled: false});
        $("#maskAcc").remove();
    }catch(error){}
    
</script>
<{if $this->message}><h1><{$this->message}></h1><{/if}>
<div class="content">

<div id="canvasCellFermes">
</div>

<{if $this->ct>0}>
<div id='wrapperNotifNbAnal' style="margin-left:320px;">
    <div id='pastilleAnal'><{$this->ct}></div>
    <input id="btContratsAff" style="" type="button"  value="Contrat(s) à affecter"/>
</div>
<{/if}>


<div id="dialog"></div>
</div>
<{$this->render('nav.tpl')}>


<script>
    controller="<{$this->controller}>";
    action="<{$this->action}>";
</script> 



<!--affectation des data-->

<{if $this->data}>
 <script> 
 
 var siloData=<{$this->data}>;

 var camp;
 
 </script>
 
 
<{/if}>



<script>
    
   //initialise
    var url;


   createSilo("canvasCellFermes","100%",410,70,70,92.655,277,"setGlobal",true,[siloData],true,"1_",true,true);
   
   
   $(document).ready(function() {
     
       $("#preloader").css("display","none");
      
})
 
 /**
 *gestion optimiz
 *contrat : bbaz, bbeuz
 *
 **/

// declaration id cellule sellectionnée
 var cellIdTran=null;
 
 //click sur optimiz global
 function optimizGlobalAction(contrat){
    alert("erreur");
    return false;
    $.each(siloData.cellules.cellule,function(i,e){

        if(e['@attributes'].titre.toLowerCase()==contrat.toLowerCase()){
            cellIdTran=i;
        }
    });

     location.hash=controller+"_getoptimises/typeCt/"+contrat;
     return;

 }
 
function  getOptimiz(contrat){
    if(action=="getoptimises") return;
//console.log("contrat",contrat);
    $.each(siloData.cellules.cellule,function(i,e){

        if(e['@attributes'].titre.toLowerCase()==contrat.toLowerCase()){
            cellIdTran=i;
        }
    });
    location.hash=controller+"_getoptimises/typeCt/"+contrat;
    return;
    
}
 

$("#btContratsAff").click(function(evt){

        location.hash="transaction_ctaffectationlist";

})


      
 // trig event pour le menu gauche  a changer
$(window).trigger("menuToChange",[controller,action]);      
   
</script>
