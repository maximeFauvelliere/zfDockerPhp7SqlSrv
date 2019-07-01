<div class="content">
    <iframe id='ifr_download' name='bzDownload' src='' style="width:1px;border: none;height:1px;"></iframe>
    <div id="showDonwloadError" style="text-align:center;color:red;display:none;">
        Ce document n'est pas encore téléchargeable, son traitement est en cours.</br>Veuillez essayer ultérieurement.</p>
        <div style="text-align:center">
            <input type='button' value='fermer' onclick="$('#showDonwloadError').slideUp('slow')"/>
        </div>
    </div>
    <div id="canvasCellFermes">
    </div>
    <div id="canvas"></div>
    <div class="grilles">
        <div class="table table1">
            <div class="titleGrid" style="">STOCK EN DEPOT</div>
<!--             <div class="action"><img class="modLot" title="télécharger" src="/styles/img/ico_mod.png" alt="modifier"/></div>-->
            <table class="prospection" id="depot"></table>
        </div>
        <br/><br/>
        <div class="table table2">
            <div class="titleGrid" style="position: relative;top: 12px;float:left;">LISTE DES MOUVEMENTS</div>
            
            <div class="action"><a href="#"><img class="delLot" id="btDownload" src="/styles/img/download.png" alt="télécharger" title="Télécharger"/></a></div>
            <table class="prospection" id="lstMvt"></table>
        </div>
        <br/><br/><br/>
        <div class="table table3">
            <div class="titleGrid" style="position: relative;top: -3px;">QUALITES</div>
            <table class="prospection" id="qualite"></table>
        </div>
    </div>
</div>
<{$this->render('nav.tpl')}>
<script>
// show silo nav if hidden
    $("#canvas_siloNav").css("display","block");
//sub title
    $("#suTitreNav").text("Dépot");
    try{
        $("#D_filter").wijdialog({disabled: false});
    }catch(error){}
    

//def variable
    var grid1;
    var grid2;
    var grid3;

var cellules=null;
    //init var   
    cellules=<{$this->data}>;
    siloData=<{$this->siloData}>
        
    controller="<{$this->controller}>";
    action="<{$this->action}>";
    
    var camp;
    var pageSize=<{$this->pageSize}>;
             
//reader
// {name:"print",mapping:function(item){return "<a class='telechargement' href='/telechargement/index/idti/"+item.idti+"/clecu/"+item.clecu+"'>print</a>"}}
var reader1 = new wijarrayreader([
                {name:'idti',mapping:function(item){return item['@attributes']['idti']}},
                {name:'clecu',mapping:function(item){return item['@attributes']['clecu']}},   
                {name:'Camp',mapping:function(item){return item['@attributes']['camp']}},
                {name:'Culture',mapping:function(item){return item['@attributes']['cult']}},
                {name:'Nom',mapping:function(item){return item['@attributes']['nom']}},
                {name:"Brut",mapping:function(item){return item['@attributes']['qteb']}},
                {name:"Net",mapping:function(item){return item['@attributes']['qten']}}
               
]);    
var reader2= new wijarrayreader([
                {name:'tdoc',mapping:function(item){return item['@attributes']['tdoc']}},
                {name:'id',mapping:function(item){return item['@attributes']['id']}},
                {name:'Date',mapping:function(item){return item['@attributes']['date']}},
                {name:'N°Voyage',mapping:function(item){return item['@attributes']['voyage']}},
                {name:'BZ',mapping:function(item){return item['@attributes']['bz']}},
                {name:"N°bon",mapping:function(item){return item['@attributes']['bon']}},
                {name:"Type",mapping:function(item){return item['@attributes']['type']}},
                {name:"Brut",mapping:function(item){return item['@attributes']['qteb']}},
                {name:"Net",mapping:function(item){return item['@attributes']['qten']}}
               
]);
    
var reader3 = new wijarrayreader([
                {name:'Analyses',mapping:function(item){return item['@attributes'].analyse;}},
                {name:'Resutats',mapping:function(item){return item['@attributes'].resultat;}}

]);    
             
 // create datasource

