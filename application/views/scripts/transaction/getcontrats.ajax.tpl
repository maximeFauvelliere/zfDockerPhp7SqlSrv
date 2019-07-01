<script>
    $("#canvas_siloNav").css("display","block");
    try{
        $("#contrats").wijgrid("destroy");
        $("#preloader").css("display","none");
    }catch(e){
    
    }
</script>
<div class="content" style="width:inherit">
    <div class="grilles grilles_contrats">
        
<{if $this->data}>
     <{foreach from=$this->data name=contrat item=contrats}>
        
            <div class="ListTab <{if $contrats.checked>=1}>listTabActive<{/if}>">
                <div class="table table_contrats table<{$smarty.foreach.contrat.iteration}>">
                    <div class="titleGrid">CONTRATS <{$contrats.lib}>  <span style="float:right"><{$contrats.lieu}></span></div>
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
    }catch(error){};
    
    var pageSize=<{$this->pageSize}>;
    
    var offreData=<{$this->dataJson}>
        
         
        
   /*----CREATE GRID----------------------------*/
        $.each($(".offres_T"),function(i,e){

                var offre=offreData.offres.contrats[i].contrat;
                
                var produit=offreData.offres.contrats[i]['@attributes']['code'];
                
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
                    
                //console.log("produit",produit)
                    // ajoute une colonne type de produit b-zap b-zenith ....
                     reader.push({name:"produit",mapping:function(){return produit.toLowerCase()}});
                    // itere seulement sur les premiers contrats afin de recuperer les champs
                     if(h<=0){
                        $.each(contrat,function(k,element){
                            
                            //objet tableau pout reader
                            reader.push({name:element['@attributes'].lib,mapping:function(item){return item[k]['@text']}});
                            
                        })
                        //add action lock
                        reader.push({name:"Engager",mapping:function(item){return '<div style="font-weight:bold"><input class="vendre cursor" type="button" value="Engager"/> </div>'}});
                      }  
                })
                
                
                
                // create reader  pour wijgrid
                bzreader=new wijarrayreader(reader);

                

                // creer les objets grid 
                $(e).wijgrid({
                    allowSorting: false,
                    allowPaging: true,
                    pageSize: pageSize,
                    data:new wijdatasource({
                    reader:bzreader,
                    data:offre
                    }),
                    columns:[{visible:false},{visible:false}],
                    ensureColumnsPxWidth: true,
                    pageIndexChanged : function (e, args) {
                         setTimeout(function(){
                                bindClickVendre();
                        },10)
                    }
                    
                })

        })
        
         //gestion click vendre dur td
            function bindClickVendre(){
                     $(".vendre").click(function(e){
            
                                setTimeout(function(){
                   
                                    var table=$(e.target).parent().parent().parent().parent().parent().parent();
                                    //select la ligne lorsque le click est direct sur bt engager 
                                    //et que l'utilisateur n'as pas selectionné la ligne avant 
                                    var selection = table.wijgrid("selection");
                                    var selected = table.wijgrid("selection").selectedCells();
                                    var idCt=selected.item(0).row().data['idct'];
                                    //produit
                                    var pdt=selected.item(1).row().data['produit'];
                                    // get form to contrat
                                    $.ajax({
                                        url:"/transaction/setcontrat/format/html",
                                        data:{"idoffre":idCt,"pdt":pdt},
                                        type:'POST',
                                        success:function(data){

                                            $("#main").html(data);
                                            $("#preloader").css("display","none");
                                            window.scrollTo(0,0);
                                        },
                                        error:function(){
                                            alert("error");
                                        }

                                    })

                                    $("#preloader").css("display","block");
                                    $("#main").empty();

                            },300);
                    
                        })
            }
        
        // creer un timer pour refresh grid sinon en dyn elles sont mal dimensionnées
        setTimeout(function(){
            $.each($(".grilles table"),function(i,e){
                try{
                    $(e).wijgrid("doRefresh");
                 }catch(e){
                 
                 }
                 
                 
            })
            
            
            bindClickVendre();

       

        },100);
 
     var message="<{$this->message}>";     
     if(message){
        alert("Une erreur s'est produite : "+message);
     }
    
</script>