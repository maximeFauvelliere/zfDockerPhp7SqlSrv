<form id="formSous" class="form" name="formSetContrat" method="post" action="">
    
    <input type="hidden" id="idsous" name="idsous" value="<{$data->idsous}>"/>
    <input type="hidden" id="idoffre" name="idoffre" value="<{$data->idoffre}>"/>
    <input type="hidden" name="etape" value="2"/>
    <input type="hidden" id="produit" name="pdt" value="<{$pdt}>"/>
    <div class="bzHeader"><span>Etape : Produits dérivés</span></div>
    <table class="lot" id="tabLotFormcontent" style="max-width: 900px">
        <tbody>
            <!--optimiz-->
        <{foreach from=$data->optimiz item=optimiz}>
            <{if isset($optimiz->marchandise)}>
               <tr class="etape1">
                    <td>
                        <div class="wraperLabel">
                              <label> Ajouter optimiz ?</label>
                        </div>
                    </td>
               <tr> 
               <tr class="etape1">
                   <td>
                       <table>
                           <tbody>
                                <{foreach from=$optimiz key=key item=content}>
                                    <{if $key!="palier"}>
                                        <tr>
                                            <td>
                                                <{$content.lib}> 
                                            </td>
                                            <td>
                                                <{$content.value}>
                                            </td>
                                        </tr>
                                    <{/if}>
                                <{/foreach}>
                                <{if isset($optimiz->palier)}>
                                    <{foreach from=$optimiz->palier item=palier}>
                                        <{foreach from=$palier item=item}>
                                            <tr>
                                                <td colspan="2"><{$item}></td>
                                                
                                            </tr>
                                        <{/foreach}>
                                    <{/foreach}>
                                <{/if}>
                                
                           </tbody>
                       </table>
                   </td>
                   <td>
                       <ul class="listform" id='checkOpti'>
                           <li>
                                <input class="opti" type="radio" name="optimiz"  <{if $optimiz.checked =="1"}>checked="checked"<{/if}> value="<{$optimiz.id}>">Oui, je prends un Optimiz</input>
                           </li>
                           
                       </ul>
                   </td>
               </tr>
              <{/if}>            
        <{/foreach}>
        
        <!--securiz-->
        <{foreach from=$data->securiz item=securiz}>
            
            <{if isset($securiz->marchandise)}>
               <tr class="etape1">
                    <td>
                        <div class="wraperLabel">
                              <label> Ajouter securiz ?</label>
                        </div>
                    </td>
               <tr> 
               <tr class="etape1">
                   <td>
                       <table>
                           <tbody>
                                <{foreach from=$securiz item=content}>
                                <tr>
                                    <td>
                                        <{$content.lib}>
                                    </td>
                                    <td>
                                        <{$content.value}>
                                    </td>
                                </tr>
                                <{/foreach}>
                                <{if isset($securiz->palier)}>
                                    <{foreach from=$securiz->palier item=palier}>
                                        <{foreach from=$palier item=item}>
                                            <tr>
                                                <td colspan="2"><{$item}></td>
                                                
                                            </tr>
                                        <{/foreach}>
                                    <{/foreach}>
                                <{/if}>
                           </tbody>
                       </table>
                   </td>
                   <td>
                       <ul class="listform" id='checkOpti'>
                           <li>
                                <input class="secu" type="radio" name="securiz"  <{if $securiz.checked =="1"}>checked="checked"<{/if}> value="<{$securiz.id}>">Oui, je prends ce Securiz</input>
                           </li>
                           
                       </ul>
                   </td>
               </tr>
             <{/if}>           
        <{/foreach}>
        <{if isset($optimiz->marchandise)}>
        <tr>
            <td colspan="2">
                <div class="wraperLabel" style="width:70%;display: inline-block">
                      <label> Je ne souhaite pas prendre d'optimiz.</label>
                </div>
                
                <input class="opti" type="radio" name="optimiz"  <{if $optimiz.checked !="1"}>checked="checked"<{/if}> value="0"></input>
            </td>
        </tr>
        <{/if}>
         <{if isset($securiz->marchandise)}>
        <tr>
            <td colspan="2">
                <div class="wraperLabel" style="width:70%;display: inline-block">
                              <label> Je ne souhaite pas prendre de securiz.</label>
                </div>
                <input class="secu" type="radio" name="securiz"  <{if $securiz.checked !="1"}>checked="checked"<{/if}> value="0">
            </td>
        </tr>
        <{/if}>
            <tr>
                    <td colspan="2" style="text-align:center;height:40px">
                        <input class="btFormAddLot back" type="button" value="Retour"/>
                        <input class="btFormAddLot btFormAnnuler"  type="button" value="Annuler"/>
                        <input class="btFormAddLot" id="etape1" type="submit" value="Etape suivante : Calcul du prix"/>
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
                 $("#canvas_siloNav").css("display","block");
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

       
       $('#formSous').submit(function(){

                $("#etape1,.back").attr("disabled","disabled");
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