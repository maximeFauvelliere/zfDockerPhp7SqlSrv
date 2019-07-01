<form id="setContrat" class="form" name="formSetContrat" method="post" action="">
    
    <input type="hidden" name="idsous" value="<{$data->idsous}>"/>
    <input type="hidden" name="etape" value="4"/>
    <div class="bzHeader"><span>Etape 3 : Quantité ou surface à engager</span></div>
    <table class="lot" id="tabLotFormcontent" style="max-width: 900px">
        <tbody>
          <tr>
                <td>
                    <div class="wraperLabel">
                          <label> Récapitulatif du contrat</label>
                    </div>
                </td>
            <tr> 
            <tr>
                <td colspan="2">
                    <{foreach from=$data->recap item=recap}>
                           <table class="recap">
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
                <td>
                    <div class="wraperLabel">
                          <label> <{$data->engagement->lib}></label>
                    </div>
                </td>
            <tr> 
            <tr>
                <td colspan="2">
                    <input id="qteEng" type="text" name="qte"/>
                </td>
            </tr>
            <!-- lots-->
            <{if $data->lot}>
                <tr>
                    <td>
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

                                           <th>Choix</th>
                                           <th>Choix.Qté</th>
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
                                            <td><input type="checkbox" class="checkboxLot" name="choix"/></td>
                                            <td></td>
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
                            Quantité globale    <span   id="qtGlobal"></span> 
                     </div>
                 <{/if}>
                 </td>
           </tr>
            <!--buttton-->
            <tr>
                    <td colspan="2" style="text-align:center;padding-left:30%;padding-right:30%;height:40px">
                        <input class="btFormAddLot" class="back"  type="button" value="Retour"/>
                        <input class="btFormAddLot btFormAnnuler"  type="button" value="Annuler"/>
                        <input class="btFormAddLot" id="etape4"  style="" type="submit" value="Etape suivante : Quantité"/>
                    </td>
           </tr>
           
    </tbody>
    </table>    
</form>
                    
<script>
    
    //addlot
    $("#addLot").click(function(){
        
        $("#setContrat").css("display","none");
        
        $.ajax({
            url:"/transaction/addlot/format/html",
            success:function(data){
                
                $("#main").append(data);
            }
        })
        
    })
    
    // checkboxLot change
    //$("#tabLots").find("input : checkbox").css("display","none")
    
    //btback
        $("#btBack1").click(function(){
        
                $(".etape1").css("display","table-row");
                $(".etape2").css("display","none");
        })
        
        $("#btBack2").click(function(){
        
                $(".etape2").css("display","table-row");
                $(".etape3").css("display","none");
        })
        
        //annulation form
        $(".btFormAnnuler").click(function(){
            
            //reset for dialog
            try{
                 $(".bzModale").remove();
                 $("#cdvTxt").wijdialog("destroy");
            
                 $("#popUpValid").wijdialog("destroy");
                 $("#popUpValid").remove();
            }catch(error){
        
            }
           
            
            getContratsList();
        });

       
       $('#setContrat').submit(function(){

                ("serialize form",$(this).serialize());
                
                //un lot doit etre selectionné

                $.ajax({
                    url:"/transaction/setcontrat/format/html",
                    data:$(this).serialize(),
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
            
            
            function checkBoxChange(e){
                   
                   ("checked",$(e.target).is(':checked'));
                   
                   if($(e.target).is(':checked')){
                   
                         var selected = $("#tabLots").wijgrid("selection").selectedCells();
                         // get qte for selected row
                         var qteLotSelected=selected.item(6).value();
                         var idrow=selected.item(6).rowIndex();

                        // si engagement pas remplis
                        if($("#qteEng").val()==""){
                            //add qte 
                            $("#qteEng").val(qteLotSelected)
                        }else{
                            
                            if(parseInt($("#qteEng").val())<=parseInt(qteLotSelected)){
                                ("qteEng<=qteLotSelected")
                                //selected.item(10).value();

                                data = $("#tabLots").wijgrid("data");
                                data[idrow][10]=$("#qteEng").val();
                                $("#tabLots").wijgrid("ensureControl",false);
                                
                                
                            }
                        
                        }
                   
                   }
                   
            
            
            }
            
            
            
            //grid
            try{
                $("#tabLots").wijgrid({
                    //rendered:actions,
                    selectionMode:"singleRow",    
                    rendered: function (e){ 
                         
                         $(".checkboxLot").change(function(e){
                            //timeOut car selected change after checkbox change d'ou bad index  a revoir sans timeout
                            setTimeout(function(){
                               
                                checkBoxChange(e);
                    
                            },10)
                            
                            
                         

                        })
                    
                    },
                    selectionChanged: function(){
                        ("selection change");
                    },
                    columns:[{},{},{},{},{},{},{},{},{},{},{
                           cellFormatter: function (args) {
            if (args.row.type & $.wijmo.wijgrid.rowType.data) {
                 args.$container
                     .empty()
                     .append(
                        $("<input type='checkbox' class='mycb' />")
                          .click(function (e) {
                              e.stopPropagation();
                            })
 
                          .change(function (e) {
                              //add the row if checkbox is selected
                              if (e.target.checked) {
                                  //$("#tabLots").wijgrid("selection").addRows(args.row._dataTableRowIndex);
                                   var selected = $("#tabLots").wijgrid("selection").selectedCells();
                                    // get qte for selected row
                                   ("item",selected.item(10).value());
                                  ("checked")
                               } else {
                                  // $("#tabLots").wijgrid("selection").removeRows(args.row._dataTableRowIndex);
                                  ("unchecked")
                                }
                             })
                      );
                  return true;
              }
                        
                    }
                    }
                    ]
                    
                });
            }catch(error){
            
            }
            
          
            
            
        
</script>                       