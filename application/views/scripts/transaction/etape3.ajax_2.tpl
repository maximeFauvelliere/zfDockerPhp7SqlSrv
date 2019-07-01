<div id="dialogQteLess" class="trash" title="Détail de la facture" style="display:none">
    <div>
        Vous ne disposez pas de quantité suffisante pour la quantité que vous avez engagée.<br/>
        Il manque <span id="qteManque"></span> t pour atteindre votre engagement.<br/>
        Vous pouvez créer un nouveau lot de deux facons:<br/>
        <table style="width: 100%">
            <tbody>
                <tr>
                    <td>
                        <h3>Manuellement</h3>
                        <input id="btManu" type="button" value="Manuellement"/>
                    </td>
                    <td>
                        <h3>Automatiquement</h3>
                        <input id="btAuto" type="button" value="Automatique"/>
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
    <div class="bzHeader"><span>Etape 3 : Quantité ou surface à engager</span></div>
    <table class="lot" id="tabLotFormcontent" style="width: 100%">
        <tbody>
          <tr>
                <td>
                    <div class="wraperLabel">
                          <label> Récapitulatif du contrat</label>
                    </div>
                </td>
            </tr> 
            <tr>
                <td style="width:100%">
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
                <td style="width:100%">
                    <div class="wraperLabel">
                          <label> <{$data->engagement->lib}></label>
                    </div>
                </td>
            <tr> 
            <tr>
                <td colspan="2">
                    <input id="qteEng" type="text" name="qte" value="<{$data->engagement->qte}>"/>
                </td>
            </tr>
            <!-- lots-->
            <{if $data->lot}>
                <tr>
                    <td style="width:100%">
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
                                                <{$lot->surface}>
                                            </td>
                                            <td>
                                                <{$lot->structure}>
                                            </td>
                                            <td><input type="checkbox" rowid="<{$lot@index}>" class="checkboxLot"   name="checkLot[]" <{if $lot->choix.checked=="1"}>checked="checked"<{/if}>/></td>
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
                            Quantité globale    <span id="qtGlobal"><{$data->engagement->qte}></span> 
                     </div>
                 <{/if}>
                 </td>
           </tr>
            <!--buttton-->
            <tr>
                    <td colspan="2" style="text-align:center;height:40px">
                        <input class="btFormAddLot back"   type="button" value="Retour"/>
                        <input class="btFormAddLot btFormAnnuler"  type="button" value="Annuler"/>
                        <input class="btFormAddLot" id="etape4"   type="submit" value="Etape suivante:Recapitulatif "/>
                        
                    </td>
           </tr>
           
    </tbody>
    </table>    
</form>
                    
