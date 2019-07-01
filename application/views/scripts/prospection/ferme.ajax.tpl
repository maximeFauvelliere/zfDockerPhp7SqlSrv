<div class="content" style="top:35px">
    <div id="comSlide">
        <div id="btComSlide" class="unselectable btComSlide"></div>
    </div>
    <div>
        <span style="position: relative;top:-22px;float: right">Détail par cellule</span>
    <div id="slideDownCell" style="display:none">
        <div id="canvasCellFermes" style="overflow: auto;width:900px;position:relative;left:-50px">
        </div>
    </div>
    </div>
    
    <div style="margin-left: 350px; margin-top: 35px;">
        <input type="button" id="btStFerme"  title="ajouter" value="Ajouter un lot de stock ferme"/>
    </div>
    <div id="canvas" class="canvasFerme"></div>
    <div class="grilles">
        <div class="table table1">
            <div class="titleGrid" style="float: left;position: relative;top: 12px;">LOTS EN STOCK FERME</div>
            <div class="action"><img class="modLot" src="/styles/img/ico_mod.png" alt="Modifier" title="Modifier"/><img class="delLot" src="/styles/img/ico_del.png" alt="Supprimer" title="Supprimer"/></div>
            <table class="prospection" id="lots"></table>
        </div>
        <div class="table table2">
            <div class="titleGrid" style="">QUALITES MOYENNEES</div>
            <table class="prospection" id="analyses"></table>
        </div>
    </div>
</div>
<div class="confirm trash"  title="confirmation" style="display:none">
    Etes-vous sûr de vouloir supprimer ce lot ?
</div>
<{$this->render('nav.tpl')}>


<script>
    
    
    // show silo nav if hidden
    $("#canvas_siloNav").css("display","block");
    //sub title
    $("#suTitreNav").text("Stock Ferme");
    
    try{
       $("#D_filter").wijdialog({disabled: false}); 
    }catch(error){
    
    }
    

    var cellules=null;
    //init var   
    cellules=<{$this->data}>;
    siloData=<{$this->siloData}>
        
    controller="<{$this->controller}>";
    action="<{$this->action}>";

    //def variable
    var grid1;
    var grid2;
    
    var camp;
    var pageSize=<{$this->pageSize}>;
