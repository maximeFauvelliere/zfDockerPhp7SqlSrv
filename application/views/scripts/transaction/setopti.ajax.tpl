

<form id="formOpti" class="form" name="formSetContrat" method="post" action="">
    
    <input id="idwohb" type="hidden" name="idwohb" value="<{$this->idwohb}>"/>
    <input id="idwo" type="hidden" name="idwo" value="<{$this->idwo}>"/>
    <input type="hidden" id="etape" name="etape" value="etape1"/>
    <input type="hidden" id="etapeprec" name="etapeprec" value="init"/>
    <input type="hidden" id="min" name="min" value="<{$data->recap['min']}>"/>
    <div class="bzHeader"><span>Commercialisation optimiz</span></div>
    <table class="contrat" id="tabLotFormcontent" style="width: 100%">
        <tbody>
           <tr style="width: 100%;height: 30px;">
            </tr>
          <tr>
                <td colspan="2">
                    <div class="wraperLabel">
                          <label> Récapitulatif de l'optimiz</label>
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
          
            
            <!-- contrats-->
            <{if $data->contrat}>
                <tr>
                    <td colspan="2" style="width:100%">
                        <div class="wraperLabel">
                            <label> Contrats</label><label style="float:right;padding-right:20px">*Minimum engagement pour cette culture :<{$data->recap['min']}> </label>
                        </div>
                    </td>
                <tr> 
                <tr>
                    <td colspan="2">

                        <table id="tabContrats">
                                   <thead>
                                               <{foreach from=$data->contrat item=contrat name=contrat}>
                                                    <{if $contrat@first}>
                                                        <{foreach from=$contrat item=lib }>
                                                            <th>
                                                                <{$lib.lib}>
                                                            </th>
                                                        <{/foreach}>
                                                    <{/if}>
                                               <{/foreach}>

                                           
                                   </thead>
                                   <tbody>
                                        <{foreach from=$data->contrat item=contrat}>
                                        <tr>
                                            <td>
                                                <{$contrat->id}>
                                            </td>
                                            <td>
                                                <{$contrat->camp}>
                                            </td>
                                            <td>
                                                <{$contrat->cult}>
                                            </td>
                                            <td>
                                                <{$contrat->ct}>
                                            </td>
                                            <td>
                                                <{$contrat->px}>
                                            </td>
                                            <td>
                                                <{$contrat->pxac}>
                                            </td>
                                            <td>
                                                <{$contrat->qte}>
                                            </td>
                                            <td>
                                                <{$contrat->surf}>
                                            </td>
                                            <td>
                                                <{$contrat->structure}>
                                            </td>                       
                                            <td><input type="checkbox" rowid="<{$contrat@index}>"  class="checkboxLot"   name="checkLot[]" <{if $contrat->choix.checked=="1"}>checked="checked"<{/if}> value="<{$contrat->id}>_<{$contrat->qtechoix}>_<{$contrat->surf}>"/></td>
                                            <td><{$contrat->qtechoix}></td>
                                        </tr>
                                        <{/foreach}>

                                   </tbody>
                               </table>
                    </td>
                </tr>
            <{else}>
                <tr>
                    <td>
                        <div style="width:100%;text-align: center"><h4>Vous devez disposer de contrats avant d'utiliser un optimiz.</h4></div>
                    </td>
                </tr>
            <{/if}>
          
            <!--buttton-->
            <tr>
                    <td colspan="2" style="text-align:center;height:40px">
                        <input class="btFormAddLot btFormAnnuler"  type="button" value="Annuler"/>
                        <input class="btFormAddLot" id="etapeInit"   type="submit" value="Etape suivante:Validation" disabled="disabled"/>
                        
                    </td>
           </tr>
           
    </tbody>
    </table>    
</form>
                    
