<script>
var paintPies2=function(){
    $("#structPie").wijcompositechart({
                
                create:function(){
                         $.ajax({
                            url:"/transaction/analysecomcontrats/format/html/camp/"+"<{$data->camp}>",
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
                },
                axis: {
                    y: {
                        gridMajor: {
                            visible: false
                        },
                        textVisible: false
                    },
                    x: {
                        visible: false,
                        textVisible: false
                    }
                },
                legend: {
                    visible: true,
                    //compass:"south",
                    textStyle:{
                        //"font-size":6
                    }
                },
                animation: {
                //enabled: false
            },
            stacked: false,
            hint: {
                content: function () {

                        if(this.customData.bzType=="cult"){
                            return this.label + "\n" +this.customData.L_pxmoy+":"+
                                this.customData.pxmoy+"\n"+
                                this.customData.L_qt+":"+this.customData.qt+" \n"+
                                this.customData.L_qtnf+":"+this.customData.qtnf+"\n"+
                                this.customData.L_dep+":"+this.customData.dep;
                        }else{
                            return this.label + "\n" +this.data+"%";
                        }
                        
                }
            },
            header: {
                text: "Campagne <{$data->camp}>"
            },
            seriesList: [{
                type: "pie",
                legendEntry: false,
                center: { x: 185, y: 165 },
                radius: 120,
                chartLabelStyle: {
                fill: "#FF0000"
                },
                data: [
                <{foreach from=$data->structure item=struct}>             
                    {
                        label: "<{$struct->label}>",
                        legendEntry: true,
                        data: parseFloat(<{$struct->data}>),
                        customData:{bzType:"struct",idti:"<{$struct->idti}>",camp:"<{$struct->camp}>"},
                        offset: 0,
                        textStyle: {opacity: 0.01}
                }<{if !$struct@last}>,<{/if}>
                <{/foreach}>]
            }, {
                type: "pie",
                legendEntry: false,
                center: { x: 185, y: 165 },
                radius:90,
                data: [
                <{foreach from=$data->structure item=struct}>
                    <{foreach from=$struct->culture item=cult}>
                       {
                            label: "<{$cult->label}>", 
                            legendEntry: true,
                            data:parseFloat(<{$cult->data}>),
                            customData:{bzType:"cult",idti:"<{$cult->idti}>",camp:"<{$cult->camp}>",idcu:"<{$cult->idcu}>",L_pxmoy:"prix moyen",pxmoy:'<{$cult->pxmoy}>',L_qt:"Quantité",qt:"<{$cult->qt}> t",L_qtnf:"Quantité non fixée",qtnf:"<{$cult->qtnf}> t",L_dep:"Dont dépot :",dep:"<{$cult->depot}> t"},
                            offset: 0,
                            textStyle: {opacity:0.01}
                        }<{if !$cult@last}>,<{/if}> 
                    <{/foreach}><{if !$struct@last}>,<{/if}> 
                <{/foreach}>]
            }],
            seriesStyles: [
                      <{foreach from=$data->structure item=struct}>                
                    {
                        "stroke-width": 0, opacity: 1
                    },
                <{/foreach}>  
                <{foreach from=$data->structure item=struct}>  
                    <{foreach from=$struct->culture item=cult}>                
                        {
                            fill:"<{$cult->color}>",stroke: "<{$cult->color}>", "stroke-width": 0, opacity: 1
                        }<{if !$cult@last}>,<{/if}>
                    <{/foreach}><{if !$struct@last}>,<{/if}>
                <{/foreach}>     
              ]
        });
        
        
        
           //click bargraph
            $("#structPie").wijcompositechart({click: function(e, data) {
                
                //alert("click");


                
                if(data.customData && data.customData.bzType=="struct"){
                    //change culture
                    var bzData={idti:data.customData.idti,camp:data.customData.camp,type:"struct"};

               
                }else{
                
                    var bzData={idcu:data.customData.idcu,idti:data.customData.idti,camp:data.customData.camp,type:"cult"};
                }
                
                  $.ajax({
                        url:"/transaction/analysecomcontrats/format/html/",
                        type:"POST",
                        data:bzData,
                        success:function(data){
                           try{
                            $("#bubble").wijbubblechart("destroy");
                           }catch(error){

                           }
//console.log("data",data);
                           $("#main").append(data);

                            bubble();
                        },
                        error:function(error){

                            alert("error"+error)
                        }

                    })

            } 
            
            })

}


</script>
