
<script>
    try{
        $("#optimises").wijgrid("destroy");
        $("#canvas_siloNav").css("display","block");
     }catch(e){
     
     }
</script>
<h1><{$this->message}></h1>
    <div id="canvas" class="canvasFerme"></div>
<div id="WrapperOpti">
    <div class="grilles grilles_contrats">
            <div class="ListTab">
                <div class="table table_contrats table">
                    <div class="titleGrid">DETAIL DES OPTIMIZ</div>
<!--                    <div class="action"><img class="download" src="/styles/img/ico_mod.png" alt="modifier"/></div>-->
                    <table class="prospection optimizes" id="optimises"></table>
                </div>
            </div>
    </div>

</div>


<script>
    
    /**
    *
    *@todo sur toute les page ajax reinitialiser les variables a null pour garbage collector
    * important 
    */
    
    $("#D_filter").wijdialog("enable");
    
    var pageSize=<{$this->pageSize}>;
    
    var optimisesData=<{$this->dataJson}>
        

    
    action="<{$this->action}>";
    
    siloData=<{$this->siloData}>
        
        //console.log("silodata",siloData)
        
   /*----CREATE GRID----------------------------*/

                var contrats=optimisesData.optimiz.contrats.contrat;
                

                
               //convertion to tab
                if(!isArray(contrats)){
                    contrats=convertToArray(contrats);
                }

           
                //initialise un tableau pour le reader wijgrid
                var reader=[];
                $.each(contrats, function(h,contrat){ 
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
                $("#optimises").wijgrid({
                    allowSorting: true,
                    allowPaging: true,
                    pageSize: pageSize,
                    data:new wijdatasource({
                    reader:bzreader,
                    data:contrats
                    }),
                    columns:[{visible:false},{visible:false}]
                    //ensureColumnsPxWidth: true
                    
                })

        // creer un timer pour refresh grid sinon en dyn elles sont mal dimensionnées
        setTimeout(function(){
                    $("#optimises").wijgrid("doRefresh");             
                    //gestion click vendre dur td
                    $(".vendre").click(function(e){

                        setTimeout(function(){
                           
                            var table=$(e.target).parent().parent().parent().parent().parent();
                           
                            try{
                            var selected =  table.wijgrid("selection").selectedCells();
                            var idCt=selected.item(0).row().data['idct'];
                            var idChb=selected.item(0).row().data['idchb'];
                            }catch(error){
                                console.log("this",$(e.target));
                                console.log("table",table);
                                alert("une erreur s'est produite.");
                            }
                            // get form to contrat
                            $.ajax({
                                url:"/transaction/setblocprix/format/html",
                                data:{"idct":idCt,"idchb":idChb},
                                type:"POST",
                                success:function(data){
                                    $("#main").empty();
                                    $("#main").html(data);
                                },
                                error:function(){
                                    alert("error");
                                }

                            })
                        },300);
                })//fin click

        },100);


    
     var message="<{$this->message}>";     
     if(message){
        alert("Une erreur c'est produite : "+message);
     }
     
    
     
     
    //create silo detail
    /**
    * param cellIdTran est recuperer en memoire car definir dans la page ajax precedente
    */
   
   
   
    createDSilo(siloData.cellules.cellule[cellIdTran],"2_",false,true);
    

    //ajoute pastille contrat en cours
    if(siloData.cellules.cellule[cellIdTran]['@attributes'] && parseInt(siloData.cellules.cellule[cellIdTran]['@attributes'].hasLock)){
        $("#canvas").prepend('<div id="pastilleContrat"><span>'+siloData.cellules.cellule[cellIdTran]['@attributes'].nbcontrats+'</span></div>');
    }

     //affichage optimiz cadenas
    if(siloData.cellules.cellule[cellIdTran].optimiz && siloData.cellules.cellule[cellIdTran].optimiz['@attributes'].nboptimiz){

        $("#canvas").prepend('<div id="pastilleOpti"><span>'+siloData.cellules.cellule[cellIdTran].optimiz['@attributes'].nboptimiz+'</span></div>');

    }
   

     
    var typeCt="<{$this->typeCt}>";
     //timer de rechargement de la page pour actualisation du prix de marché
    bzTimers.push(setInterval(function(){


            //location.hash="transaction_getoptimises/typeCt/"+typeCt;
            //$(window).trigger("hashchange");
         },5000)
    );
</script>