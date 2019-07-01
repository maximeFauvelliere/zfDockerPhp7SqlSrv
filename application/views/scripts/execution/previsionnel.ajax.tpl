<!--affectation des data-->
<{if $this->data}>
<script> 
    var exeData=<{$this->data}>
    var camp;
    var pageSize=<{$this->pageSize}>;
</script>
<{/if}>
<div class="content">
    <div id="canvas"></div>
    <div class="grilles">
        <div class="table table1">
            <div class="titleGrid">CALENDRIER PREVISIONNEL</div>
            <table class="execution" id="execution"></table>

        </div>

        <div class="table table2">
            <div class="titleGrid" style="position: relative;">LISTE DES EXECUTIONS</div>

            <table class="execution" id="lstBon" ></table>
        </div>

        <div class="table table3">
            <div class="titleGrid" style="position: relative;">DETAIL DES EXECUTIONS</div>
            <table class="execution" id="detail" ></table>
        </div>

    </div>

</div>
<div id="dialog"></div>
<{$this->render('nav.tpl')}>
<script>
    // show silo nav if hidden
    $("#canvas_siloNav").css("display","block");
    //sub title
    $("#suTitreNav").text("Prévisionnel");
    
    
    controller="<{$this->controller}>";
    action="<{$this->action}>";

    //create gsilo [0] index de la cellule 
    createDSilo(siloData.cellules.cellule[2],"2_");


    //def variable
    var grid1;
    var grid2;
    var grid3;

    //reader
    var reader1 = new wijarrayreader([          
    {name:'Camp',mapping:function(item){return item['@attributes']['camp']}},
    {name:'Culture',mapping:function(item){return item['@attributes']['cult']}},
    {name:'Nb contrats',mapping:function(item){return item['@attributes']['nbct']}},
    {name:'Quantité t',mapping:function(item){return item['@attributes']['qte']}},
    {name:'Qte Livrée t',mapping:function(item){return item['@attributes']['qtelivre']}},
    {name:'Solde t',mapping:function(item){return item['@attributes']['qtesolde']}}
        ]);    
    
    var reader2= new wijarrayreader([
    {name:'Nom',mapping:function(item){return item['@attributes']['nom']}},
    {name:'Période',mapping:function(item){return item['@attributes']['periode']}},
    {name:'N°ct',mapping:function(item){return item['@attributes']['id']}},
    {name:'Quantite t',mapping:function(item){return item['@attributes']['qte']}},
    {name:"Qte livrée t",mapping:function(item){return item['@attributes']['qtelivre']}},
    {name:"Solde t",mapping:function(item){return item['@attributes']['qtesolde']}},
    {name:"Rendu/Départ",mapping:function(item){return item['@attributes']['rd']}}
        ]);

    var reader3= new wijarrayreader([          
    {name:'Adresses',mapping:function(item){return item['@attributes']['adr']}},
    {name:"Conditions d'executions",mapping:function(item){return item['@attributes']['libcond']}}
        ]);



  function onSelectionChanged2(){

            //destruction grid for bug two call 
            try{
                $("#qualites").wijgrid('destroy');
            }catch(e){

            }
            var selected = $("#execution").wijgrid("selection").selectedCells();
           // var idRow=selected.item(0).rowIndex();
           var idRow=(pageSize*$("#execution").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();

            var selected2 = $("#lstBon").wijgrid("selection").selectedCells();
            //var idRow2=selected2.item(0).rowIndex();
            var idRow2=(pageSize*$("#lstBon").wijgrid('option','pageIndex'))+selected2.item(0).rowIndex();

            var tab=exeData[idRow].bon



            //for bon
            if(! isArray(tab)){
                 tab=convertToArray(tab);
            }

            tab=tab[idRow2].detail;

            //for analyses
            if(! isArray(tab)){
                 tab=convertToArray(tab);
            }


    try{    

        grid3= $("#detail").wijgrid({
            data:new wijdatasource({
                reader:reader3,
                data:tab
            })
        });    
    }catch(error){
        alert("Une erreur s'est produite, rechargez la page.");

    }  
 
}

function onSelectionChanged1(){
        
        //destruction grid for bug two call
        try{
            $("#lstBon").wijgrid('destroy');
        }catch(e){

        }

        var selected = $("#execution").wijgrid("selection").selectedCells();
        var idRow=selected.item(0).rowIndex();

        bon=exeData[idRow].bon;

        if(!isArray(bon)){
            bon=convertToArray(bon);
        }


    try{    

        grid2= $("#lstBon").wijgrid({
            culture:"fr-FR",
            allowSorting: true,
            allowPaging: true,
            pageSize: pageSize,
            data:new wijdatasource({
                reader:reader2,
                data:bon
            }),
            columns:[{},{},{},{dataType:"number",dataFormatString: "n3"},{dataType:"number",dataFormatString: "n3"},{dataType:"number",dataFormatString: "n3"}],
            selectionMode: "singleRow",
            selectionChanged: onSelectionChanged2

    });    
    }catch(error){
        alert("Une erreur s'est produite, rechargez la page.");

    }    
    

 
}

function makeDataGrid(){

    exeData=exeData.execution.entrees;

        //if convertion en tab    
        if(!isArray(exeData)){
        exeData=convertToArray(exeData);
        }



        // call grid 1 ajax call
        grid1= $("#execution").wijgrid({
            allowSorting: true,
            allowPaging: true,
            pageSize: pageSize,
            data:new wijdatasource({
                reader:reader1,
                data:exeData
            }),
            columns:[{},{},{},{dataType:"number",dataFormatString: "n3"},{dataType:"number",dataFormatString: "n3"},{dataType:"number",dataFormatString: "n3"}],
            selectionMode: "singleRow",
            selectionChanged: onSelectionChanged1
        });


}

  
// trig event pour le menu gauche  a changer
$(window).trigger("menuToChange",[controller,action]);   
</script>

