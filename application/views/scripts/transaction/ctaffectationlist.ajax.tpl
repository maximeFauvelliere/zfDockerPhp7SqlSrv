<div class="content">
    
    <div class="grilles analysesAttente">
        <div class="table table1">
            <div class="titleGrid">CONTRATS A AFFECTER</div>
            <table class="prospection" id="ctaffect">
            </table>
        </div>
    </div>
</div>

<script>
    controller="transaction";
    action="ctaffectationlist";
    $("#suTitreNav").html("");
    var grid1;
    var pageSize=<{$this->pageSize}>;
    var listCtAffect=<{$this->data}>;
    
    //reader
    var readerCt = new wijarrayreader([
                    
                    {name:'Camp',mapping:function(item){return item['camp']}},
                    {name:'Cult.',mapping:function(item){return item['cult']}},
                    {name:'Type',mapping:function(item){return item['type']}},
                    {name:'Contrat',mapping:function(item){return item['ct']}},
                    {name:'Date ct.',mapping:function(item){return item['datect']}},
                    {name:'N°ct',mapping:function(item){return item['nct']}},
                    {name:'Struct.',mapping:function(item){return item['struct']}},
                    {name:'Qté.',mapping:function(item){return item['qte']}},
                    {name:'Surf.',mapping:function(item){return item['surf']}},
                    {name:'Prime',mapping:function(item){return item['prime']}},
                    {name:'Prix',mapping:function(item){return item['px']}},  
                    {name:'Qté. Affect.',mapping:function(item){return item['qteaff']}},
                    {name:'Affectation',mapping:function(item){return '<div style="z-index:-1;width:100%;text-align:center;"><input type="button" class="affect" value="affecter"/></div>'}}   
    ]); 

   
    
    var ctAffect = listCtAffect.contrats.contrat;

    if(!isArray(ctAffect)){
       ctAffect=convertToArray(ctAffect);
    }
    

    function makegrid(){
        grid1= $("#ctaffect").wijgrid({
                allowSorting: false,
                allowPaging: true,
                pageSize: pageSize,
                data: new wijdatasource({
                    reader:readerCt,
                    data:ctAffect}),
                pageIndexChanged: function (e, args){
                            
                                bindClickAffect();
                }
               // columns: [{visible:false},{visible:false},{width:50},{width:340},{width:100},{width:150}],
                //ensureColumnsPxWidth: true,
                //selectionMode: "singleRow"
            });  
    } 

    function bindClickAffect(){
          // click 
        $(".affect").click(function(e){
        
                setTimeout(function(){

                        var selected = $("#ctaffect").wijgrid("selection").selectedCells();                     
                        var idCt=selected.item(5).value();
                        
                        location.hash="transaction_ctaffectation/idct/"+idCt;

                        
                        },100);
        });
    }

    setTimeout(function(){
        makegrid();
        // click 
        $(".affect").click(function(e){
        
                setTimeout(function(){

                        var selected = $("#ctaffect").wijgrid("selection").selectedCells();                     
                        var idCt=selected.item(5).value();
                        
                        location.hash="transaction_ctaffectation/idct/"+idCt;

                        
                        },100);
        });
    },10);

</script>