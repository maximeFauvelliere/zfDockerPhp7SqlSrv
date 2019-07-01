<!--condition de vente-->
<div id="cdvTxt" class="trash" style="display: none"><{$cdv}></div>

<form id="setContrat" class="form" name="formSetContrat" method="post" action="">
    
    <input type="hidden" name="idsous" value="<{$data->idsous}>"/>
    <input type="hidden" name="idoffre" value="<{$data->idoffre}>"/>
    <input type="hidden" name="etape" value="<{if $data->optimiz.checked == "1" || $data->securiz.checked == "1"}>1<{else}>2<{/if}>"/>
    <input type="hidden" id="produit" name="pdt" value="<{$pdt}>"/>
    <!--    <input type="hidden" id="etapeprec" name="etapeprec" value="init"/>-->

    <div class="bzHeader"><span>Etape : Structure - Lieu d'exécution - Périodes</span></div>
    <table class="lot" id="tabLotFormcontent" style="max-width: 900px">
        <tbody>
            <tr>
                <td style="width:25%">
                    <div class="wraperLabel">
                        <label> Structures</label>
                    </div>                  
                </td>
                <td style="padding-left:10px">
                      <ul class="listform" id='listStruc'>
    
                    <{foreach from=$data item=contrat}>
                        <{foreach from=$contrat->structure item=structure name="lesstructures"}>
                            <li>
                                <input class="radioStruct" type="radio" structtabindex="<{$smarty.foreach.lesstructures.index}>" name="stru" <{if $structure.checked==1}>checked='checked'<{/if}> value="<{$structure.idti}>"><{$structure.denom}><{$structure.nom}></input>
                            </li>
                        <{/foreach}>
                    <{/foreach}>
                    </ul>
                </td>
        </tr>
        <tr>
            <td style="width:25%">
                <div class="wraperLabel">
                       <label> Lieu d'exécution</label>
                </div>
            </td>
            <td style="padding-left:10px">
                <div id="tabs">
                    <ul>
                        <li class="ongletSous"><a  href="#tabs-1">DEPART FERME</a></li>
                        <li class="ongletSous"><a  href="#tabs-2">RENDU SILO</a></li>
                    </ul>
                    <div id="tabs-1">
                        <ul class="listform" id='listExe'>
                            <{foreach from=$data item=contrat}>
                                <{foreach from=$contrat->structure item=structure}>
                                    <{if $structure.checked==1}>
                                        <{foreach from=$structure->execution item=execution }>
                                            <li>
                                                <input  class="exec" type="radio" name="exec"  <{if $execution.checked==1}>checked='checked'<{/if}> value="<{$execution.idex}>"><{$execution.adr1}> <{$execution.adr2}> <{$execution.ville}></input>
                                            </li>
                                        <{/foreach}>
                                    <{/if}>    
                                <{/foreach}>
                            <{/foreach}>
                        </ul>
                    </div>
                    <div id="tabs-2">
                        <ul class="listform" id='listSilo'>
                            <{foreach from=$data->silos item=silos}>
                                <{foreach from=$silos->silo item=silo}>
                                    <li>
                                         <input  class="silo" type="radio"  name="silo" <{if $silo->checked==1}>checked='checked'<{/if}>   value="<{$silo->idsilo}>">livraison <{$silo->nom}></input>
                                    </li>
                                <{/foreach}>
                            <{/foreach}>
                        </ul>
                    </div>
            
                </div>
                 
            </td>
        </tr>
        <tr>
            <td style="width:25%">
                <div class="wraperLabel">
                       <label> Période d'exécution</label>
                </div>
            </td>
             <td style="padding-left: 10px">
                    <select id="periodes" name="periode" class="select_periode">
                        <{foreach from=$data->perenlvt->periodes->periode item=periode}>
                                <option value='<{$periode->idwocld}>' <{if $periode->checked==1}> selected="selected"<{/if}>><{$periode->periode}></option>
                        <{/foreach}>
                    </select>
            </td>
        </tr>
        <{if  $data->perobs}>
            <tr>
                <td style="width:25%">
                    <div class="wraperLabel">
                        <label>Période d'observation</label>
                    </div>
                </td>
                <td style="padding-left: 10px">
                    <select id="pobs" name="pobs" class="select_periode">
                        <{foreach from=$data->perobs->observations->pobs item=pobs}>
                            <option value='<{$pobs->idwob}>' <{if $pobs->checked==1}> selected="selected"<{/if}>><{$pobs->pobs}></option>
                        <{/foreach}>
                    </select>
                </td>
            </tr>
            <tr>
                <td style="width:25%">
                    <div class="wraperLabel">
                        <label> Date de paiement</label>
                    </div>
                </td>
                <td style="padding-left: 10px">
                    <select id="paiements" name="paiement" class="select_periode">
                        <{foreach from=$data->perobs->observations->pobs item=pobs}>
                            <{foreach from=$pobs->datepaiement  item=datepaie}>
                                <option value='<{$datepaie.idwopa}>' <{if $datepaie->checked==1}> selected="selected"<{/if}>><{$datepaie.paiement}></option>
                            <{/foreach}>
                        <{/foreach}>
                    </select>
                </td>
            </tr>
        <{else}>
            <tr>
                <td style="width:25%">
                    <div class="wraperLabel">
                        <label> Date de paiement</label>
                    </div>
                </td>
                <td style="padding-left: 10px">
                    <select id="paiements" name="paiement" class="select_periode">
                        <{foreach from=$data->perenlvt->periodes->periode item=periode}>
                            <{if $periode->checked=="1"}>
                                <{foreach from=$periode->datepaiement  item=datepaie}>
                                    <option value='<{$datepaie.idwopa}>' <{if $datepaie->checked==1}> selected="selected"<{/if}>><{$datepaie.paiement}></option>
                                <{/foreach}>
                            <{/if}>
                        <{/foreach}>
                    </select>
                </td>
            </tr>
        <{/if}>
        
        <tr>
                <td colspan="2" style="text-align:center;padding-left:30%;padding-right:30%;height:40px">
                    <input class="btFormAddLot" id="etape1"  style="float:right;max-width:300px" type="submit"  value="Etape suivante : <{if $data->optimiz.checked == "1" || $data->securiz.checked == "1"}>Produits dérivés<{elseif  $pdt=="bzenith"}>prix d'objectif<{else}>calcul du prix<{/if}>"/>
                    <input class="btFormAddLot btFormAnnuler"  type="button" value="Annuler"/>
                </td>
       </tr>
    </tbody>
    </table>    
