<script>
    $("#preloader").css("display","none");
</script>

<style>
    
    .ui-widget{
       background-color:white; 
    }
    
    .ui-datepicker-week-end{
        background-color:red;
     }
    .ui-datepicker-header a{
        left:inherit;
    }
    .wijmo-wijcalendar{
       background-color:white; 
    }
    
    .zenith_calendar .wijmo-wijinput-trigger span{
        background-color:#84B819;
    }
   .wijmo-wijcalendar table th{
       background-color:#B5ABA1!important;
       }
</style>

<form id="formSous" class="form" name="formSetContrat" method="post" action="">
    
    <input type="hidden" id="idsous" name="idsous" value="<{$data->idsous}>"/>
    <input type="hidden" id="idoffre" name="idoffre" value="<{$data->idoffre}>"/>
    <input type="hidden" name="etape" value="3"/>
<!--    <input type="hidden" id="etapeprec" name="etapeprec" value="2"/>-->
    <input type="hidden" id="etapeback" name="back" value="<{$this->back}>"/>
    <div class="bzHeader"><span>Etape 2 : Fixation du prix pour Bzenith</span></div>
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
                    
                    <input id="px" name="px" value="Entrez un prix" style="width:100px"> €</input><br/>
                    <span style="font-size:8pt;color:brown">Décimales séparées par un point (pas de virgule).</span>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="wraperLabel" >
                        <label> Choix date et heure</label>
                    </div>                  
                </td>
            </tr>
            <tr>
                <td class="zenith_calendar">
                    <input type="text" class="zenith_calendar" name="date" id="zenith_date" />
                    <input type="text" class="zenith_calendar" name="heure" id="zenith_heure" />
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
    //calendar 
  
   
    $("#zenith_date").wijinputdate(
        {
            disableUserInput:true,
            showTrigger: true,
            dateChanged: function(e, arg){
                /*console.log("e",e.currentTarget)
                console.log("this",this.protoype)
                console.log("arg",arg)*/
            }
            

        });
     
    $("#zenith_heure").wijinputdate(
        {
            disableUserInput:true,
            showTrigger: true,
            dateFormat:"HH:mm",
            date: "11:00",
            comboItems: ["11:00", "12:00", "13:00","14:00","15:00","16:00","17:00","18:00"]
            
            

        });
        
    

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

       
       $('#formSous').submit(function(){

                //console.log("form",$(this).serialize());
                //check data
                if(!$.isNumeric($("#px").val())) alert("Entrez une valeur numérique pour le prix.");return false;

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
        
</script>                