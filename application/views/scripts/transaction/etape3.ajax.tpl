<div id="dialogQteLess" class="trash" title="Quantité insuffisante" style="display:none">
    <div>
        Vous ne disposez pas de quantité suffisante pour la quantité que vous avez engagée.<br/>
        Il manque <span id="qteManque"></span> t pour atteindre votre engagement.<br/>
        Souhaitez vous créer un nouveau lot automatiquement:<br/>
        <table style="width: 100%">
            <tbody>
                <tr>
                    <td>
                        
                        <input id="btCancel" type="button" value="Annuler"/>
                    </td>
                    <td>
                        
                        <input id="btAuto" type="button" value="Oui"/>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<div id="dialogQteLess2" class="trash" title="Quantité lot " style="display:none">
    <div>
        Votre quantité est supérieure à la quantité initiale de votre lot.<br/> 
        Souhaitez vous augmenter la quantité de votre  lot automatiquement?<br/>
        
        <table style="width: 100%">
            <tbody>
                <tr>
                    <td>
                        
                        <input id="btOk" type="button" value="Oui"/>
                    </td>
                    <td>
                        <input id="btKo" type="button" value="Non"/>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

<form id="formSous" class="form" name="formSetContrat" method="post" action="">
    
    <input id="idsous" type="hidden" name="idsous" value="<{$data->idsous}>"/>
    <input id="idoffre" type="hidden" name="idoffre" value="<{$data->idoffre}>"/>
<!--    <input type="hidden" id="etapeprec" name="etapeprec" value="3"/>-->
    <input type="hidden" id="etapeback" name="back" value="<{$this->back}>"/>
    <input type="hidden" id="etape" name="etape" value="4"/>
    <input id="idauto" type="hidden" name="auto" value="0"/>
    <input type="hidden" id="produit" name="pdt" value="<{$pdt}>"/>
    <div class="bzHeader"><span>Etape : Quantité ou surface à engager</span></div>
    <table class="lot" id="tabLotFormcontent" style="width: 100%">
        <tbody>
          <tr>
                <td colspan="2">
                    <div class="wraperLabel">
                          <label> Récapitulatif du contrat</label>
                    </div>
                </td>
            </tr> 
            <tr>
                <td colspan="2" style="width:100%">
                    <{foreach from=$data->recap item=recap}>
                           <table class="recap" style="width:100%;">
                               <tbody>
                                    <{foreach from=$recap item=content}>
                                    <tr>
                                        <td>
                                            <{$content.lib}>
                                        </td>
                                        <td>
                                            <{$content}>
                                        </td>
                                    </tr>
                                    <{/foreach}>
                               </tbody>
                           </table>

                    <{/foreach}>

                </td>
            </tr>
            <!--engagement-->
            <tr>
                <td colspan="2" style="width:100%">
                    <div class="wraperLabel">
                          <label> <{$data->engagement->lib}></label><label style="float:right">*Minimum engagement pour cette culture :<{$this->data->min}></label>
                    </div>
                </td>
            <tr> 
            <tr>
                <td colspan="2">
                    <input id="qteEng" type="text" name="<{$data->engagement->lib.nom}>" value="<{$data->engagement->qte}>"/>
                </td>
            </tr>
            <!-- lots-->
            <{if $data->lot}>
                <tr>
                    <td colspan="2" style="width:100%">
                        <div class="wraperLabel">
                              <label> lots</label>
                        </div>
                    </td>
                <tr> 
                <tr>
                    <td colspan="2">

                        <table id="tabLots">
                                   <thead>
                                               <{foreach from=$data->lot item=lot name=lot}>
                                                    <{if $lot@first}>
                                                        <{foreach from=$lot item=lib }>
                                                            <th>
                                                                <{$lib.lib}>
                                                            </th>
                                                        <{/foreach}>
                                                    <{/if}>
                                               <{/foreach}>

                                           
                                   </thead>
                                   <tbody>
                                        <{foreach from=$data->lot item=lot}>
                                        <tr>
                                            <td>
                                                <{$lot->id}>
                                            </td>
                                            <td>
                                                <{$lot->camp}>
                                            </td>
                                            <td>
                                                <{$lot->cult}>
                                            </td>
                                            <td>
                                                <{$lot->stock}>
                                            </td>
                                            <td>
                                                <{$lot->nom}>
                                            </td>
                                            <td>
                                                <{$lot->type}>
                                            </td>
                                            <td>
                                                <{$lot->qte}>
                                            </td>
                                            <td>
                                                <{$lot->surf}>
                                            </td>
                                            <td>
                                                <{$lot->structure}>
                                            </td>
                                            <td><input type="checkbox" rowid="<{$lot@index}>" stock="<{$lot->stock.type}>" class="checkboxLot"   name="checkLot[]" <{if $lot->choix.checked=="1"}>checked="checked"<{/if}> value="<{$lot->stock.type}>_<{$lot->id}>_<{$lot->qtechoix}>"/></td>
                                            <td><{$lot->qtechoix}></td>
                                        </tr>
                                        <{/foreach}>

                                   </tbody>
                               </table>
                    </td>
                </tr>
            <{/if}>
            <tr>
                <td>
                    <div>
                        <input id="addLot" type="button" value="ajouter un lot"/>
                    </div>
                </td>
                <td style="text-align:right">
                 <{if $data->lot}>
                     <div style="width:100%">
                         <input type="hidden" id="qtGlobal"  name="qteglob"  value="<{$data->engagement->qte}>"/>
