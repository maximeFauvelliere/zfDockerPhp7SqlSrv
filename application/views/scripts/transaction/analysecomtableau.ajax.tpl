<script>
    var grid1=null;
    
    var xmlData=<{$this->data}>;
    
    var detailData=xmlData.root.entree;

    if(!isArray(detailData)){
        detailData=convertToArray(detailData);
    } 
    
    var reader1 = new wijarrayreader([
                {name:'Structure',mapping:function(item){return item.struct}},
                {name:'N°Voyage',mapping:function(item){return item.nbvoy}},   
                {name:'BZ',mapping:function(item){return item.bz}},
                {name:'N°Bon',mapping:function(item){return item.nbbon}},
                {name:'Date',mapping:function(item){return item.date}},
                {name:"Brut",mapping:function(item){return item.brut}},
                {name:"Net",mapping:function(item){return item.net}}
               
]);  
    var detailTableau=function(){
    
            grid1= $("#detailBubble").wijgrid({
                allowSorting: true,
                cellStyleFormatter: function (args){bzCenter(args)},
                data: new wijdatasource({reader:reader1, data:detailData}),
                selectionMode: "singleRow",
                loaded: function (data){
                    
                },
                rendered:function(){
                    var h=$("#listBzcar").css("height");
                    $(".wrapperbt").css("height",h);
                    var padding=(parseInt($(".wrapperbt").css("height"))/2)-100;
                    $(".wrapperBtTxt").css("top",padding+"px");
                    $("#syntheseMask").remove();        
                }
            });
    
    }
    
</script>