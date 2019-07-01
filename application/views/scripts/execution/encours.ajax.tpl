<!--affectation des data-->
<{if $this->data}>
<script> 
    var exeData=<{$this->data}>
    var camp;
    var pageSize=<{$this->pageSize}>;
</script>
<{/if}>
<div class="content">
    <iframe id='ifr_download' name='bzDownload' src='' style="width:1px;border: none;height:1px;"></iframe>
    <div id="showDonwloadError" style="text-align:center;color:red;display:none;">
        Ce document n'est pas encore téléchargeable, son traitement est en cours.</br>Veuillez essayer ultérieurement.</p>
        <div style="text-align:center">
            <input type='button' value='fermer' onclick="$('#showDonwloadError').slideUp('slow')"/>
        </div>
    </div>
    <div id="canvas"></div>
    <div class="grilles">
        <div class="table table1">
            <div class="titleGrid">ENTREES AFFECTEES AUX CONTRATS</div>
            <table class="execution" id="execution"></table>

        </div>

        <div class="table table2">
            <div class="titleGrid" style="position: relative;top: 35px;">LISTE DES BONS D'APPORT</div>
            <div class="action"><a href="/telechargement"><img class="delLot" id="btDownload" src="/styles/img/download.png" alt="télécharger" title="Télécharger"/></a></div>
            <table class="execution" id="lstBon" ></table>
        </div>

        <div class="table table3">
            <div class="titleGrid" style="position: relative;top: -6px;">Qualités</div>
            <table class="execution" id="qualites" ></table>
        </div>
        


    </div>
</div>

<div id="dialog"></div>
<{$this->render('nav.tpl')}>
<script>
    // show silo nav if hidden
    $("#canvas_siloNav").css("display","block");
    //sub title
    $("#suTitreNav").text("En cours");
    
    
    controller="<{$this->controller}>";
    action="<{$this->action}>";

    //create gsilo [0] index de la cellule 
    createDSilo(siloData.cellules.cellule[1],"2_");


    //def variable
    var grid1;
    var grid2;
    var grid3;

    //reader
    var reader1 = new wijarrayreader([
                 
                
    {name:'Camp',mapping:function(item){return item['@attributes']['camp']}},
    {name:'Culture',mapping:function(item){return item['@attributes']['cult']}},
    {name:'Nom',mapping:function(item){return item['@attributes']['nom']}},
    {name:'Date',mapping:function(item){return item['@attributes']['date']}},
    {name:'Nb voyages',mapping:function(item){return item['@attributes']['nbvoy']}},
    {name:'Nb apports',mapping:function(item){return item['@attributes']['nbapp']}},
    {name:'Quantité t',mapping:function(item){return item['@attributes']['qte']}}
   
               
               
        ]);    
        var reader2= new wijarrayreader([
    {name:'tdoc',mapping:function(item){return item['@attributes']['tdoc']}},
    {name:'idBon',mapping:function(item){return item['@attributes']['idbon']}},
    {name:'N°voyage',mapping:function(item){return item['@attributes']['numvoy']}},
    {name:'BZ',mapping:function(item){return "BZ"}},
    {name:'N° Bon',mapping:function(item){return item['@attributes']['numbon']}},
    {name:"Type",mapping:function(item){return item['@attributes']['typepe']}},
    {name:'N°Contrat',mapping:function(item){return item['@attributes']['numct']}},
    {name:"Brut t",mapping:function(item){return item['@attributes']['qteb']}},
    {name:"Net t",mapping:function(item){return item['@attributes']['qten']}},
    {name:'Transp.',mapping:function(item){return item.transport['@attributes']['nom']}}
      
        ]);

        var reader3= new wijarrayreader([
                
    {name:'Analyses',mapping:function(item){return item['@attributes']['code']}},
    {name:'Résultat',mapping:function(item){return item['@attributes']['value']}}
      
        ]);



  function onSelectionChanged2(){
        //destruction grid for bug two call 
        try{
            $("#qualites").wijgrid('destroy');
        }catch(e){
        
        }
        var selected = $("#execution").wijgrid("selection").selectedCells();
        var idRow=(pageSize*$("#execution").wijgrid('option','pageIndex'))+selected.item(0).rowIndex()
        var selected2 = $("#lstBon").wijgrid("selection").selectedCells();
        var idRow2=(pageSize*$("#lstBon").wijgrid('option','pageIndex'))+selected2.item(0).rowIndex();
        
        var tab=exeData[idRow].bon

        //for bon
        if(! isArray(tab)){
             tab=convertToArray(tab);
        }
        
        // set transporteur ici sinon bug sur not table bon (1bon); 
       //$("#transp").text(tab[idRow2].transport['@attributes'].nom);

        tab=tab[idRow2].analyse;
        
       
        //for analyses
        if(! isArray(tab)){
             tab=convertToArray(tab);
        }
        
    // if analyse empty
    if(tab==""){
        $(".table3").empty();
        $(".table3").append("<span id='notData'>Pas d'analyses enregistrées.</span>");
        return;
    }else{
        $("#notData").remove();
    }
 
try{    

    grid3= $("#qualites").wijgrid({
        selectionMode:"none",
        data:new wijdatasource({
            reader:reader3,
            data:tab
        })
    });    
}catch(error){
    alert("Une erreur s'est produite, rechargez la page.")
}  
 
}

function onSelectionChanged1(){
    
    //destruction grid for bug two call
    try{
          $("#lstBon").wijgrid('destroy');
    }catch(error){
      
    }
    

    var selected = $("#execution").wijgrid("selection").selectedCells();
    var idRow=(pageSize*$("#execution").wijgrid('option','pageIndex'))+selected.item(0).rowIndex()
    //var idRow=selected.item(0).rowIndex();

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
        cellStyleFormatter: function (args){bzCenter(args)},
        columns:[
            {visible:false},
            {visible:false},
            {},
            {},
            {},
            {},
            {},
            {dataType:"number",dataFormatString: "n3"},
            {dataType:"number",dataFormatString: "n3"},
            {}],
        data:new wijdatasource({
            reader:reader2,
            data:bon
        }),
        selectionMode: "singleRow",
        selectionChanged: onSelectionChanged2

      });    
}catch(error){
    alert("Une erreur s'est produite, rechargez la page.")
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
        culture:"fr-FR",
        allowSorting: true,
        allowPaging: true,
        pageSize: pageSize,
        data:new wijdatasource({
            reader:reader1,
            data:exeData
        }),
        columns: [{},{},{},{},{},{},{dataType:"number",dataFormatString: "n3"}],
        selectionMode: "singleRow",
        selectionChanged: onSelectionChanged1
    });
      

}

$("#btDownload").click(function(e){

    var selected = $("#lstBon").wijgrid("selection").selectedCells();

    var tdoc=selected.item(0).row().data['tdoc'];
    var id=selected.item(0).row().data['idBon'];

    //return false;
    //$("#ifr_download").attr("src","/telechargement/index/tdoc/"+tdoc+"/id/"+id+"/from/"+controller)
    //location.href="/telechargement/index/tdoc/"+tdoc+"/id/"+id+"/from/"+controller+"_"+action;
    window.open("/telechargement/index/tdoc/"+tdoc+"/id/"+id+"/from/"+controller,"_blank");
    window.scrollTo(0,0);
    return false;
})
  
// trig event pour le menu gauche  a changer
$(window).trigger("menuToChange",[controller,action]);   
</script>

