<script>
    try{
        $("#contrats").wijgrid("destroy");
        $("#canvas_siloNav").css("display","block");
    }catch(e){
    
    }
</script>
<div class="content" style="width:inherit">
    <div class="grilles grilles_contrats">
    <h5>Sur e-Bz, la fixation de prix et le blocage d'optimiz sont possibles entre 11h et 18h</h5>
<{if $this->data}>
     <{foreach from=$this->data name=contrat item=contrats}>
        
            <div class="ListTab <{if $contrats.checked>=1}>listTabActive<{/if}>" pdt="<{$contrats.code}>">
                <div class="table table_contrats table<{$smarty.foreach.contrat.iteration}>">
                    <div class="titleGrid"><{$contrats.lib}>  <span style="margin-left:300px"><{$contrats.lieu}></span></div>
<!--                    <div class="action"><img class="download" src="/styles/img/ico_mod.png" alt="modifier"/></div>-->
                    <table class="prospection offres_T" id="offreContrats<{$smarty.foreach.contrat.iteration}>"></table>
                </div>
            </div>
        
     <{/foreach}>
<{else}>
    <p> il n'y a pas de données à afficher.</p>
<{/if}>

    </div>

</div>

<script>
    
    /**
    *
    *@todo sur toute les page ajax reinitialiser les variables a null pour garbage collector
    * important 
    */
    try{
        $("#D_filter").wijdialog("enable");
    }catch(error){
        var pageSize=<{$this->pageSize}>;
    }
    
    var offreData=<{$this->dataJson}>
        
   /*----CREATE GRID----------------------------*/
        $.each($(".offres_T"),function(i,e){

                var offre=offreData.offres.contrats[i].contrat;
                

                
               //convertion to tab
                if(!isArray(offre)){
                    offre=convertToArray(offre);
                }

                // saut si offre est vide
                if(!offre.length){
                    $(e).parent().css("background-color","grey");
                    $(e).parent().css("opacity","0.3");
                    /* For IE8 and earlier */
                    $(e).parent().css("filter","alpha(opacity=40)");
                    return true;
                }
                //initialise un tableau pour le reader wijgrid
                var reader=[];
                $.each(offre, function(h,contrat){ 
                    // itere seulement sur les premiers contrats afin de recuperer les champs
                     if(h<=0){
                        $.each(contrat,function(k,element){
                            //objet tableau pout reader
                            reader.push({name:element['@attributes'].lib,mapping:function(item){return item[k]['@text']}});
                            
                        })
                        //add action lock
                        reader.push({name:"Action",mapping:function(item){
                            
                            if(item['engage'] && parseFloat(item['engage']['@text'])<=0){
                             return '<div style="width:100%;text-align:center;"> <input class="vendre" type="button" value="Bloquer" disabled="disabled"/> </div>';
                            }
                            
                            return '<input  class="vendre cursor" style="width:100%;text-align:center;" type="button" value="Bloquer"/>'}});
                      }  
                })
                
                // create reader  pour wijgrid
                bzreader=new wijarrayreader(reader);


                // creer les objets grid 
                $(e).wijgrid({
                    allowSorting: true,
                    allowPaging: true,
                    pageSize: pageSize,
                    data:new wijdatasource({
                    reader:bzreader,
                    data:offre
                    }),
                    columns:[{visible:false},{visible:false}]
                    //ensureColumnsPxWidth: true
                    
                })

        })
        
        // creer un timer pour refresh grid sinon en dyn elles sont mal dimensionnées
        setTimeout(function(){
            $.each($(".grilles table"),function(i,e){
                try{
                    $(e).wijgrid("doRefresh");
                    $(e).wijgrid({allowSorting: false});
                 }catch(e){
                 
                 }
            })
            
            //gestion click vendre dur td
            $(".vendre").click(function(e){
               
                // desactive intervale timer
                var lastTimer = bzTimers[bzTimers.length-1];
                
                clearInterval(lastTimer);
                setTimeout(function(){
                       var table=$(e.target).parent().parent().parent().parent().parent();
                        var selected = table.wijgrid("selection").selectedCells();
                        var idCt=selected.item(0).row().data['idct'];
                        var idChb=selected.item(0).row().data['idchb'];
                        var produit=$(".listTabActive").attr("pdt");
                        produit=produit?produit:"";
                        // get form to contrat
                        $.ajax({
                                url:"/transaction/setblocprix/format/html",
                                data:{"idct":idCt,"idchb":idChb,"pdt":produit},
                                type:"POST",
                                success:function(data){

                                    $("#main").empty();
                                    $("#main").html(data);
                                },
                                error:function(){
                                    alert("error");
                                }
                        })
                },300)
            })//fin click
        },100);


    
     var message="<{$this->message}>";     
     if(message){
        alert("Une erreur s'est produite : "+message);
     }
     
     //timer de rechargement de la page pour actualisation du prix de marché
     bzTimers.push(setInterval(function(){
        $(".vendre").attr("disabled","disabled");
        var produit=$(".listTabActive").attr("pdt");
        produit=produit?produit:"";
        
        location.hash="transaction_getcontrattolock/contrat/"+produit;
        $(window).trigger("hashchange");
     },30000));
     
    
</script>