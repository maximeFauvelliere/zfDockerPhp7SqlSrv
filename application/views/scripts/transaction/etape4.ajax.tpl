<form id="formSous" class="form" name="formSetContrat" method="post" action="">
    
    <input type="hidden" id="idsous" name="idsous" value="<{$data->idsous}>"/>
    <input type="hidden" id="idoffre" name="idoffre" value="<{$data->idoffre}>"/>
    <input type="hidden" name="etape" value="5"/>
    <input type="hidden" id="produit" name="pdt" value="<{$pdt}>"/>
<!--    <input type="hidden" id="etapeprec" name="etapeprec" value="4"/>-->
    <input type="hidden" id="etapeback" name="back" value="<{$this->back}>"/>
    <div class="bzHeader"><span>Etape : Récapitulatif du contrat</span></div>
    <table  id="tabLotFormcontent" style="max-width: 900px">
        <tbody>
          <tr>
                <td colspan="2">
                    <div class="wraperLabel">
                          <label> Récapitulatif du contrat</label>
                    </div>
                </td>
            </tr> 
            <tr>
                <td colspan="2">
                    <table class="recap">
                        <tbody>
                            <{foreach from=$data->recap item=recap}>
                            <{foreach from=$recap key=key item=item}>
                                    <{if $key!='optimiz'&& $key!='securiz'}>
                                        <tr>
                                            <td> <{$item.lib}></td>
                                            <td><{$item}></td>
                                        </tr>
                                     <{/if}>
                                <{/foreach}>
                            <{/foreach}>
                            <{if $data->recap->optimiz}>
                            <tr>
                                <td colspan="3" style="background-color:#84B819">Optimiz</td>
                            </tr>
                                <{foreach from=$data->recap->optimiz item=recap}>
                                    <{foreach from=$recap item=item}>
                                        <tr>
                                            <td> <{$item.lib}></td>
                                            <td><{$item}></td>
                                        </tr>
                                    <{/foreach}>
                                <{/foreach}>
                            <{/if}>
                            <{if $data->recap->securiz}>
                                <tr>
                                    <td colspan="3" style="background-color:#84B819">Securiz</td>
                                </tr>
                                <{foreach from=$data->recap->securiz item=recap}>
                                    <{foreach from=$recap item=item}>
                                        <tr>
                                            <td> <{$item.lib}></td>
                                            <td><{$item}></td>
                                        </tr>
                                    <{/foreach}>
                                <{/foreach}>
                            <{/if}>
                            
                        </tbody>
                    </table>
                </td>
            </tr>
           
            <!--buttton-->
            <tr>
                    <td colspan="2" style="text-align:center;height:40px">
                        <input class="btFormAddLot back"   type="button" value="Retour"/>
                        <input class="btFormAddLot btFormAnnuler"  type="button" value="Annuler"/>
                        <input class="btFormAddLot" id="etape4"   type="submit" value="Etape suivante:Validation "/>
                        
                    </td>
           </tr>
           
    </tbody>
    </table>    
</form>
                    
<script>
     
    //addlot
    $("#addLot").click(function(){
        
        $("#formSous").css("display","none");
        
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

       
       $('#formSous').submit(function(){


                $("#etape4,.back").attr("disabled","disabled");
                //un lot doit etre selectionné

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
            
            
            
            
            
            
            //grid
            try{
                $("#tabLots").wijgrid({
                    //rendered:actions,
                    selectionMode: "singleRow",    
                    rendered: function (e){ 
                         
                         $(".checkboxLot").change(function(){
                            
                            var selected = $("#tabLots").wijgrid("selection").selectedCells();
                            //idRow=selected.item(0).rowIndex();
                            idRow=selected.item(0).rowIndex();

                               
                            
                         

                        })
                    
                    }
                });
            }catch(error){
            
            }
            
          //scroll 
            window.scrollTo(0,0); 
            
            
        
</script>                       