<script>
    
    //addlot
    $("#addLot").click(function(){
        
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
        
    })
    
    // checkboxLot change
    //$("#tabLots").find("input : checkbox").css("display","none")
    
    
         //btback
        $(".back").click(function(){
                var idSous=$("#idsous").val();
                var idOffre=$("#idoffre").val();
                var etape=$("#etapeback").val();
                var data={"isback":"true","idsous":idSous,"idoffre":idOffre,"etape":etape};
        
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
            
            
            getContratsList();
        });

       
       $('#formSous').submit(function(e){


                
                //check qte engagée
                var qteEng=parseFloat($("#qteEng").val());
                var qtGlobal=parseFloat($("#qtGlobal").html());

                var data = $("#tabLots").wijgrid("data");
                


                if(parseFloat(qtGlobal)!=parseFloat(qteEng)){
                    
                    //si qte lot disponible suffisante
                    var sommeQteDispo=0
                    $.each(data,function(i,e){
                        //somme des qte disponible
                        sommeQteDispo+=parseFloat(e[6]);
                    })
                    if(sommeQteDispo>qteEng){
                        
                        alert("Votre quantité globale est inferieure à la quantité engagée.veuillez ajuster vos quantités. ")
                        
                    }else{
                        // pas assez de qte lot pour quantité engagées
                        
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
                            close: { visible: true} 
                            },
                            title:"Quantité insuffisante",
                            width:"500",
                            maxHeight:"600",
                            close:function(){$("#dialogQteLess").wijdialog("destroy")}
                            
                        })
                    }
                    
                    return false;
                    
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
            
            

                if(parseFloat($("#qtGlobal").html())>parseFloat(value)){
                    alert("La somme globale de vos lots est supérieur à votre quantité engagée.Veuillez ajuster vos quantités selectionnées.");
                }

            })
           
            
            // check box change
            function checkBoxChange(e){
                   

                   
                   var selected = $("#tabLots").wijgrid("selection").selectedCells();
                   // get qte for selected row
                   var qteLotSelected=selected.item(6).value();
                   var idRow=selected.item(6).rowIndex();
                   var data = $("#tabLots").wijgrid("data");
                   
                   if($(e.target).is(':checked')){
                   
                        // si engagement pas remplis
                        if($("#qteEng").val()==""){
                            //add qte 
                            data[idRow][10]=qteLotSelected;
                            data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" value="'+data[idRow][0]+'_'+qteLotSelected+'" name="checkLot[]" checked="checked"/>';
                            $("#tabLots").wijgrid("ensureControl",false);
                            $("#qteEng").val(qteLotSelected);
                            $("#qtGlobal").html(qteLotSelected);
                        }else{
                            
                            var qtEng=$("#qteEng").val();
                            // qtEng<=qteLotSelected
                            if(parseFloat(qtEng)<=parseFloat(qteLotSelected)){
                                
                               
                                //check if another lot selected
                                if($("#tabLots input:checked").length<=1){
                                    
                                    
                                    data[idRow][10]=qtEng;
                                    data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" value="'+data[idRow][0]+'_'+qtEng+'" name="checkLot[]" checked="checked"/>';
                                    $("#tabLots").wijgrid("ensureControl",false);
                                     $("#qtGlobal").html(qtEng);
                                    
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
                                            data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" value="'+data[idRow][0]+'_'+diff+'"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                                            $("#tabLots").wijgrid("ensureControl",false);
                                            $("#qtGlobal").html(somme+diff);
                                        
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
                                    data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" value="'+data[idRow][0]+'_'+qteLotSelected+'"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                                    $("#tabLots").wijgrid("ensureControl",false);
                                     $("#qtGlobal").html(qteLotSelected);
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
                                            data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" value="'+data[idRow][0]+'_'+diff+'"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                                            $("#tabLots").wijgrid("ensureControl",false);
                                            $("#qtGlobal").html(somme+diff);
                                        
                                        }else{

                                            data[idRow][10]=parseFloat(qteLotSelected);
                                            data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" value="'+data[idRow][0]+'_'+qteLotSelected+'"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                                            $("#tabLots").wijgrid("ensureControl",false);
                                            $("#qtGlobal").html(parseFloat($("#qtGlobal").html())+parseFloat(qteLotSelected));
                                            
                                        }
                                    
                                    }
                                }
                            }
                        
                        }
                   // checkbox uncheck
                   }else{
                  
                        //reset qtechoix
                        var qtechoix=data[idRow][10];
                        data[idRow][10]="0";
                        data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" name="checkLot[]"/>';
                        $("#tabLots").wijgrid("ensureControl",false);
                        $("#qtGlobal").html(parseFloat($("#qtGlobal").html())-parseFloat(qtechoix));
                   }
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
            
            
            function qteChoixUpdate(e){
            
                
                   var selected = $("#tabLots").wijgrid("selection").selectedCells();
                   // get qte for selected row
                   var qteLotSelected=parseFloat(selected.item(6).value());
                   var idRow=selected.item(6).rowIndex();
                   var data = $("#tabLots").wijgrid("data");
                   var value=selected.item(10).value();
                   
                   
                   if($.isNumeric(value)){
                        //valeur superieur a qtélot
                        if(parseFloat(value)>qteLotSelected){
                        
                            alert("valeur superieur à la quantité du lot.");
                            // si la qtGlobal < la qtgen 
                            if(parseFloat($("#qtGlobal").html())<$("#qteEng").val()){

                                // si qtglobal-qtgen<qteLotSelected alors on pass la difference
                                if(($("#qteEng").val()-parseFloat($("#qtGlobal").html()))<=qteLotSelected){

                                    data[idRow][10]=$("#qteEng").val()-(parseFloat($("#qtGlobal").html()));
                                    data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" value="'+data[idRow][0]+'_'+data[idRow][10]+'"  class="checkboxLot" checked="checked" name="checkLot[]"/>';
                                    
                                }
                                //
                                
                                if($("#qteEng").val()-(parseFloat($("#qtGlobal").html()))>qteLotSelected){

                                    data[idRow][10]=qteLotSelected;
                                    data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" value="'+data[idRow][0]+'_'+data[idRow][10]+'"  class="checkboxLot" checked="checked" name="checkLot[]"/>';
                                    
                                }   
                                
                                $("#tabLots").wijgrid("ensureControl",false);
                                $("#qtGlobal").html(parseFloat($("#qtGlobal").html())+ data[idRow][10]);
                                //data[idRow][10]=parseFloat($("#qtGlobal").html())-$("#qteEng").val();
                               // data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" name="checkLot[]"/>';
                                 
                            }else{
                                
                                data[idRow][10]=0;
                                $("#tabLots").wijgrid("ensureControl",false);
                                //$("#qtGlobal").html(parseFloat($("#qtGlobal").html())+ data[idRow][10]);
                            } 
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
                           
                              
                                data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" value="'+data[idRow][0]+'_'+data[idRow][10]+'"  class="checkboxLot" checked="checked" name="checkLot[]"/>';
                                //cas particulier qtEng == somme value =0 on => unchecked
                                 if(qteEng==somme){
                                    alert("votre quantité engagée est atteinte");
                                    data[idRow][9]='<input type="checkbox" rowid="'+idRow+'" value="'+data[idRow][0]+'_'+data[idRow][10]+'"  class="checkboxLot" name="checkLot[]"/>';
                                 }
                                $("#tabLots").wijgrid("ensureControl",false);
                                //soustraction de l'ancienne valeur du global
                                $("#qtGlobal").html(parseFloat($("#qtGlobal").html())- parseFloat(oldValue));
                                //ajout de la nouvelle
                                $("#qtGlobal").html(parseFloat($("#qtGlobal").html())+ parseFloat(data[idRow][10]));
                        }
                        
                   }else{
                      data[idRow][10]=0;
                      data[idRow][9]='<input type="checkbox" rowid="'+idRow+'"  class="checkboxLot" name="checkLot[]"/>';
                      $("#tabLots").wijgrid("ensureControl",false);  
                      alert("vous devez entrer une valeur numérique non nulle.");
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
            
          /**
          * a passe dans S7
          */
         
            function comaToPoint(myNumber){

                myNumber=myNumber.replace(/[\,]/g,".");
                return myNumber;
            }
            
        
</script>                       