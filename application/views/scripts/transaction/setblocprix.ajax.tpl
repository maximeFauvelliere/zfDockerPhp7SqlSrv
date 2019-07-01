<!--condition de vente-->
<!--<div id="cdvTxt" class="trash" style="display: none"><{$cdv}></div>-->

<form id="setContrat" class="form" methode="post" name="formSetContrat" method="post" action="">
    
    <input type="hidden" id="pdt" name="pdt" value="<{$this->produit}>"/>
    <div class="bzHeader"><span>Commercialisation en ligne</span></div>
    <{if isset($data)}>
        <table class="lot" id="tabLotFormcontent" style="width: 800px">
            <tbody>
            <tr class="etape1">
                <td>
                    <div class="wraperLabel">
                        <label> <{$this->data->label}></label><label style="float:right">*Minimum engagement pour cette culture :<{$this->data->min}></label>
                    </div>                  
                </td>
            </tr>
            <tr class="etape1">
                <td>
                    <input style="width:100px" value="<{$this->data->qtehainit}>" name="qteha" id="bl_px"><br>
                </td>
            </tr>

            <tr class="etape1" style="display: block">
                <td style="width:100%;max-width: inherit">
                    <{foreach from=$data->recap item=recap}>
                           <table class="recap" style="width:790px;">
                               <tbody>
                                    <{foreach from=$recap item=content}>
                                    <{if $content.lib=="idct" || $content.lib=="idchb"}>
                                        <input type="hidden" name="<{$content.lib}>" value="<{$content.value}>"/>
                                        <{continue}>
                                   <{/if}>
                                   

                                    <tr>
                                        <td>
                                            <{$content.lib}>
                                        </td>
                                        <td>

                                            <!-- cherhce les parametre optionnel a envoyer a la ps "retour" ps dyn-->
                                            <{if isset($content.retour)}>
                                                <input type="hidden" name="<{$content.pname}>" value="<{$content.value}>"/>
                                             <{/if}>
                                            <{$content.value}>
                                        </td>
                                    </tr>
                                    <{/foreach}>
                               </tbody>
                           </table>

                    <{/foreach}>

                </td>
            </tr>

            <tr class="etape1" style="display:block">
                    <td  style="text-align:center;width:790px;max-width: inherit;height:40px">
                        <input class="btFormAddLot btFormAnnuler" type="button" value="Annuler"/>
                        <input class="btFormAddLot" id="btFollow"  type="button" value="Etape suivante"/> 
                    </td>
           </tr>

<!--            <tr class="etape2" style="display:none">
                <td>
                    <div class="wraperLabel">
                          <label> Conditions d'utilisation</label>
                    </div>
                </td>
            </tr>-->
<!--            <tr class="etape2" style="display:none">
                <td>
                    <input class="radioCamp" type="checkbox" name="cdv" id="cdv" class="trash"  value="ok">J'ai pris connaissance et accepte les conditions générales d'utilisation. Clicquez <a href="/" id="btCdv" style="font-weight: bold;font-size: 15pt">ici</a> pour acceder aux conditions générale de utilisation.</input>
                </td>
            </tr>-->
            <tr class="etape2" style="display:none">
                <!--validation-->
                <td>
                    <div class="wraperLabel">
                          <label> Validation</label>
                    </div>
                </td>
            </tr>    
            <tr class="etape2" style="display:none">
                <td>

                        <div>
                            Pour valider définitivement votre engagement, entrez ci-dessous votre mot de passe.
                        </div>

                        <div style="text-align:center">
                            <input type="password" name="pwd" id="pwd" value=""/><br/>
        <!--                    <input type="submit" id="btConfirm" value="Valider"/>
                            <input type="button"  id="btAnnulConfirm" value="Annuler"/>-->
                        </div>

                </td>
            </tr>
            <tr class="etape2" style="display:none">
                    <td  style="text-align:center;padding-left:30%;padding-right:30%;height:40px">
                        <input class="btFormAddLot btFormAnnuler"  style="" type="button" value="Annuler"/>
                        <input class="btFormAddLot" id="btBack1"  type="button" value="Etape précedente"/>
                        <input class="btFormAddLot" id="btConfirm" type="submit" value="Valider"/>
                        
                    </td>
           </tr>




        </tbody>
        </table> 
    <{else}>   
        <h1>Une Erreur est survenue, veuillez contacter l'administrateur</h1>
    <{/if}>
