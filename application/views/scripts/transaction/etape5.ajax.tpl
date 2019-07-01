<form id="formSous" class="form" name="formSetContrat" method="post" action="">
    
    <input type="hidden" id="idsous" name="idsous" value="<{$data->idsous}>"/>
    <input type="hidden" id="idoffre" name="idoffre" value="<{$data->idoffre}>"/>
    <input type="hidden" name="etape" value="validation"/>
    <input type="hidden" id="produit" name="pdt" value="<{$pdt}>"/>
<!--    <input type="hidden" id="etapeprec" name="etapeprec" value="4"/>-->
    <input type="hidden" id="etapeback" name="back" value="<{$this->back}>"/>
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
                        <input class="btFormAddLot back"   type="button" value="Retour"/>
                        <input class="btFormAddLot btFormAnnuler"  type="button" value="Annuler"/>
                        <input class="btFormAddLot" id="etape5"   type="submit" value="Valider l'engagement "/>
                    </td>
           </tr>
           
    </tbody>
    </table>    
</form>
<!--<div id="cdvTxt" class="trash" style="display: none"><{$this->cdv}></div>            -->
<script>
    
    //addlot
//    $("#addLot").click(function(){
//        
//        $("#formSous").css("display","none");
//        
//        $.ajax({
//            url:"/transaction/addlot/format/html",
//            success:function(data){
//                
//                $("#main").append(data);
//            }
//        })
//        
//    })
    
    //condition de ventes
    //show cdv
    /**
    *Afficheges conditions de ventes supprimées
    *
    */
        $("#btCdv").click(function(evt){
            return false;
            evt.preventDefault();
            //scroll page to top and left
            window.scrollTo(0,0);
            //dialog
            /*$("#cdvTxt").wijdialog({
                    modal: true,
                    captionButtons:{
                    pin: { visible: false },
                    refresh: { visible: false },
                    toggle: { visible: false },
                    minimize: { visible: false },
                    maximize: { visible: false },
                    close: { visible: true} },
                    title:"Conditions générales d'achats",
                    autoOpen:true,
                    dialogClass:"popupCdv",
                    minWidth:800,
                    position:"top"});*/
                    
                    return false;

            });
    
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

                //desactive les buttons
                $(".back ,.btFormAnnuler,#etape5").attr("disabled","disabled");
                // check data input
//              if(!$("#cdv" ).is(':checked')){
//                    alert("Vous devez accepter les conditions générales d'achats, avant de poursuivre.");
//                    return false;
//               }
               
               if($("#pwd").val()==""){
                    alert("Vous devez entrer votre mot de passe, avant de poursuivre.");
                    //desactive les buttons
                    $(".back ,.btFormAnnuler,#etape5").removeAttr("disabled");
                    return false;
               }
               
               
                $.ajax({
                    url:"/transaction/setcontrat/format/html",
                    data:$(this).serialize(),
                    type:"POST",
                    success:function(data){
                    
                        
                            //$("#main").empty();
                            $("#main").append(data);
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