</form>


                
<script>
    
    var formData=<{$formData}>;
    var activeTab=0;

    $.each($(".silo"),function(i,e){
        
        if($(e).attr("checked")){
            activeTab=1;
            return false;
        }
    })
    
    
    /*$("#tabs div").each(function(i,e){


    });*/
    // create modale effect
    $('body').append("<div class='bzModale'></div>");
    $(".bzModale").css("height",$(document).height());
    $(".bzModale").css("width",$(document).width());
    $("#canvas_siloNav").css("display","none");
    
    // collapse le filtre si besoin
    try{
        if($("#D_filter").css("display")=="block"){

            $("#D_filter").wijdialog("toggle");
            $("#D_filter").wijdialog({disabled:true});
        }
        $("#D_filter").wijdialog({disabled:true});
        $("#preloader").css("display","none");
               
    }catch(error){
    
    };
    
    //tabs 
    
    $( "#tabs" ).tabs({ active:activeTab});

    $( "#tabs" ).tabs({
            activate: function( event, ui ) {
                
                $(ui.oldPanel).find("input").each(function(i,e){
                    this.checked=false;
                })
            }
        });
    
    (function changeStruc(){
   
                    $(".radioStruct").click(function(e){
                        
                        indexStruct=$(e.target).attr("structtabindex");
                     
                        structure=formData['contrat']['structures']['structure'][indexStruct];
                        
                        //console.log("structure",structure);

                        //remove les champs input
                            $('#listExe ').empty();
                           

                            $.each(structure['execution'],function(c,d){
                            if(d['@attributes']){
                                lieu=d['@attributes']['adr1']+d['@attributes']['adr2']+d['@attributes']['ville'];
                                //value= d['@attributes']['idex']+"_"+d['@attributes']['prix']; 
                                value= d['@attributes']['idex']; 
                               
                                }else{
                                lieu=d.adr1+d.adr2+d.ville;
                                value= d.idex;  
                                
                            }

                            $('#listExe').append('<li><input type="radio" class="exec" name="exec" value="'+value+'">'+lieu+'</input> </li>');    
                            
                        });
                        
                        // changement execution
         
                         $(".exec").unbind("click");
//                         $(".exec").bind("click",function(e){
//                            alert("click exec");
//                        })
                        
                        // selectionne le premier lieux d'execution
                        //$('#listExe li').first().children().attr("checked","checked");
                        
                                
                    });
                }())
                
 
         //get list contrats by offre => click annuler
        function getContratsList(contratTitle){
        
            if(contratTitle) contratTitle=contratTitle.replace("_","");
            
            location.hash="transaction_getcontrats/contrat/"+contratTitle;
            $(window).trigger("hashchange");
             /*$.ajax({
                url:"/transaction/getcontrats/format/html/",
                success:function(data){

                   $("#main").empty();
                   $("#main").html(data);


                }

            })*/
        }
        
        
       
        
        
        //annulation form
        $(".btFormAnnuler").click(function(){
            
            //reset for dialog
            try{
                 $("#canvas_siloNav").css("display","block");
                 $(".bzModale").remove();
                 $("#cdvTxt").wijdialog("destroy");
            
                 $("#popUpValid").wijdialog("destroy");
                 $("#popUpValid").remove();
            }catch(error){
        
            }
           
            $.ajax({     
                url:"/transaction/annuleformct/format/html",
                data:{"idsous":<{$data->idsous}>},
                type:"POST"
            })
            
            var produit=$("#produit").val();
            
            $("#preloader").css("display","block");
            $("#main").empty();
           
            getContratsList(produit);
        });

       
       $('#setContrat').submit(function(){

                $("#etape1").attr("disabled","disabled");
                
                var tabChecked=[];
                
                $("#tabs input").each(function(i,e){

                        if($(this).is(':checked')) tabChecked.push(1);
        
                })
                
                if(tabChecked.length<1){
                    alert("Vous devez sélectionner un lieu d'execution ou un silo.");
                    $("#etape1").removeAttr("disabled");
                    return false;
                }
                
                if(tabChecked.length>=2){
                    alert("Erreur deux lieux de départ son selectionnés");
                    $("#etape1").removeAttr("disabled");
                    return false;
                }
                
                
                
                $.ajax({
                    url:"/transaction/setcontrat/format/html",
                    data:$(this).serialize(),
                    type:"POST",
                    success:function(data){
                       
                        $("#main").empty();
                        $("#main").html(data);
                        //scroll page to top and left
                        window.scrollTo(0,0);
                    },
                    error:function(){
                        alert("error")
                    }
                });
                
                return false;
            });
            
            /**
            * chargement des liste en fonction de l'action utilisateur
            * verifie les periode de paiement. Quand  Bzen , affiches les periodes de paiement communes
            * 
             * @returns {undefined}             */
            function setListesChanged(){
            
                        //listes des paiement 
                var listePaiement=new Array();
                //selection
                 var periodeSelectedTxt=null;
                 var pobsSelectedTxt=null;
                //objet selectionné
                var periodeSelectedData=null;
                var pobsSelectedData=null;
                 $( "#periodes option:selected" ).each(function() {
                    periodeSelectedTxt=$( this ).text();
                });
                
                if($("#pobs").length){
                    //conserver dates paiements commune a pods et periodes
                   
                    var periodeData=formData.contrat.perenlvt.periodes.periode;
                    //iteres periode pour trouver l'objet selectionné
                    //stock cet objet ds une var
                    $.each(periodeData,function(i,e){
                        if(periodeSelectedTxt==e.periode){
                            periodeSelectedData=e;
                        }
                        //console.log("i",i,"  e",e)
                    })
                    
                    //get selected pobs
                    var pobsData=formData.contrat.perobs.observations.pobs;
                     $( "#pobs option:selected" ).each(function() {
                        pobsSelectedTxt=$( this ).text();
                        //console.log("pobsSelectedTxt",pobsSelectedTxt);
                    });
                    
                     //iteres pobs pour trouver l'objet selectionné
                    //stock cet objet ds une var
                    $.each(pobsData,function(i,e){
                        if(pobsSelectedTxt==e.pobs){
                            pobsSelectedData=e;
                            //console.log("pobs i",i,"  e",e);
                        }
                        
                    })
                    
                    /**
                     * compare les pobs et periode ne garde que 
                     * les paiements communs
                     */
                    $.each(periodeSelectedData.datepaiement,function(i,e){
                        
                        var idwopaPeriode=e["@attributes"]["idwopa"];
                        $.each(pobsSelectedData.datepaiement,function(a,b){
                            
                            if(idwopaPeriode==b["@attributes"]["idwopa"]){
                                listePaiement.push(b);
                            }
                            
                            
                        })
                       
                        
                    })
                }else{
                     var periodeData=formData.contrat.perenlvt.periodes.periode;
                    //iteres periode pour trouver l'objet selectionné
                    //stock cet objet ds une var
                    $.each(periodeData,function(i,e){
                        if(periodeSelectedTxt==e.periode){
                            periodeSelectedData=e;
                        }
                        //console.log("i",i,"  e",e)
                    })
                    //console.log("periode selected",periodeSelectedData.datepaiement)
                    var datePaiements=periodeSelectedData.datepaiement;

                    if(!isArray(datePaiements)){

                        datePaiements=convertToArray(datePaiements);
                    }
                    
                     $.each(datePaiements,function(a,b){

                                listePaiement.push(b);

                        })
                
                }
                    //console.log("data",formData.contrat);
                    //console.log("listepaiement",listePaiement);
                    $("#paiements").empty();
                    $.each(listePaiement,function(i,e){
                        var selected=parseInt(e['@attributes']['checked'])?"selected='selected'":"";
                        var option="<option value='"+e['@attributes']['idwopa']+"'  "+selected+">"+e['@attributes']['paiement']+"</option>";
                        $("#paiements").append(option);
                      
                    
                    })
            
            }
            
            $("#periodes").change(function(){
                    setListesChanged();
            })
            
            $("#pobs").change(function(){
                setListesChanged();
                
            })
        
        /*$("#btAnnulConfirm").bind("click",function(){
        
            $("#popUpValid").wijdialog("close");
            $("#popUpValid").wijdialog("destroy");
        });*/
        
        //scroll 
            window.scrollTo(0,0); 
  

</script>    
                        