<script>
    
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
    }catch(error){
    
    };
    
            /**
            * changement manuel de la valeur du lot
            **/
            function qteChoixUpdate(e){
                     
                   var selected = $("#tabContrats").wijgrid("selection").selectedCells();
                   var qte=parseFloat(selected.item(5).value());
                   var surfLotSelected=parseFloat(selected.item(6).value());
                   var qteLotSelected=(surfLotSelected>0)?surfLotSelected:qte;
                   var idRow=selected.item(0).rowIndex();
                   var data = $("#tabContrats").wijgrid("data");
                   var value=selected.item(9).value();
                   var min=parseInt($("#min").val());

                   if($.isNumeric(value)){
                        //valeur superieur a qtélot
                        if(parseFloat(value)>qteLotSelected){
                        
                            alert("Vous ne pouvez pas entrer une valeur supérieur à la quantité de votre contrat.");
                            data[idRow][10]=(qteLotSelected>=min)?qteLotSelected:0;
                            
                            //value ==0
                            if(parseFloat(value)>0 && data[idRow][10]>0){
                                data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" value="'+data[idRow][0]+'_'+qte+'_'+surfLotSelected+'"  checked="checked" name="checkLot[]"/>';
                            }else{
                                
                                data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" value="'+data[idRow][0]+'_'+qte+'_'+surfLotSelected+'"name="checkLot[]"/>';
                            }
                            
                            $("#tabContrats").wijgrid("ensureControl",false);
                        // la valeur est < 
                        }else{ 
                        
                                if(parseFloat(value)<min){
                                    alert("Vous ne pouvez pas entrer une valeur inférieur à la valeur plancher.");
                                    data[idRow][10]=0;
                                    data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" value="'+data[idRow][0]+'_'+qte+'_'+surfLotSelected+'" name="checkLot[]"/>';
                                    $("#tabContrats").wijgrid("ensureControl",false);
                                    return;
                                }
                                data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" value="'+data[idRow][0]+'_'+qte+'_'+surfLotSelected+'" name="checkLot[]" checked="checked"/>';
                                //cas particulier qtEng == somme value =0 on => unchecked
                                $("#tabContrats").wijgrid("ensureControl",false);
                        }
                        
                   }else{
                    //if is not numerique
                      data[idRow][10]=0;
                      data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" value="'+data[idRow][0]+'_'+qte+'_'+surfLotSelected+'" name="checkLot[]"/>';
                      $("#tabContrats").wijgrid("ensureControl",false);  
                      alert("vous devez entrer une valeur numérique non nulle.");
                   }
               
                   
                   if(value==0){
                        data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" value="'+data[idRow][0]+'_'+qte+'_'+surfLotSelected+'" name="checkLot[]"/>';
                        $("#tabContrats").wijgrid("ensureControl",false);  
                    }
                    
                    if($(".checkboxLot:checked" ).length>0){
                        $("#etapeInit").removeAttr("disabled");
                    }else{
                         $("#etapeInit").attr("disabled","disabled");
                    }
                    
                    
                  
            }
            
             //old value
            var oldValue;
            function oldValue(){
                   var selected = $("#tabContrats").wijgrid("selection").selectedCells();
                   // get qte for selected row
                   //var idRow=selected.item(0).rowIndex();
                   //var data = $("#tabContrats").wijgrid("data");
                  
                   oldValue=selected.item(9).value();
            }
    
        setTimeout(function(){
             //grid
            try{
                $("#tabContrats").wijgrid({
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
                    columns:[{visible: false},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{dataType:"number",dataFormatString:'n3'}
                    ]
                    
                });
            }catch(error){
            
            }
        },10)
        
        
        // check box change
            function checkBoxChange(e){


                   var selected = $("#tabContrats").wijgrid("selection").selectedCells();
                   // get qte for selected row
                   //selected.item(0).row().data['is_waiting'];
                   var qteLotSelected=selected.item(5).value();
                   var surfLotSelected=selected.item(6).value();
                   var idRow=selected.item(0).rowIndex();
                   var data = $("#tabContrats").wijgrid("data");
                   
                   
                   
                   /*console.log("qteLotSelected",qteLotSelected);
                   console.log("surfLotSelected",surfLotSelected);
                   console.log("idRow",idRow);
                   console.log("data[idRow][10]",data[idRow][10])*/
                   
                   if($(e.target).is(':checked')){
                       
                            data[idRow][10]=(parseFloat(surfLotSelected)>0)?surfLotSelected:qteLotSelected;
                            data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" value="'+data[idRow][0]+'_'+qteLotSelected+'_'+surfLotSelected+'" name="checkLot[]" checked="checked"/>';
                            $("#tabContrats").wijgrid("ensureControl",false);
                   // checkbox uncheck
                   }else{
                  
                        //reset qtechoix
                        data[idRow][10]="0";
                        data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" value="'+data[idRow][0]+'_'+qteLotSelected+'_'+surfLotSelected+'" name="checkLot[]"/>';
                        $("#tabContrats").wijgrid("ensureControl",false);
 
                   }
                   
                   if($(".checkboxLot:checked" ).length>0){
                        $("#etapeInit").removeAttr("disabled");
                   }else{
                         $("#etapeInit").attr("disabled","disabled");
                   }

            }// fin chekcbox change

        //annulation form
        $(".btFormAnnuler").click(function(){
            
            //reset for dialog
            try{
                 $(".bzModale").remove();
                 $("#cdvTxt").wijdialog("destroy");
                 $("#canvas_siloNav").css("display","block");
            }catch(error){
        
            }
           
           //voir requete pour  anulation offre optimize 
           /* $.ajax({     
                url:"/transaction/setopti/format/html",
                data:{"idsous":<{$data->idsous}>},
                type:"POST"
            })*/
           $("#tabContrats").wijgrid("destroy");
           location.hash="transaction_getoffreopti";
           $(window).trigger("hashchange");
        });

       
       $('#formOpti').submit(function(e){
       
                
                 // check si un opti  selected
                 //console.log("chk",$( ".radioContrat:checked" ).length)
                 if(!$( ".checkboxLot:checked" ).length==1){
                    alert("Vous devez sélectionner un contrat, avant de poursuivre.");
                    return false;
                 }
                 
                 $("#etapeInit,.back").attr("disabled","disabled");
    
                // get contrat id & qte       
                $.ajax({
                    url:"/transaction/setopti/format/html",
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
            })
            
            

            
            //scroll 
            window.scrollTo(0,0); 
            
        
</script>                       