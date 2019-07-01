
<script>
            //---------------------------pies---------------------------
        var paintPies1=function (){

             
             $("#cultPie").wijpiechart({
             
                culture:"fr-FR",
                radius: 140,
                legend: { visible: true },
                hint: {
                    content: function () {

                        return this.data.label + "\n" +this.data.customData.L_pxmoy+":"+
                        this.data.customData.pxmoy+"\n"+
                        this.data.customData.L_qt+":"+this.data.customData.qt+" \n"+
                        this.data.customData.L_qtnf+":"+this.data.customData.qtnf+"\n"+
                        this.data.customData.L_dep+":"+this.data.customData.dep;
                        
                        }
                },
                header: {
                    text: "Campagne <{$data->camp}>"
                },
                seriesList: [
                 <{foreach from=$data->culture item=culture}>                
                    {
                    label: "<{$culture->label}>",
                    legendEntry: true,
                    customData: {idcu:"<{$culture->gdata->idcu}>",L_pxmoy:"prix moyen",pxmoy:"<{$culture->gdata->pxmoy}>",L_qt:"Quantité",qt:"<{$culture->gdata->qt}> t",L_qtnf:"Quantité non fixée",qtnf:"<{$culture->gdata->qtnf}> t",L_dep:"Dont dépot :",dep:"<{$culture->gdata->depot}> t","camp":"<{$data->camp}>"},
                    data : parseInt(<{$culture->data}>),
                    offset: parseInt(<{$culture->offset}>)
                    }<{if !$culture@last}>,<{/if}>
                <{/foreach}>
                ],
                seriesStyles: [
                    <{foreach from=$data->culture item=culture}>
                        {
                            fill: "<{$culture->color}>", stroke: "rgb(0,0,0)", "stroke-width": 1.5
                        }<{if !$culture@last}>,<{/if}>
                    <{/foreach}>
                ],
                create:function(){
                
                    // si plusieurs structures
                    if(true){
                     $.ajax({
                            url:"/transaction/analysecomstructures/format/html/camp/"+"<{$data->camp}>",
                            success:function(data){
                            
                                $("#main").append(data);
                                //$("#Acom_mask1").css("display","none");

                                    try{
                                        $("#structPie").wijcompositechart("destroy");

                                    }catch(error){

                                    }
                                    paintPies2();

                            },
                            error:function(error){
                            
                                alert("error"+error)
                            }
                
                        })
                        
                        }else{
                        
                            $.ajax({
                                url:"/transaction/analysecomcontrats/format/html/",
                                success:function(data){

                                    $("#main").append(data);
                                    //$("#Acom_mask1").css("display","none");
                                        
                                        try{
                                             $("#bubble").wijbubblechart("destroy");
                                       }catch(error){

                                       }
                                       bubble();
                                  
                                },
                                error:function(error){

                                    alert("error"+error)
                                }

                            })
                        
                        }
            
        
                }
               
            });
            
            
            $("#cultPie").wijpiechart({
                click:function (e,data){

                var dataCult={idcu:data.customData.idcu,camp:data.customData.camp};
                $.ajax({
                    url:"/transaction/analysecomcontrats/format/html",
                    type:"POST",
                    data:dataCult,
                    success:function(data){

                        $("#main").append(data);
                                    //$("#Acom_mask1").css("display","none");
                                        
                                        try{
                                             $("#bubble").wijbubblechart("destroy");
                                       }catch(error){

                                       }
                                       bubble();
                    },
                    error:function(error){
                       
                    }

                })
                    
                    
                }
            })
            
            }
</script>
