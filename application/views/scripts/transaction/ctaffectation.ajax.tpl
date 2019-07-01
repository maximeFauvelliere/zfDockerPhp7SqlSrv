
<form id="formSous" class="form" name="formSetContrat" method="post" action="">
    
    <input type="hidden" id="idct" name="idct" value="<{$this->idct}>"/>
    <div class="bzHeader"><span>Affectation des contrats au stock ferme</span></div>
    <table class="lot" id="tabLotFormcontent" style="width: 100%">
        <tbody>
            <!-- messsage si lot insuffisant pour affectation du contrats-->
            <{if $this->valid==0}>
            <tr>
                <td colspan="2" style="width:100%">
                    <div class="wraperLabel" style="background-color: red;height:50px;">
                          <p> Vous n’avez pas assez de stock disponible pour affecter ce contrat.<br/> Veuillez créer des lots dans votre stock ferme (partie prospection) pour pouvoir affecter ce contrat.</p>
                    </div>
                </td>
            </tr>
            <{/if}>
            <!--detail contrat-->
            <tr>
                <td colspan="2" style="width:100%">
                    <div class="wraperLabel">
                          <label> DETAIL CONTRAT</label>
                    </div>
                </td>
            <tr> 
            <tr>
                <td colspan="2">
                    <table class="recap" id="recap" style="width:100%"><tbody></tbody></table>
                </td>
            </tr>
            <!-- lots-->
             <tr>
                <td colspan="2" style="width:100%">
                    <div class="wraperLabel">
                          <label> LOTS DISPONIBLES</label>
                    </div>
                </td>
            <tr> 
            <tr>
                <td colspan="2" style="width:100%">
                    <table id="listeLots"></table>

                </td>
           </tr>
           <!--total-->
           <tr>
               <td style="width:85%">
               </td>
               <td>
                   <div style="width:100%">
                         <div class="wraperLabel" style="display: inline-block;float:right">
                              Total Lot(s) <label id="totalLots">00.000</label>
                        </div>
                         <div class="wraperLabel" style="display: inline-block;float:right">
                              <label style="width:200px">Qté Contrat</label> <label id="qtCt">00.000</label>
                        </div>
                        
                     </div>
               </td>
           </tr>
            <!--buttton-->
            <tr>
                    <td colspan="2" style="text-align:center;height:40px">
                        
                        <input class="btFormAddLot btFormAnnuler"  type="button" value="Annuler"/>
                        <{if $this->valid==1}><input class="btFormAddLot" id="btvalid"   type="submit" value="Valider" disabled="disabled"/><{/if}>
                        
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
        $("#preloader").css("display","none");
               
    }catch(error){
    
    };
    
    //data 
    var data=<{$this->data}>;
    
    var pageSize=<{$this->pageSize}>;
    
    var recap=data.lots.recap;
    
    var lots=data.lots.lot;
    
    // type de l'engagement pour le contrat en surf ou en qt
    var engageType="qte";
    
    try{
        if(data.lots.surf){
       
            engageType="surf";
            var qte=parseFloat(data.lots.surf);
        }else if(data.lots.qte){
            var qte=parseFloat(data.lots.qte);
            
        }
        
    }catch(e){
    
    }
    
    
    if(!isArray(lots)){
          lots=convertToArray(lots);
    }
    //flag old selected
    var oldSelected=null;

    // show qte contrat
    $("#qtCt").html(qte);
    
   
        //annulation form
        $(".btFormAnnuler").click(function(){
            
            //reset for dialog
            try{
                 $(".bzModale").remove();
                 $("#canvas_siloNav").css("display","block");
            }catch(error){
        
            }

            $("#preloader").css("display","block");
            $("#main").empty();
            
            location.hash="transaction_index";
        });

       
       $('#formSous').submit(function(e){
                
      
                // get lot id & qte       
                $.ajax({
                    url:"/transaction/ctaffectvalid/format/json",
                    data:$(this).serialize(),
                    type:"POST",
                    success:function(data){
                       
                        $("#main").empty();
                        if(data.erreur==0){
                            alert("contrat affecté avec succés");
                            location.hash="transaction_ctaffectationlist";
                        }else if(data.erreur==2){
                            alert(data.msg);
                            location.hash="transaction_ctaffectationlist";
                        }else{
                            alert("Une erreur a peut se produire, il est possible que votre contrat ne soit pas affecté.");
                            location.hash="transaction_ctaffectationlist";
                        }
                        
                        //scroll page to top and left
                        window.scrollTo(0,0);
                    },
                    error:function(){
                        alert("error")
                    }
                });
                
                return false;
            });
            

            // check box change
            function checkBoxChange(e){
           
                  
                   var qteCtSelected=qte
                   //console.log("qteCtSelected",qteCtSelected);
                  
                   var selectedLot = $("#listeLots").wijgrid("selection").selectedCells();
                   var idRow=selectedLot.item(6).rowIndex();
                   var data = $("#listeLots").wijgrid("data");
                   
                   var idLot=data[idRow]['id'];
                   //console.log("idLot",idLot);
                   //console.log("data",data)
                   // get qte for selected row
                   //
                   var qteLotSelected=(engageType=="surf")?selectedLot.item(6).value():selectedLot.item(5).value();
                   qteLotSelected=parseFloat(qteLotSelected);
                   //console.log("qteLotsSelected",qteLotSelected);
                   
                   // si le lot n'est pas selectionnable car contrat en surface
                    if($(e.target).attr("bzenable")==0){
                        alert("Vous ne pouvez pas affecter ce lot à un contrat en surface.");
                        data[idRow]['Choix']='<input type="checkbox" class="checkboxLot" qtedepart="'+qteLotSelected+'" bzenable="0" name="checkLot[]" />';
                        $("#listeLots").wijgrid("ensureControl",false);
                        return;
                   }
                   
                   // si lot affectable 
                   if($(e.target).is(':checked')){
                   
                        //last
                        /*
                        *verification quantité engagée
                        */
                        var somme=0;
                        $.each($("#listeLots input:checked"),function(i,e){
                       
                                if($.isNumeric($(e).attr("qtedepart"))){
                                    somme+=parseFloat($(e).attr("qtedepart"));
                                }
   
                        })
                       
                        // qtelot+somme<=qteCt
                        if(somme<=qteCtSelected){
                        
                            data[idRow]['Choix Qté/Surf']=qteLotSelected;
                            data[idRow]['Choix']='<input type="checkbox"  qtedepart="'+qteLotSelected+'" value="'+idLot+"_"+qteLotSelected+'" bzenable="1"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                            $("#listeLots").wijgrid("ensureControl",false);
                            $("#totalLots").html(somme);
                        
                        }else if(somme>qteCtSelected){
                            
                            // check totalLot>= qtct
                            if(parseFloat($("#totalLots").html())>=qteCtSelected){
                                alert("votre quantité pour ce contrat est atteinte.");
                                data[idRow]['Choix']='<input type="checkbox"  qtedepart="'+qteLotSelected+'" bzenable="1"  class="checkboxLot" name="checkLot[]"/>';
                                $("#listeLots").wijgrid("ensureControl",false);
                                return;
                            }
                           
                            
                            data[idRow]['Choix Qté/Surf']=qteLotSelected-(somme-qteCtSelected);
                            data[idRow]['Choix']='<input type="checkbox"  qtedepart="'+qteLotSelected+'" value="'+idLot+"_"+data[idRow]['Choix Qté/Surf']+'" bzenable="1"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                            $("#listeLots").wijgrid("ensureControl",false);
                            $("#totalLots").html(qteCtSelected);
                        
                        }
 
                   // checkbox uncheck
                   }else{
                  
                        //reset qtechoix
                        var qteless=data[idRow]['Choix Qté/Surf'];
                        data[idRow]['Choix Qté/Surf']="";
                        data[idRow]['Choix']='<input type="checkbox"  qtedepart="'+qteLotSelected+'" bzenable="1"  class="checkboxLot" name="checkLot[]" />';
                        $("#listeLots").wijgrid("ensureControl",false);
                        $("#totalLots").html(parseFloat($("#totalLots").html())-parseFloat(qteless));
                   }
                   
                   //check si btvalid disabbled or enable
                   
                    //disabled enabled
                    if(parseFloat($("#totalLots").html())==qteCtSelected){
                        $("#btvalid").removeAttr("disabled");
                    }else{
                         $("#btvalid").attr("disabled","disabled");
                    }
                   
                   $("#totalLots").html(parseFloat($("#totalLots").html()).toFixed(3));
                   
  
            }// fin chekcbox change
            
            //old value
            var oldValue;
            function oldValue(){
                   
                   var selected = $("#listeLots").wijgrid("selection").selectedCells();
                   oldValue=parseFloat(selected.item(9).value()); 
                   oldValue=oldValue || 0;
                   
            }
            
            /**
            * changement manuel de la valuer du lot
            **/
            function qteChoixUpdate(e){
           
                   
                   
                   var qteCtSelected=qte;
                   
                   var selectedLot = $("#listeLots").wijgrid("selection").selectedCells();
                   // get qte for selected row
                   var qteLotSelected=(engageType=="surf")?selectedLot.item(6).value():selectedLot.item(5).value();
                   var idRow=selectedLot.item(6).rowIndex();
                   var data = $("#listeLots").wijgrid("data");
                   var value=Math.abs(selectedLot.item(9).value());
                   
                   var idLot=data[idRow]['id'];
                  
                    // si le lot n'est pas selectionnable car contrat en surface
                    if($(data[idRow]['Choix']).attr("bzenable")==0){
                        alert("Vous ne pouvez pas affecter ce lot à un contrat en surface.");
                        data[idRow]['Choix Qté/Surf']=0;
                        $("#listeLots").wijgrid("ensureControl",false);
                        return;
                   }
                   
                   //value =0
                   if(value==0) return;
                   
                  
                   if($.isNumeric(value)){
                        //somme lot checked
                         var somme=0;
                            //somme checked lots
                            $.each(data,function(i,e){
                                    // skip this value 
                                    somme+=parseFloat(data[i]['Choix Qté/Surf'])?parseFloat(data[i]['Choix Qté/Surf']):0;  
                            })
                        //valeur superieur a qtélot
                        if(parseFloat(value)>qteLotSelected){
                            //console.log("value>qteLotSelected")
                            alert("Vous ne pouvez pas entrer, une valeur supérieur à la quantité du lot.");
                            // si la somme < qtct 
                            /*console.log("somme",somme);
                            console.log("value",value);
                            console.log("qtct",qteCtSelected);*/
                            if(parseFloat(somme)<qteCtSelected){
                            
                                //valuemax = qtlot
                                var valuemax=qteLotSelected
                                data[idRow]['Choix Qté/Surf']=valuemax;
                                data[idRow]['Choix']='<input type="checkbox"   qtedepart="'+qteLotSelected+'" value="'+idLot+"_"+valuemax+'"  class="checkboxLot" bzenable="1" checked="checked" name="checkLot[]"/>';

                                
                                $("#listeLots").wijgrid("ensureControl",false);
                                $("#totalLots").html(parseFloat((somme-value)+parseFloat(valuemax)));
                            
                            }else{
                                //console.log("somme>qtct")
                                var sommePart=somme-value;
                                //console.log("sommepart",sommePart);
                                var valueMax=parseFloat(qteLotSelected);
                                //console.log("valueMax",valueMax)
                                var valueCo=0;
                                for(i=0;i<=valueMax;i++){
                                    //console.log("i",i)
                                    if(sommePart+i>=qteCtSelected){
                                        valueCo=i; 
                                        break;
                                    }
                                    
                                    valueCo=i;
                                }
                                
                                //console.log("valueCo",valueCo);
                                data[idRow]['Choix Qté/Surf']=valueCo;
                                data[idRow]['Choix']='<input type="checkbox"   qtedepart="'+qteLotSelected+'" value="'+idLot+"_"+valueCo+'"  class="checkboxLot" bzenable="1" checked="checked" name="checkLot[]"/>';

                                $("#listeLots").wijgrid("ensureControl",false);
                                $("#totalLots").html(parseFloat(sommePart+parseFloat(valueCo)));
                            
                            }
                        // value <= qtelotselected
                        }else{
                            //console.log("value<qteLotSelected")
                            var qteCtSelected=parseFloat(qte)
 
                            //var value=Math.abs(parseFloat(data[idRow]['Choix Qté/Surf']));
                           
                            
                            // qtelot+somme<=qteCt
                            if(somme<=qteCtSelected){
                                //console.log("somme<=qteCtSelected");
                                //console.log("somme",somme);
                                var diff=qteCtSelected-somme;
                                //console.log("diff",diff);
                                //cas ou la valeur est < a la difference (retour negatif)
                                if(diff>value){
                                    //console.log("diff>value");
                                    data[idRow]['Choix Qté/Surf']=value;
                                    data[idRow]['Choix']='<input type="checkbox"  qtedepart="'+qteLotSelected+'" value="'+idLot+"_"+value+'" bzenable="1"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                                }else{
                                    //cas ou la valeur est < a la difference 
                                    //console.log("diff<value");
                                    data[idRow]['Choix Qté/Surf']=value;
                                    data[idRow]['Choix']='<input type="checkbox"  qtedepart="'+qteLotSelected+'" value="'+idLot+"_"+value+'" bzenable="1"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                                }
                                
                                $("#listeLots").wijgrid("ensureControl",false);
                                $("#totalLots").html(parseFloat(somme));

                            }else if(somme>qteCtSelected){
                            
                                //console.log("somme>qteCtSelected");
                                //console.log("somme",somme);
                                // check totalLot>= qtct
                                  
                                    //console.log("(somme-value)-qteCtSelected",qteCtSelected-(somme-value));
                                    alert("votre quantité pour ce contrat est atteinte.");
                                    data[idRow]['Choix Qté/Surf']=qteCtSelected-(somme-value);
                                    data[idRow]['Choix']='<input type="checkbox"  qtedepart="'+qteLotSelected+'" value="'+idLot+"_"+(qteCtSelected-(somme-value))+'" bzenable="1"  class="checkboxLot" name="checkLot[]" checked="checked"/>';
                                    $("#listeLots").wijgrid("ensureControl",false);

                                    // si somme > qtctSelected
                                    $("#totalLots").html(qteCtSelected);

                            }
                            
                            
                        }
                        
                   }else{
                   
                      data[idRow]['Choix Qté/Surf']=0;
                      data[idRow]['Choix']='<input type="checkbox"  class="checkboxLot" bzenable="1" qtedepart="'+qteLotSelected+'" name="checkLot[]"/>';
                      $("#listeLots").wijgrid("ensureControl",false);  
                      alert("vous devez entrer une valeur numérique non nulle.");
                   }
               
                   
                   if(value==0){
                        data[idRow]['Choix']='<input type="checkbox" qtedepart="'+data[idRow]['Choix Qté/Surf']+'"  class="checkboxLot" name="checkLot[]"/>';
                        $("#listeLots").wijgrid("ensureControl",false);  
                    }
                    
                    
                     //disabled enabled bt valid 
                   if(parseFloat($("#totalLots").html())==qteCtSelected){
                       
                        $("#btvalid").removeAttr("disabled");
                    }else{
                        
                         $("#btvalid").attr("disabled","disabled");
                    }
            
            }//fin qteChoixUpdate
            

            // fully recap 
            $("#recap tbody").empty();
                $.each(recap,function(i,e){
                    var a="<tr><td>"+e['@attributes']['lib']+"</td><td>"+e['@text']+"</td></tr>";
                    $("#recap tbody").append(a);
                })

            // reader lots
            var readerLots= new wijarrayreader([
                            {name:'id',mapping:function(item){return item['id']['@text']}},
                            {name:'Camp.',mapping:function(item){return item['camp']['@text']}},
                            {name:'Cult.',mapping:function(item){return item['cult']['@text']}},
                            {name:'Stock',mapping:function(item){return item['stock']['@text']}},
                            {name:'Nom lot',mapping:function(item){return item['nom']['@text']}},
                            {name:'Type',mapping:function(item){return item['type']['@text']}},
                            {name:'Qte.',mapping:function(item){return item['qte']['@text']}},
                            {name:'Surf.',mapping:function(item){return item['surf']['@text']}},
                            {name:'Struct.',mapping:function(item){return item['structure']['@text']}},
                            {name:'Choix',mapping:function(item){
                                var qt=null;
                                if(engageType=="surf"){
                                    qt=item['surf']['@text'];
                                }else{
                                    qt=item['qte']['@text'];
                                }
                                return '<input type="checkbox" class="checkboxLot" <{if $this->valid==0}>disabled="disabled"<{/if}> qtedepart="'+qt+'" bzenable="'+item['enable']+'" name="checkLot[]"/>';
                            }},
                            {name:'Choix Qté/Surf',mapping:function(item){return ''}}
            ]); 
            
            //grid lot
            try{
                setTimeout(function(){

                             $("#listeLots").wijgrid({
                                    //rendered:actions,
                                    //selectionMode:"singleRow",
                                    allowSorting:false,
                                    allowPaging: false,
                                    pageSize: pageSize,
                                    allowEditing: true,
                                    afterCellUpdate: qteChoixUpdate,
                                    beforeCellUpdate:oldValue,
                                    data:new wijdatasource({
                                        reader:readerLots,
                                        data:lots
                                    }),
                                    rendered: function (e){ 
                                         $(".checkboxLot").change(function(e){
                                            //timeOut car selected change after checkbox change d'ou bad index  a revoir sans timeout
                                            setTimeout(function(){

                                                checkBoxChange(e);

                                            },10)

                                        })

                                    },
                                    selectionChanged: function(){
                                        //ctChange();
                                        
                                    },
                                    columns:[{visible:false},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{readOnly: true},{<{if $this->valid==0}>readOnly:true,<{/if}>dataType:"number",dataFormatString:'n3'}
                                        ]
                                });
                },10)
               
            }catch(error){
            
            }

          
            function comaToPoint(myNumber){

                myNumber=myNumber.replace(/[\,]/g,".");
                return myNumber;
            }

            //scroll 
            window.scrollTo(0,0); 
            
        
</script>                       