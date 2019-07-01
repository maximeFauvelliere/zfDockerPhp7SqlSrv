<form id="formSous" class="form" name="formSetContrat" method="post" action="">
    
    <input type="hidden" id="idsous" name="idsous" value="<{$data->idsous}>"/>
    <input type="hidden" id="idoffre" name="idoffre" value="<{$data->idoffre}>"/>
    <input type="hidden" name="etape" value="3"/>
    <input type="hidden" id="etapeprec" name="etapeprec" value="<{$etapeprec}>"/>
    <input type="hidden" id="etapeback" name="back" value="<{$this->back}>"/>
    <input type="hidden" id="produit" name="pdt" value="<{$pdt}>"/>
    <div class="bzHeader"><span>Etape : Calcul du prix</span></div>
    <table class="lot" id="tabLotFormcontent" style="width: 100%">
        <tbody>
            <tr>
                <td>
                    <div class="wraperLabel" >
                        <label> Prix</label>
                    </div>                  
                </td>
            </tr>
            <tr>
                <td>
                    <label class="In_text" style="font-size:12pt"><{$data->prix}> </label>
                </td>
            </tr>
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

                    <{/foreach}>

                </td>
            </tr>
            <tr>
                    <td colspan="2" style="text-align:center;height:40px">
                        <input class="btFormAddLot back"  type="button" value="Retour"/>
                        <input class="btFormAddLot btFormAnnuler"  type="button" value="Annuler"/>
                        <input class="btFormAddLot" id="etape2"   type="submit" value="Etape suivante : Quantité"/>
                    </td>
           </tr>
    </tbody>
    </table>    
</form>
                
<script>
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

                $("#etape2,.back").attr("disabled","disabled");

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
            
            //scroll 
            window.scrollTo(0,0); 
        
</script>                