function onSelectionChanged1(){

//permet de ré-initialiser la grill sinon appel 2 request ajax
 try{
    $("#lstMvt").wijgrid('destroy');
 }catch(e){
 
 }
 var selected = $("#depot").wijgrid("selection").selectedCells();
 var idRow=(pageSize*$("#depot").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();

 var mouvements = cellule[idRow].cultures.culture

    if(!isArray(mouvements)){
       mouvements=convertToArray(mouvements);
    }

    grid2= $("#lstMvt").wijgrid({
        allowSorting: true,
        allowPaging: true,
        culture:"fr-FR",
        pageSize: pageSize,
        allowColSizing: true,
        cellStyleFormatter: function (args){bzCenter(args)},
        data: new wijdatasource({reader:reader2,data:mouvements}),
         columns: [{visible:false},
              {visible:false},
              {},
              {},
              {},
              {},
              {},
              {dataType:"number",dataFormatString: "n3"},
              {dataType:"number",dataFormatString: "n3"},
              ],
         //ensureColumnsPxWidth : true,   
        selectionMode: "singleRow",
        selectionChanged: onSelectionChanged2
    });    
}

 
    
    
function onSelectionChanged2(){
   
   try{
        $("#qualite").wijgrid('destroy');
   }catch(error){
        //traitement erreur log ou autre 
   }
   
   var selected = $("#depot").wijgrid("selection").selectedCells();
   var idRow=(pageSize*$("#depot").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();
   
   var selected2 = $("#lstMvt").wijgrid("selection").selectedCells();
   var idRow2=(pageSize*$("#lstMvt").wijgrid('option','pageIndex'))+selected2.item(0).rowIndex();
   
   try{
   
        var culture = cellule[idRow].cultures.culture;
        
        if(!isArray(culture)){
               culture=convertToArray(culture);
        }
      
       var qualites =culture[idRow2].anamoy.qualite;

        if(!isArray(qualites)){
           qualites=convertToArray(qualites);
        }


        $("#qualite").wijgrid({
            allowSorting: true,
            //allowPaging: true,
            selectionMode:"none",
            //pageSize: pageSize,
            data: new wijdatasource({
                reader:reader3,
                data:qualites})
        });    
    }catch(error){
        //traitement erreur log ou autre 

    }
}  



function makeDataGrid(){

// datasource
 cellule=cellules.cellules.cellule;
    
//if convertion en tab    
if(!isArray(cellule)){
cellule=convertToArray(cellule);
} 

    // remote
            grid1= $("#depot").wijgrid({
                allowSorting: true,
                allowPaging: true,
                culture:"fr-FR",
                pageSize: pageSize,
                data: new wijdatasource({reader:reader1, data:cellule}),
                columns: [
                    {visible:false},
                    {visible:false},
                    {},
                    {},
                    {},
                    {dataType:"number",dataFormatString: "n3"},
                    {dataType:"number",dataFormatString: "n3"} 
                ],
                selectionMode: "singleRow",
                selectionChanged: onSelectionChanged1,
                loaded: function (data){
                    
                }
            });
}  


$("#btDownload").click(function(e){
    
    var selected = $("#lstMvt").wijgrid("selection").selectedCells();

    var tdoc=selected.item(0).row().data['tdoc'];
    var id=selected.item(0).row().data['id'];
    _gaq.push(['_trackEvent', 'telechargement', 'prospection_depot'+tdoc]);
     window.open("/telechargement/index/tdoc/"+tdoc+"/id/"+id+"/from/"+controller+"_"+action,"_blank");

      //$("#ifr_download").attr("src","/telechargement/index/tdoc/"+tdoc+"/id/"+id+"/from/"+controller+"_"+action)
 
    return false;
})

//traitement 
//create silo detail  
createDSilo(siloData.cellules.cellule[0],"2_");

// trig event pour le menu gauche  a changer
$(window).trigger("menuToChange",[controller,action]);
//google ana
_gaq.push(['_trackEvent','propsection', 'stock depot']);
</script>

