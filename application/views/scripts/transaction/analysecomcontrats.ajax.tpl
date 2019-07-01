
<script>
var bubble=function(){

 $("#bubble").wijbubblechart({
        
        showChartLabels: false,
        culture:"fr-FR",
        axis: {
            y: {
                text: "Prix en euros",
                annoFormatString: "C2",
            },
            x: {
                annoFormatString:"dd-MM",
            }
        },
        hint: {
            content: function () {

                        return this.data.label + "\n" +"Culture : "+this.data.customData[this.data.index].cult+"\n"+this.data.customData[this.data.index].L_px+" : "+
                        this.data.customData[this.data.index].px+" € \n"+
                        this.data.customData[this.data.index].L_qt+" : "+this.data.customData[this.data.index].qt+" t\n"+
                        this.data.customData[this.data.index].L_solde+" : "+this.data.customData[this.data.index].solde+"\n"+
                        this.data.customData[this.data.index].L_Mt+" : "+this.data.customData[this.data.index].Mt+" €";
    
            }
        },
        header: {text: "Campagne <{$data->camp}>"},
        seriesList: [
            <{foreach from=$data->contrats item=cts}>
                    {
                        
                        label: "<{$cts.label}>",data:{
                            x:[<{foreach from=$cts->contrat item=ct}>new Date("<{$ct->x}>")<{if !$ct@last}>,<{/if}><{/foreach}>],
                            y:[<{foreach from=$cts->contrat item=ct}><{$ct->y}><{if !$ct@last}>,<{/if}><{/foreach}>],
                            y1:[<{foreach from=$cts->contrat item=ct}><{$ct->y1}><{if !$ct@last}>,<{/if}><{/foreach}>]
                            

                    },
                      customData:[<{foreach from=$cts->contrat item=ct}>{idct:<{$ct->idct}>,cult:"<{$ct->cult}>",L_px:"Prix de vente",px:<{$ct->px}>,L_qt:"Quantité",qt:"<{$ct->qt}>",L_solde:"Soldé",solde:"<{$ct->solde}>",L_Mt:"Montant versé",Mt:"<{$ct->mtv}>"}<{if !$ct@last}>,<{/if}><{/foreach}>]
    
                       
    
                },
            <{/foreach}>
        ],
        seriesStyles: [
                    <{foreach from=$data->contrats item=cts}>{fill: "<{$cts.color}>", stroke: "<{$cts.color}>", "stroke-width": 0}<{if !$cts@last}>,<{/if}><{/foreach}>
                ],
        create:function(){
          
                $.ajax({
                            url:"/transaction/analysecomtableau/format/html/",
                            success:function(data){
                           
                                $("#main").append(data);
                                //$("#Acom_mask1").css("display","none");
                                try{
                                $("#detailBubble").wijgrid("destroy");
                               }catch(error){
                               
                               }
                                detailTableau();
                            },
                            error:function(error){
                            
                                alert("error"+error)
                            }
                
                        })
        }
    });
    
    //click
    $("#bubble").wijbubblechart({
        click:function(e,data){

            var idCt={"idct":data.customData[data.index].idct};
            $.ajax({
                            url:"/transaction/analysecomtableau/format/html/",
                            type:"POST",
                            data:idCt,
                            success:function(data){
                               
                                $("#main").append(data);
                                //$("#Acom_mask1").css("display","none");
                                try{
                                $("#detailBubble").wijgrid("destroy");
                               }catch(error){
                               
                               }
                                detailTableau();
                            },
                            error:function(error){
                            
                                alert("error"+error)
                            }
                
                        })

        }

    })


}
</script>