</form>


                
<script>
    
    var formData=<{$formData}>;
    var min=<{if $this->data->min}><{$this->data->min}><{else}>0<{/if}>;
    //console.log("min",min);
    // create modale effect
    $('body').append("<div class='bzModale'></div>");
    $(".bzModale").css("height",$(document).height());
    $(".bzModale").css("width",$(document).width());
    // collapse le filtre si besoin
    try{
        if($("#D_filter").css("display")=="block"){
            $("#D_filter").wijdialog("toggle");
        }
        $("#canvas_siloNav").css("display","none");
        $("#D_filter").wijdialog({disabled:true});
    }catch(error){};

        //get list contrats by offre => click annuler
        function getContratsList(contratTitle){
             data={"contrat":contratTitle};
             $.ajax({
                url:"/transaction/getcontrattolock/format/html",
                data:data,
                type:"POST",
                success:function(data){

                   $("#main").empty();
                   $("#main").html(data);
                   $("#preloader").css("display","none");
                }

            })
        }
        
        //btsuivant
        $("#btFollow").click(function(){
                
                if($("#bl_px").val()==parseInt(0) || !$.isNumeric($("#bl_px").val()) || $("#bl_px").val()==null){
                    alert("Vous devez entrer une quantité ou une surface.");
                    return false;
                }
                
                if($("#bl_px").val()<min){
                    alert("Vous ne pouvez pas entrer une valeur inférieur à la quantité minimale.");
                    return false;
                }
                $(".etape1").css("display","none");
                $(".etape2").css("display","table-row");

        })
        
        
        //btback
        $("#btBack1").click(function(){
        
                $(".etape1").css("display","table-row");
                $(".etape2").css("display","none");
        })
        
       
        //annulation form
        $(".btFormAnnuler").click(function(){
             var produit=$("#pdt").val()?$("#pdt").val():"";
            
            //clear time out
             clearTimeout(formTimeOut);
            //reset for dialog
             $("#preloader").css("display","block");
            try{
                $("#setContrat").remove();
                $("#cdvTxt").wijdialog("destroy");
                $("#popUpValid").wijdialog("destroy");
                $("#popUpValid").remove();
               
                
            }catch(error){
            
            }

            $(".bzModale").remove();
           
            getContratsList(produit);
        });
      
        //etape final confirmation
       $('#setContrat').submit(function(){

            if($("#pwd").val()=="" )
            {
                alert("Vous devez entrer un mot de passe.");
               $("#qte").focus();
               
                return false;
            }

                 //clear time out
                   clearTimeout(formTimeOut);
                   
                $.ajax({
                    url:"/transaction/validateblock/format/html",
                    data:$(this).serialize(),
                    type:"POST",
                    success:function(data){

                            //$("#main").empty();
                            $("#main").append(data);
                            //scroll page to top and left
                            window.scrollTo(0,0);
                        
                    },
                    error:function(){
                        alert("Une erreur est survenue, vous allez être redirigé.")
                        location.hash="transaction_offres";
                        $(window).trigger("hashchange");
                        //scroll page to top and left
                        window.scrollTo(0,0);
                        
                    }
                });
                
                return false;
            });
            
            convertVirgule($("#bl_px"))
            
            $("#bl_px").focus(function(){$("#bl_px").select();});
            
            // 2mn max to market
            
            formTimeOut=setTimeout(function(){
                   //clear time out
                   clearTimeout(formTimeOut);
                   
                   alert("Vous avez dépassé les 2 minutes pour finaliser votre commercialisation. Nous devons réactualiser les prix du marché.");
                   var produit=$("#pdt").val()?$("#pdt").val():"";
                  
                    location.hash="transaction_getcontrattolock/contrat/"+produit;
                    $(window).trigger("hashchange");
    
            },120000);
            
        //disabled key enter
            //Bind this keypress function to all of the input tags
            $("#bl_px").keypress(function (evt) {
                //Deterime where our character code is coming from within the event
                var charCode = evt.charCode || evt.keyCode;
                if (charCode  == 13) { //Enter key's keycode
                return false;
                }
            });
            
            
        

</script>    
                        