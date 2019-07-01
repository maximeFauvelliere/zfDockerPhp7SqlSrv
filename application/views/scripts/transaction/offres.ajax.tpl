

<script>
    //clear function
    function makeDataGrid(){};
    controller="<{$this->controller}>";
    action="<{$this->action}>";
    $("#titreNav").html('Transaction');
    $("#suTitreNav").empty();
    $("#suTitreNav").html('Offres Bz');$
    $("#canvas_siloNav").css("display","block");
    try{
        $("#D_filter").wijdialog({disabled: false});
    }catch(error){}
    
</script>
<{if $this->message}><h1><{$this->message}></h1><{/if}>
<div class="content">
<div id="canvasCellFermes">
</div>


<div id="dialog"></div>
</div>
<{$this->render('nav.tpl')}>


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

   //action on icone info cell, beware define it before call silo object
    function getInfo(data){       
    var idPage={"idpage":data};
    $.ajax({
            url:"/transaction/info/format/html",
            data:idPage,
            success:function(data){

                $("#main").append(data);
                //dialog analyse en affectation
           $("#info").wijdialog({
                autoOpen:true,
                modal: true,
                captionButtons:{
                pin: { visible: false },
                refresh: { visible: false },
                toggle: { visible: false },
                minimize: { visible: false },
                maximize: { visible: false },
                close: { visible: false} 
                },
                title:"Info offres commerciales",
                width:"80%",
                height:"600",
                close:function(){
                    //destroy dialog
                     $(this).wijdialog('destroy');
                     $(this).remove();
                },
                open:function(e){
                            var dialog=$(e.target);
                                if(!$(".sc-bt-dialog-close").length){
                                     $(e.target).parent().find(".ui-dialog-titlebar").append("<span class='sc-bt-dialog-close' style='cursor:pointer;position:absolute;right:5px;' ></div>");
                                            $(".sc-bt-dialog-close").bind("click",function(e){
                                                dialog.wijdialog('close');
                                            })
                }
                        }
                }); 
            }

        })
    }
    
    /*
    * call list contrat a deblocquer
    */
    function getUnlockContrat(contratTitle){
//            $.ajax({
//            url:"/transaction/getcontrattolock/format/html",
//            success:function(data){
//                ("data retour info",data);
//               $("#main").empty();
//               $("#main").html(data);
//               }
//            })


        location.hash="transaction_getcontrattolock/contrat/"+contratTitle;
    
    }
    
    //get list contrats by offre
    function getContratsList(contratTitle){
    
         /*$.ajax({
            url:"/transaction/getcontrats/format/html",
            success:function(data){

               $("#main").empty();
               $("#main").html(data);

            }
        })*/

        if(contratTitle) contratTitle=contratTitle.replace("_","").toLowerCase();
        location.hash="transaction_getcontrats/contrat/"+contratTitle;
    }
    
    /**
    * interaction optimize global 
    */
    function getUnlockOpti(){
        
        getUnlockContrat("optimiz");
    
    }
    

   createSilo("canvasCellFermes","100%",410,70,70,92.655,277,"setOffreCom",false,[siloData],false,"1_",false,true,true);

   //click sur optimiz global
   function optimizGlobalAction(){
    
     //location.hash="transaction_getcontrattolock";
     location.hash="transaction_getoffreopti";
     return;

    }
   $(document).ready(function() {
     
       $("#preloader").css("display","none");
       
      
      
})
       
  // trig event pour le menu gauche  a changer
$(window).trigger("menuToChange",[controller,action]);    
   
   
</script>