// supprime un lot 
    function delLot(){
        
        if($(".bzModale").length<1){
            $('body').append("<div class='bzModale' style='z-index:3000'></div>");
        }
        $(".bzModale").css("display","block");
        $(".bzModale").css("height",$(document).height());
        $(".bzModale").css("width",$(document).width());
        $("#preloader").css("display","block");
        var selected = $("#lots").wijgrid("selection").selectedCells();
        var idRow=(pageSize*$("#lots").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();
 
        idLot=$("#lots").wijgrid("data")[idRow]['id'];
        //idLot=selected.item(0).value();  
        url="/prospection/dellot/format/html";
        $.ajax({
        url:url,
        data:{"idLot":idLot},
        success:function(result){

            $("#main").empty();
            $("#main").append(result);
            makeDataGrid();
            $(".bzModale").remove();
            $("#preloader").css("display","none");
        }
        })
        _gaq.push(['_trackEvent', 'propsection', 'ferme_supp_lot','suppression lot']);
    }



   // function actions(){
    $(".delLot").click(function(){
    
    $(".confirm").wijdialog({
        dialogClass:"D_confirm",
        captionButtons:{
            pin: {visible: false},
            refresh: {visible: false},
            toggle: {visible: false},
            minimize: {visible: false},
            maximize: {visible: false},
            close: {visible: false}
        },
        buttons: [{text:"Oui", click: function(){$(".confirm").wijdialog("close");delLot()}},{text:"Non", click: function(){$(".confirm").wijdialog("close")}}]
        
    
    });
})

$('.modLot').click(function(e){
    
        var selected = $("#lots").wijgrid("selection").selectedCells();
        var idRow=(pageSize*$("#lots").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();
 
        id=$("#lots").wijgrid("data")[idRow]['id'];
        //id=selected.item(0).value(); 
        _gaq.push(['_trackEvent', 'propsection', 'ferme_mod_lot','modification lot']);
                    
        location.hash="prospection_showlot/id/"+id;
      
    });
    
//}

   

function analyses(){

var selected = $("#lots").wijgrid("selection").selectedCells();
//idRow=selected.item(0).rowIndex();
idRow=(pageSize*$("#lots").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();
//analyse=  cellules.cellules.cellule[idRow].analyses.analyse?cellules.cellules.cellule[idRow].analyses.analyse:null;  
    
    
cellule=cellules.cellules.cellule;
        

//if convertion en tab    
if(!isArray(cellule)){
      
cellule=convertToArray(cellule);
}
    
if(isSet(cellule[idRow].anamoy)){
        
$("#analyses").wijgrid({data: []});
return;
}
    
    
try{
        
    analyse= cellule[idRow].anamoy.qualite; 

    if(!isArray(analyse)){
    analyse=convertToArray(analyse);
    }


    grid2= $("#analyses").wijgrid({
    selectionMode:"none",
    data:new wijdatasource({
    reader:reader2,
    data:analyse
    
    })

    });    
}catch(error){
    //traitement erreur log ou autre 
    //alert("Une erreur s'est produite, rechargez la page.")
}    
    

}

  
//move canvasCellFermes avant canvas
//$('#canvasCellFermes').insertBefore('#canvas'); 
//$('#canvasCellFermes').insertAfter('.grilles');  

//traitement 
//create silo detail  
createDSilo(siloData.cellules.cellule[1],"2_",false);
//call create silo global
createSilo("canvasCellFermes","5000px",410,45,70,92.655,277,"setGlobal",false,[cellules],false,"1_",true);

//reader
//reader
var reader2 = new wijarrayreader([
                
    {name:'Analyses',mapping:function(item){return item['@attributes']['code']}},
    {name:'Résultats',mapping:function(item){return item['@attributes']['valeur']}}
                
]);      
    
    
var reader1 = new wijarrayreader([
    {name:'id',mapping:function(item){return item['@attributes']['id']}},
    {name:'Camp',mapping:function(item){return item['@attributes']['camp']}},
    {name:'Cultures',mapping:function(item){return item['cultures']['culture']['@attributes']['nom']}},
    {name:'Nom lot',mapping:function(item){return item['@attributes']['titre']}},    
    {name:'Type',mapping:function(item){return item['cultures']['culture']['@attributes']['type']}},
    {name:'Solde',mapping:function(item){return item['cultures']['culture']['@attributes']['solde']}},
    {name:'Poids',mapping:function(item){return item['cultures']['culture']['@attributes']['valeur']}},
    {name:'Surface',mapping:function(item){return item['cultures']['culture']['@attributes']['ha']}},
    {name:'Structure',mapping:function(item){return item['cultures']['culture']['@attributes']['structure']}},
    //{name:'Destination',mapping:function(item){return item['cultures']['culture']['@attributes']['dest']}}
// {name:'Action',mapping:function(item){return "<div class='actionsLot'><a class='modLot'  rowId='"+item['@attributes']['id']+"' href='' >mod  </a><a class='delLot' rowId='"+item['@attributes']['id']+"' href=''> sup</a></div>"}}   
]);    


// formatting columns
/*var test= function (args) {

                    if (args.column.dataType == 'string') {
                        console.log(" $(args.$cell)", $(args.$cell));
                        $(args.$cell).css("color", "red!important");
                    }
                }
*/

function makeDataGrid(){

    
    // create datasource
    

    cellule=cellules.cellules.cellule;
    
    //if convertion en tab    
    if(!isArray(cellule)){
    cellule=convertToArray(cellule);
    } 
     
    // remote
    grid1= $("#lots").wijgrid({
    culture:"fr-Fr",
    allowSorting: true,
    allowPaging: true,
    pageSize: pageSize,
    data:new wijdatasource({
        reader:reader1,
        data:cellule,
    loaded: function (data){
    
    }
    }),
    
    columns:[
      {visible:false},
      {width:"50px"},
      {width:"80px"},
      {width:"100px"},
      {width:"60px"},
      {width:"60px",dataType:"number",dataFormatString: "n3"},
      {width:"60px",dataType:"number",dataFormatString: "n2"},
      {width:"60px",dataType:"number",dataFormatString: "n2"},
      {width:"155px"},
      
      ],
    ensureColumnsPxWidth : true,
   // cellStyleFormatter:test,
    //rendered:actions,
    selectionMode: "singleRow",    
    selectionChanged: analyses
    })//.wijgrid("setSize",1200);

                
}
  // slide down/up cell detail
  $("#btComSlide").click(function(e){
        
        $('#slideDownCell').slideToggle('slow', function() {
            // Animation complete.
            $("#btComSlide").toggleClass("btComSlideactive");
            $("#btComSlide").toggleClass("btComSlide");
        });
        _gaq.push(['_trackEvent', 'propsection', 'ferme_detail_Cellule','affiche/cache le detail cellule']);
                    
  })

 //add stock ferme  
    $("#btStFerme").click(function(e){
                    /*$.get("/prospection/addferme/format/html",function(data){
                        $("#main").empty();
                        $("#main").append(data);       
                    })*/
                    location.hash="prospection_addferme";
              })  

// trig event pour le menu gauche  a changer
$(window).trigger("menuToChange",[controller,action]);

_gaq.push(['_trackEvent', 'propsection', 'stock ferme']);
</script>