<!--                          <input type="hidden" id="qtGlobal" readonly="true" name="qteglob" disabled="disabled" value="<{$data->engagement->qte}>"/>-->
                         TOTAL   
                         <div class="wraperLabel" style="width:30%;display: inline-block">
                              <label id="LabQt"><{$data->engagement->qte}></label>
                        </div>
                     </div>
                 <{/if}>
                 </td>
           </tr>
            <!--buttton-->
            <tr>
                    <td colspan="2" style="text-align:center;height:40px">
                        <input class="btFormAddLot back"   type="button" value="Retour"/>
                        <input class="btFormAddLot btFormAnnuler"  type="button" value="Annuler"/>
                        <input class="btFormAddLot" id="etape3"   type="submit" value="Etape suivante:Recapitulatif " disabled="disabled"/>
                        
                    </td>
           </tr>
           
    </tbody>
    </table>    
</form>
                    
<script>
   
    // activate bt suite si c'est un retour donc si au moins une checkbox checked
    if($("#tabLots input:checked").length>0 ||!$("#tabLots").length>0 ){
         $("#etape3").removeAttr("disabled");
    }
    
    
    
    //flag old selected
    var oldSelected=null;
    
    //addlot
    $("#addLot").click(function(){
        
        // envois les data formulaire pour memoire       
                $.ajax({
                    url:"/transaction/setcontrat/format/html",
                    data:$("#formSous").serialize(),
                    type:"POST",
                    success:function(data){
                        $("#formSous").css("display","none");
        
                        var idWos=$("#idsous").val();
                        var idWo=$("#idoffre").val();

                        var data={"idwos":idWos,"idwo":idWo}

                        $.ajax({
                            url:"/transaction/addlot/format/html",
                            type:"POST",
                            data:data,
                            success:function(data){

                                $("#main").append(data);
                            }
                        })
                        
                        //scroll page to top and left
                        window.scrollTo(0,0);
                    },
                    error:function(){
                        alert("error")
                    }
                });
        
        
        
    })
    
    // checkboxLot change
    //$("#tabLots").find("input : checkbox").css("display","none")
    
    
         //btback
        $(".back").click(function(){
                var idSous=$("#idsous").val();
                var idOffre=$("#idoffre").val();
                var etape=$("#etapeback").val();
                var produit=$("#produit").val();
                var data={"isback":"true","idsous":idSous,"idoffre":idOffre,"etape":etape,"pdt":produit};
        
                $.ajax({
                    url:"/transaction/setcontrat/format/html",
                    data:data,
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
               
        })
        
        //annulation form
        $(".btFormAnnuler").click(function(){
            
            //reset for dialog
            try{
                 $(".bzModale").remove();
                 $("#cdvTxt").wijdialog("destroy");
                 $("#canvas_siloNav").css("display","block");
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

       
       $('#formSous').submit(function(e){
                
                $("#etape3,.back").attr("disabled","disabled");
                //check qte engagée
                var qteEng=parseFloat($("#qteEng").val());
                var qtGlobal=parseFloat($("#qtGlobal").val());
                
                var min=<{if $this->data->min}><{$this->data->min}><{else}>0<{/if}>;

                var data = $("#tabLots").wijgrid("data");
                
                if(qteEng<=0){
                    alert("La quantité engagée ne peut être nulle ou inferieur à 0.");
                    $("#etape3").removeAttr("disabled");
                    return false;
                }
                
                //engagement mini 
                
                if(qteEng<min){
                    alert("Vous ne pouvez pas entrer une valeur inférieur à la quantité minimale.");
                     $("#etape3").removeAttr("disabled");
                    return false;
                }

                if(parseFloat(qtGlobal)!=parseFloat(qteEng)){
                    
                    //si qte lot disponible suffisante
                    var sommeQteDispo=0
                    $.each(data,function(i,e){
                        //somme des qte disponible
                        sommeQteDispo+=parseFloat(e[6]);
                    })
                    if(sommeQteDispo>qteEng){
                        
                        alert("Votre quantité globale est inferieure à la quantité engagée.veuillez ajuster vos quantités. ")
                        return false;
                    }else{
                        // pas assez de qte lot pour quantité engagées

                            if($("#idauto").val()=="0"){
                                
                                // de  difference quantité
                                var diffQteEng=qteEng-sommeQteDispo;
                                $("#qteManque").empty();
                                $("#qteManque").html(diffQteEng)

                                 $("#dialogQteLess").wijdialog({
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
                                    title:"Quantité insuffisante",
                                    width:"500",
                                    maxHeight:"600",
                                    close:function(){$("#dialogQteLess").wijdialog("destroy")},
                                    open:function(e){
                                           var dialog=$(e.target);
                                                if(!$(".sc-bt-dialog-close").length){
                                                     $(e.target).parent().find(".ui-dialog-titlebar").append("<span class='sc-bt-dialog-close' style='cursor:pointer;position:absolute;right:5px;' ></div>");
                                                            $(".sc-bt-dialog-close").bind("click",function(e){
                                                                dialog.wijdialog('close');
                                                            })
                                                 }
                                    }

                                })

                                    return false;
                                }

                      
                        }
                    
                }else if(parseFloat(qtGlobal)<=0){
                    alert("La quantité globale ne peut être nulle ou inferieur à 0.");
                    return false;
                }
                
                // get lot id & qte       
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
            
           //qteEng change
            $("#qteEng").change(function(e){
                var value=$("#qteEng").val().replace("-","");
                if(!$.isNumeric(value)){
                    alert("La quantité engagée doit être un nombre et ne  pas contenir de virgule mais un point ex: 32.56");
                    value="";
                }
                
                $("#qteEng").val(value);

                if(parseFloat($("#qtGlobal").val())>parseFloat(value)){
                    alert("La somme globale de vos lots est supérieur à votre engagement.Veuillez ajuster vos quantités selectionnées.");
                }

            })
           
            
            // check box change
            function checkBoxChange(e){
                    var startTime=Date.now();
                   //console.log("start",startTime);
                   var selected = $("#tabLots").wijgrid("selection").selectedCells();
                   // get qte for selected row
                   //
                   var qteLotSelected=($("#qteEng").attr("name")=="qte")?selected.item(6).value():selected.item(7).value();
                   var idRow=selected.item(6).rowIndex();
                   var data = $("#tabLots").wijgrid("data");
                   //console.log("data",data);
                   
                   var stock=$(e.target).attr("stock");
                   
                   if($(e.target).is(':checked')){
                   
                        // si engagement pas remplis
                        if($("#qteEng").val()=="" || $("#qteEng").val()==0){
                            //add qte 
                            data[idRow][10]=qteLotSelected;
                            data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" stock="'+stock+'"  class="checkboxLot" value="'+stock+'_'+data[idRow][0]+'_'+qteLotSelected+'" name="checkLot[]" checked="checked"/>';
                            $("#tabLots").wijgrid("ensureControl",false);
                            $("#qteEng").val(qteLotSelected);
                            $("#qtGlobal").val(qteLotSelected);
                        }else{
                            
                            var qtEng=$("#qteEng").val();
                            // qtEng<=qteLotSelected
                            if(parseFloat(qtEng)<=parseFloat(qteLotSelected)){
                                
                               
                                //check if another lot selected
                                if($("#tabLots input:checked").length<=1){
                                    data[idRow][10]=qtEng;
                                    data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" stock="'+stock+'"  class="checkboxLot" value="'+stock+'_'+data[idRow][0]+'_'+qtEng+'" name="checkLot[]" checked="checked"/>';
                                    $("#tabLots").wijgrid("ensureControl",false);
                                     $("#qtGlobal").val(qtEng);
                                    
                                }else{

                                    /*
                                    *verification quantité engagée
                                    */
                                    var somme=0;
                                    $.each($("#tabLots input:checked"),function(i,e){
                         
                                            somme+=parseFloat(data[$(e).attr("rowid")][10]);
                                            
                                    })
                                    
                                    if(somme>=qtEng){
                                    
                                        alert("La quantité engagée est supérieur ou egale à la somme des quantités selectionnées.Veuillez validez ou modifier votre quantité engagée.")
                                        $(e.target).attr("checked",false);
                                    }else{
                                        
                                        var diff=qtEng-somme;
                                        
                                        if(diff<=parseFloat(qteLotSelected)){
                                        
                                            data[idRow][10]=diff;
                                            data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" value="'+stock+'_'+data[idRow][0]+'_'+diff+'"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                                            $("#tabLots").wijgrid("ensureControl",false);
                                            $("#qtGlobal").val(somme+diff);
                                        
                                        }else{
                                            alert("diff<=parseFloat(qteLotSelected)");
                                            /*data[idRow][10]=parseFloat(qteLotSelected)-diff;
                                            data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                                            $("#tabLots").wijgrid("ensureControl",false);
                                            */
                                        }
                                    
                                    }
                 
                                }
                            //qtEng>qteLotSelected
                            }else{
                                
                                if($("#tabLots input:checked").length<=1){

                                    
                                    data[idRow][10]=qteLotSelected;
                                    data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" stock="'+stock+'" value="'+stock+'_'+data[idRow][0]+'_'+qteLotSelected+'"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                                    $("#tabLots").wijgrid("ensureControl",false);
                                     $("#qtGlobal").val(qteLotSelected);
                                  //plusieur checkbox  
                                }else{
                                     
                                    /*
                                    *verification quantité engagée
                                    */
                                    var somme=0;
                                    $.each($("#tabLots input:checked"),function(i,e){
                         
                                            somme+=parseFloat(data[$(e).attr("rowid")][10]);  
                                    })
                                    
                                    if(somme>=qtEng){
                                    
                                        alert("La quantité engagée est supérieur ou egale a la somme des quantités selectionnées.Veuillez validez ou modifier votre quantité engagée.")
                                        $(e.target).attr("checked",false);
                                    }else{

                                        var diff=qtEng-somme;
                                        
                                        if(diff<=parseFloat(qteLotSelected)){
                                        
                                            data[idRow][10]=diff;
                                            data[idRow][9]='<input type="checkbox"  rowid="'+idRow+'" stock="'+stock+'" value="'+stock+'_'+data[idRow][0]+'_'+diff+'"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                                            $("#tabLots").wijgrid("ensureControl",false);
                                            $("#qtGlobal").val(somme+diff);
                                        
                                        }else{

                                            data[idRow][10]=parseFloat(qteLotSelected);
                                            data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" stock="'+stock+'" value="'+stock+'_'+data[idRow][0]+'_'+qteLotSelected+'"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                                            $("#tabLots").wijgrid("ensureControl",false);
                                            $("#qtGlobal").val(parseFloat($("#qtGlobal").val())+parseFloat(qteLotSelected));
                                            
                                        }
                                    
                                    }
                                }
                            }
                           
                        }
                   // checkbox uncheck
                   }else{
                  
                        //reset qtechoix
                        var stock=$(e.target).attr("stock");
                        var qtechoix=data[idRow][10];
                        data[idRow][10]="0";
                        data[idRow][9]='<input type="checkbox"  rowid="'+idRow+'" stock="'+stock+'"  class="checkboxLot" name="checkLot[]"/>';
                        $("#tabLots").wijgrid("ensureControl",false);
                        $("#qtGlobal").val(parseFloat($("#qtGlobal").val())-parseFloat(qtechoix));
                   }
                   
                   $("#qtGlobal").val(parseFloat($("#qtGlobal").val()).toFixed(3));
                   
                   //trigg change pour global label
                   $("#qtGlobal").trigger("change");
                   
                   //disabled enabled
                   if($(".checkboxLot:checked" ).length>0){
                        $("#etape3").removeAttr("disabled");
                    }else{
                         $("#etape3").attr("disabled","disabled");
                    }
    //console.log("diff time",Date.now()-startTime);
            }// fin chekcbox change
            
            //old value
            var oldValue;
            function oldValue(){
                   var selected = $("#tabLots").wijgrid("selection").selectedCells();
                   // get qte for selected row
                  
                   //var idRow=selected.item(0).rowIndex();
                   //var data = $("#tabLots").wijgrid("data");
                   oldValue=selected.item(10).value();
                   
                   
                   
                
            }
            
            /**
            * changement manuel de la valuer du lot
            **/
            function qteChoixUpdate(e){
                    
                   
                   var selected = $("#tabLots").wijgrid("selection").selectedCells();
                   // get qte for selected row
                   var qteLotSelected=($("#qteEng").attr("name")=="qte")?parseFloat(selected.item(6).value()):parseFloat(selected.item(7).value());
                   var idRow=selected.item(6).rowIndex();
                   var data = $("#tabLots").wijgrid("data");
                   var value=selected.item(10).value();
                   var depart=selected.item(3).value();
                   var stock=$(selected.item(9).value()).attr("stock");
//console.log("input",stock);
                   if($.isNumeric(value)){
                        //valeur superieur a qtélot
                        if(parseFloat(value)>qteLotSelected && depart=="Depot"){
                        
                            alert("Vous ne pouvez pas entrer, une valeur supérieur à la quantité du lot de votre dépot.");
                            // si la qtGlobal < la qtgen 
                            if(parseFloat($("#qtGlobal").val())<$("#qteEng").val()){

                                // si qtglobal-qtgen<qteLotSelected alors on pass la difference
                                if(($("#qteEng").val()-parseFloat($("#qtGlobal").val()))<=qteLotSelected){

                                    data[idRow][10]=$("#qteEng").val()-(parseFloat($("#qtGlobal").val()));
                                    data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" stock="'+stock+' " value="'+stock+'_'+data[idRow][0]+'_'+data[idRow][10]+'"  class="checkboxLot" checked="checked" name="checkLot[]"/>';
                                    
                                }
                                //
                                
                                if($("#qteEng").val()-(parseFloat($("#qtGlobal").val()))>qteLotSelected){

                                    data[idRow][10]=qteLotSelected;
                                    data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" stock="'+stock+'" value="'+stock+'_'+data[idRow][0]+'_'+data[idRow][10]+'"  class="checkboxLot" checked="checked" name="checkLot[]"/>';
                                    //<input type="checkbox"  rowid="'+idRow+'" stock="'+stock+'" value="'+stock+'_'+data[idRow][0]+'_'+diff+'"  class="checkboxLot" name="checkLot[]" checked="checked"/>'
                                }   
                                
                                $("#tabLots").wijgrid("ensureControl",false);
                                $("#qtGlobal").val(parseFloat($("#qtGlobal").val())+ data[idRow][10]);
                                //data[idRow][10]=parseFloat($("#qtGlobal").val())-$("#qteEng").val();
                               // data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" name="checkLot[]"/>';
                                 
                            }else{
                                
                                data[idRow][10]=0;
                                $("#tabLots").wijgrid("ensureControl",false);
                                //$("#qtGlobal").val(parseFloat($("#qtGlobal").val())+ data[idRow][10]);
                            }
                        // la valeur est > le lot est ferme il peut etre augmenté automatiquement 
                        }else if(parseFloat(value)>qteLotSelected && depart!="Depot"){
                                
                              // garde l'etat de la ligne selectionné
                              oldSelected=idRow;
                              //console.log("oldSelect1",oldSelected);
                              $("#dialogQteLess2").wijdialog({
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
                                title:"Quantité",
                                width:"500",
                                maxHeight:"600"

                            })
                        
                            // si val <qtlot
                        }else{
                           
                          var qteEng=parseFloat($("#qteEng").val());
                        
                          if(qteEng>0){
                                
                                var value=parseFloat(data[idRow][10]);
                                var somme=0;
                                $.each(data,function(i,e){
                                        // skip this value 
                                        if(i==idRow) return;
                                        somme+=parseFloat(data[i][10]);  
                                })
                                
                                if(value<=qteEng-somme) data[idRow][10]=value;
                                
                                if(value>qteEng-somme) data[idRow][10]=parseFloat(qteEng-somme);
                                
                          }else{
                             //mettre ajour qteEng
                             $("#qteEng").val(value);
                          }
                           
                              
                                data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" stock="'+stock+' " value="'+stock+'_'+data[idRow][0]+'_'+data[idRow][10]+'"  class="checkboxLot" checked="checked" name="checkLot[]"/>';
                                //cas particulier qtEng == somme value =0 on => unchecked
                                 if(qteEng==somme){
                                    alert("votre quantité engagée est atteinte");
                                    data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" stock="'+stock+' " value="'+stock+'_'+data[idRow][0]+'_'+data[idRow][10]+'"  class="checkboxLot" name="checkLot[]"/>';
                                 }
                                $("#tabLots").wijgrid("ensureControl",false);
                                //soustraction de l'ancienne valeur du global
                                $("#qtGlobal").val(parseFloat($("#qtGlobal").val())- parseFloat(oldValue));
                                //ajout de la nouvelle
                                $("#qtGlobal").val(parseFloat($("#qtGlobal").val())+ parseFloat(data[idRow][10]));
                        }
                        
                   }else{
                      data[idRow][10]=0;
                      data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" stock="'+stock+'"  class="checkboxLot" name="checkLot[]"/>';
                      $("#tabLots").wijgrid("ensureControl",false);  
                      alert("vous devez entrer une valeur numérique non nulle.");
                   }
               
                   
                   if(value==0){
                        data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" stock="'+stock+' " value="'+stock+'_'+data[idRow][0]+'_'+data[idRow][10]+'"  class="checkboxLot" name="checkLot[]"/>';
                        $("#tabLots").wijgrid("ensureControl",false);  
                    }
                    
                     //trigg change pour global label
                     $("#qtGlobal").trigger("change");
                     
                     //disabled enabled
                   if($(".checkboxLot:checked" ).length>0){
                        $("#etape3").removeAttr("disabled");
                    }else{
                         $("#etape3").attr("disabled","disabled");
                    }
            
            }
            
            //grid
            try{
                $("#tabLots").wijgrid({
                    //rendered:actions,
                    selectionMode:"singleRow",
                    allowEditing: true,
                    afterCellUpdate: qteChoixUpdate,
                    beforeCellUpdate:oldValue,
                    rendered: function (e){ 
                         
                         $(".checkboxLot").change(function(e){
                            //timeOut car selected change after checkbox change d'ou bad index  a revoir sans timeout
                            setTimeout(function(){
                               
                                checkBoxChange(e);
                    
                            },10)
                            
                            
                         

                        })
                    
                    },
                    selectionChanged: function(){

                    },
                    columns:[{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{dataType:"number",dataFormatString:'n2'}
                    ]
                    
                });
            }catch(error){
            
            }
            
            $("#btOk").click(function(){
                   
                    $("#dialogQteLess2").wijdialog("destroy");
                    var data=$("#tabLots").wijgrid("data");
                    var idLot=data[oldSelected][0];
                    var qte=data[oldSelected][10];
                
                    $.ajax({
                        url:"/transaction/updatelotqte/format/html",
                        data:{"idlot":idLot,"qte":qte},
                        type:"POST",
                        success:function(){
                                alert("success");
                                data[oldSelected][6]=parseFloat(data[oldSelected][10]).toFixed(3);
                                $("#tabLots").wijgrid("ensureControl",false);
                        },
                        error:function(){ 
                            alert("Une erreur s'est produite, La modification n'a peut être pas été prise en compte.");
                            data[oldSelected][10]=parseFloat(data[oldSelected][6]).toFixed(3);
                        }
            
                    })
                    
                    
            })
            
            $("#btKo").click(function(){
                   
                    $("#dialogQteLess2").wijdialog("destroy");

                    var data=$("#tabLots").wijgrid("data");
                    data[oldSelected][10]=parseFloat(data[oldSelected][6]).toFixed(3);
                    $("#tabLots").wijgrid("ensureControl",false);
                  
                    
            })
            
            $("#btAuto").click(function(){
                   
                    $('#idauto').val(1);
                    $("#dialogQteLess").wijdialog("destroy");
                    $('#formSous').trigger('submit');
                    
                    
            })
            
             $("#btCancel").click(function(){

                    $("#dialogQteLess").wijdialog("destroy");
                    $("#etape3,.back").removeAttr("disabled");
            })
            
          /**
          * a passe dans S7
          */
         
            function comaToPoint(myNumber){

                myNumber=myNumber.replace(/[\,]/g,".");
                return myNumber;
            }
            
             $("#qteEng").focus(function(){$("#qteEng").select();});
            
             // changement qtglobal mise a jour label
            
             $("#qtGlobal").change(function(e){
                //update label qtglobal
                
                $("#LabQt").text($("#qtGlobal").val());
            });
            //scroll 
            window.scrollTo(0,0); 
            
        
</script>                       