<!--affectation des data-->
<{if $this->data}>
 <script> 
  var adminData=<{$this->data}>
      
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
            <div class="titleGrid">ECHEANCIER PREVISIONNEL</div>
            <table class="factures" id="previsionnel"></table>

        </div>
        <br/>

        <div class="table table2">
            <div class="titleGrid" style="float: left;position: relative;top: 12px;">DETAIL PAR ECHEANCE</div>
            <div class="action"><a href="/telechargement"><img class="delLot" id="btDownload" src="/styles/img/download.png" alt="télécharger" title="Télécharger"/></a></div>
            <table class="factures" id="contrats" ></table>
            <div id="mention" style="font-size: 12pt;">*Ces prix s'entendent bruts sans prendre en compte d'éventuels réfactions, bonifications,frais ou taxes.</div>
        </div>
    </div>

    <div id="dialog"></div>
</div>
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
   

//reader
var reader1 = new wijarrayreader([
                 
                
                {name:"Date d'échéance",mapping:function(item){return item['@attributes']['date']}},
                {name:'Banque',mapping:function(item){return item['@attributes']['bque']}},
                {name:'Montant Calculé* €',mapping:function(item){return item['@attributes']['mtt']}},
                {name:'Nom',mapping:function(item){return item['@attributes']['nom']}}
               
               
]);    
var reader2= new wijarrayreader([
                {name:'tdoc',mapping:function(item){return item['@attributes']['tdoc']}},
                {name:'N° Contrat',mapping:function(item){return item['@attributes']['numct']}},
                {name:'Culture',mapping:function(item){return item['@attributes']['cult']}},
                {name:"Type",mapping:function(item){return item['@attributes']['type']}},
                {name:"Quantité t",mapping:function(item){return item['@attributes']['qte']}},
                {name:"Prix €",mapping:function(item){return item['@attributes']['prix']}}
      
]);


function onSelectionChanged1(){
   
 //destruction grid for bug two call 
    try{
            $("#contrats").wijgrid('destroy');
    }catch(e){
        
    }

 var selected = $("#previsionnel").wijgrid("selection").selectedCells();
 //var idRow=selected.item(0).rowIndex();
 var idRow=(pageSize*$("#previsionnel").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();
 
 contrats=adminData[idRow].contrat;
        
if(!isArray(contrats)){
      
contrats=convertToArray(contrats);
}

try{    

grid2= $("#contrats").wijgrid({
    culture:"fr-FR",
    allowSorting: true,
    allowPaging: true,
    pageSize: pageSize,
    columns:[{visible:false}],
    data:new wijdatasource({
        reader:reader2,
        data:contrats,
        loaded: function (data){
         
        }
    }),
    columns:[{visible:false},{},{},{},{dataType:"number",dataFormatString: "n2"},{dataType:"number",dataFormatString: "n2"}]

});    
}catch(error){
alert("Une erreur s'est produite, rechargez la page.")
}    
    

 
}



function makeDataGrid(){

adminData=adminData.administration.previsionnel;
 
//if convertion en tab    
if(!isArray(adminData)){
adminData=convertToArray(adminData);
} 

    // call grid 1 ajax call
            grid1= $("#previsionnel").wijgrid({
                 culture:"fr-FR",
                 allowSorting: true,
                 allowPaging: true,
                 pageSize: pageSize,
                 data:new wijdatasource({
                        reader:reader1,
                        data:adminData,
                        loaded: function (data){

                        }
                 }),
                  columns:[{},{},{dataType:"number",dataFormatString: "n2"},{}
                      ],
                //ensureColumnsPxWidth : true,
                selectionMode: "singleRow",
                selectionChanged: onSelectionChanged1
            }).wijgrid("setSize",640);
      

}

 $("#btDownload").click(function(e){

    var selected = $("#contrats").wijgrid("selection").selectedCells();
//console.log("data admin previ", $("#contrats").wijgrid("data"))
    var tdoc=selected.item(0).row().data['tdoc'];
    var id=selected.item(0).row().data['N° Contrat'];

    window.open("/telechargement/index/tdoc/"+tdoc+"/id/"+id+"/from/"+controller,"_blank");
    window.scrollTo(0,0);
    return false;
})

// trig event pour le menu gauche  a changer
$(window).trigger("menuToChange",[controller,action]);   
</script>

