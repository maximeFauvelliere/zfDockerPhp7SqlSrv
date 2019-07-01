<form id="formSous" class="form" name="formSetContrat" method="post" action="">
    
<!--    <input type="hidden" id="idwohb" name="idwohb" value="<{$this->idwohb}>"/>
    <input type="hidden" id="idwo" name="idwo" value="<{$this->idwo}>"/>-->
    <input type="hidden" id="idwos" name="idwos" value="<{$this->idwos}>"/>
    <input type="hidden" name="etape" value="validation"/>
<!--    <input type="hidden" id="produit" name="pdt" value="<{$pdt}>"/>-->
<!--    <input type="hidden" id="etapeprec" name="etapeprec" value="init"/>-->
<!--    <input type="hidden" id="etapeback" name="back" value="<{$this->back}>"/>-->
    <div class="bzHeader"><span>Validation</span></div>
    <table class="lot"  id="tabLotFormcontent" style="max-width: 900px">
        <tbody>
            <tr>
                <td colspan="2" style="text-align: center">
<!--                    <input class="radioCamp" type="checkbox" name="cdv" id="cdv" class="trash"  value="ok">J'ai pris connaissance et accepte les conditions générales d'achats. Cliquez <a href="/" id="btCdv" style="font-weight: bold;font-size: 15pt">ici</a> pour accèder aux conditions générales d'achats.</input>-->
<h4>Pour valider définitivement votre engagement, entrez ci-dessous votre mot de passe.</h4>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div style="text-align:center">
                        <input type="password" name="pwd" id="pwd" value=""/><br/>
                    </div>
                </td>
            </tr>
            <!--buttton-->
            <tr>
                    <td colspan="2" style="text-align:center;height:40px">
<!--                        <input class="btFormAddLot back"   type="button" value="Retour"/>-->
                        <input class="btFormAddLot btFormAnnuler"  type="button" value="Annuler"/>
                        <input class="btFormAddLot" id="etapeOpti1"   type="submit" value="Valider l'engagement "/>
                    </td>
           </tr>
           
    </tbody>
    </table>    
</form>
<div id="cdvTxt" class="trash" style="display: none"><{$this->cdv}></div>            
<script>

 
        //annulation form
        $(".btFormAnnuler").click(function(){
            
            //reset for dialog
            try{
                 $(".bzModale").remove();
                 $("#cdvTxt").wijdialog("destroy");
                 $("#canvas_siloNav").css("display","block");
            }catch(error){
        
            }
           
            $.ajax({     
                url:"/transaction/setopti/format/html"
            })
            
           $("#tabContrats").wijgrid("destroy");
           location.hash="transaction_getoffreopti";
           $(window).trigger("hashchange");

        });

       
       $('#formSous').submit(function(){
            
               $("#etapeOpti1,.back").attr("disabled","disabled");
               
               if($("#pwd").val()==""){
                    alert("Vous devez entrer votre mot de passe, avant de poursuivre.");
                    $("#etapeOpti1,.back").removeAttr("disabled");
                    return false;
               }
               
                $.ajax({
                    url:"/transaction/setopti/format/html",
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
                        location.hash="transaction_getoffreopti";
                        $(window).trigger("hashchange");
                        //scroll page to top and left
                        window.scrollTo(0,0);
                        
                    }
                });
                
                return false;
            });

            //scroll 
            window.scrollTo(0,0); 

        
</script>                       