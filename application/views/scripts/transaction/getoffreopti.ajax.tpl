<script>
    $("#canvas_siloNav").css("display","block");
    try{
       // $("#contrats").wijgrid("destroy");
    }catch(e){
    
    }
</script>
<div class="content" style="width:inherit">
    <div id="grilles_opti">
            <div class="ListTab">
                <div class="table table_opti">
                    <div class="titleGrid">OPTIMIZ </div>
                    <table class="prospection offres_T" id="offreOpti"></table>
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
    try{
        $("#D_filter").wijdialog("enable");
    }catch(error){};
    
    var pageSize=<{$this->pageSize}>;
    
    var offreOpti=<{$this->dataJson}>
        
      
        
   /*----CREATE GRID----------------------------*/
     
    
    var opti=offreOpti.opti.optimiz;

   //convertion to tab
    if(!isArray(opti)){
        opti=convertToArray(opti);
    }


    //console.log("opti",opti);
    //console.log("opti[0]",opti[0].idwohb)
    //initialise un tableau pour le reader wijgrid
    var reader=[];


    $.each(opti, function(h,optimiz){ 
        if(!opti[0].idwohb) return;
    //console.log("produit",produit)
        // ajoute une colonne type de produit b-zap b-zenith ....
         //reader.push({name:"produit",mapping:function(){return produit.toLowerCase()}});
        // itere seulement sur les premiers optimizs afin de recuperer les champs
         if(h<=0){
            $.each(optimiz,function(k,element){

                //objet tableau pout reader
                reader.push({name:element['@attributes'].lib,mapping:function(item){return item[k]['@text']}});

            })
            //add action lock
            reader.push({name:"Engager",mapping:function(item){return '<div style="font-weight:bold;width:100%;text-align:center;"><input class="vendre cursor" type="button" value="Engager"/> </div>'}});
          }  
    })



    // create reader  pour wijgrid
    bzreader=new wijarrayreader(reader);



        // creer un timer pour refresh grid sinon en dyn elles sont mal dimensionnées
        setTimeout(function(){
                if(!opti[0].idwohb){
                    $("#offreOpti").html("il n'y a pas d'optimiz pour cette campagne.")
                    return;
                }
                try{
                      // creer les objets grid 
                        $("#offreOpti").wijgrid({
                            allowSorting: false,
                            allowPaging: true,
                            pageSize: pageSize,
                            data:new wijdatasource({
                            reader:bzreader,
                            data:opti
                            }),
                            pageIndexChanged: function (e, args){
                            
                                bindClick();
                            },
                            columns:[{visible:false},{visible:false}]
                            //ensureColumnsPxWidth: true

                        })

                 }catch(e){
                 
                 }
                 
                 bindClick();

        },100);
        
        
        
        
       function bindClick(){ 

            //gestion click vendre dur td
            $(".vendre").parent().parent().click(function(e){
                
                //var table=$(this).parent().parent().parent();
                // delete timer update liste opti
                // desactive intervale timer
                var lastTimer = bzTimers[bzTimers.length-1];
                
                clearInterval(lastTimer);
                
                // attente selection ok
                setTimeout(function(){
                   
                    var selected = $("#offreOpti").wijgrid("selection").selectedCells();
                   // var idRow=(pageSize*$("#offreOpti").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();


                    var idWo=selected.item(0).row().data['idwo'];
                    //produit
                    var idWohb=selected.item(0).row().data['idwohb'];
                    var etape="init";
                    //console.log("idwo",idWo);
                    //console.log("idwohb",idWohb);
                
                    
                    // get form to contrat
                    $.ajax({
                        url:"/transaction/setopti/format/html",
                        data:{"etape":etape,"idwo":idWo,"idwohb":idWohb},
                        type:'POST',
                        success:function(data){
                            $("#main").empty();
                            $("#main").html(data);
                        },
                        error:function(x,s,d){
                            /*console.log("x",x);
                            console.log("s",s);
                            console.log("d",d);
                            alert("error");*/
                        }

                    })
        
                },10)
          })       
    }
    
    var flagProcessEnd=true;
    //compteur erreur
    var nbTimeOut=0;
     // call matif first time 
    function callOptiList(){
        //si pas d'opti
        if(!opti[0].idwohb) return;
           
         if(!flagProcessEnd) return;
         flagProcessEnd=false;
        //$("#offreOpti").empty();
        if(!$(".preload_opti").length>0){
            $("#grilles_opti").append('<div class="preload_opti" style="width:100%;height:50px;"><span>Actualisation en cours...</span></div>');
        }
        $(".vendre").attr("disabled","disabled");
        $.ajax({
            url:"/transaction/getoffreopti/format/json",
            timeout:29500,
            success:function(data){
            
             if(data.error){
                alert(data.error);
                location.href="/";
             }
            // flag 
            flagProcessEnd=true;
            // reset compteur erreur
            nbTimeOut=0;
            //verifier données
                opti=data.opti.optimiz;

               //convertion to tab
                if(!isArray(opti)){
                    opti=convertToArray(opti);
                }
            
                 $("#offreOpti").wijgrid({
                    data:new wijdatasource({
                            reader:bzreader,
                            data:opti
                            }),
                     rendered:function(){bindClick()}
                });

                $(".preload_opti").remove();
                
            },
            error:function(xhr,state,error){
                flagProcessEnd=true;
                //increment compteur erreur
                nbTimeOut++;
                if(nbTimeOut>2){
                    flagProcessEnd=false;
                    alert("l'actualisation est trop longue, nous rechargeons la page d'accueil automatiquement afin de réinitialiser la connexion. Si le problème persiste contacter un commercial.");
                    location.hash="accueil_index";
                    
                }
                //alert("l'actualisation est trop longue, nous rechargons la page automatiquement. Si le problème persiste contacter un commerciale.")
                
            }


        })
        
        //setTimeout(function(){;},1000)
        
    
    }
    
     bzTimers.push(setInterval(function(){

        callOptiList();
        //location.hash="transaction_getdetailcontrat/contrat/"+contratName;
        //$(window).trigger("hashchange");
     },30000));
    
        
 
 
     var message="<{$this->message}>";     
     if(message){
        alert("Une erreur s'est produite : "+message);
     }
    
</script>