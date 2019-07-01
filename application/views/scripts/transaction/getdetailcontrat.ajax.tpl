
<div class="content">
    <iframe id='ifr_download' name='bzDownload' src='' style="width:1px;border: none;height:1px;"></iframe>
    <div id="showDonwloadError" style="text-align:center;color:red;display:none;">
        Ce document n'est pas encore téléchargeable, son traitement est en cours.</br>Veuillez essayer ultérieurement.</p>
        <div style="text-align:center">
            <input type='button' value='fermer' onclick="$('#showDonwloadError').slideUp('slow')"/>
        </div>
    </div>
    <{if $this->message}><h1><{$this->message}></h1><{/if}>
    <div id="canvas" class="canvasFerme"></div>
    <div class="grilles">
        <div class="table table1">
            <div class="titleGrid">CONTRATS <{$this->contratName}></div>
 
            <table class="prospection" id="contrats"></table>
        </div>
        <div class="table table2">
            <div class="titleGrid" style="float: left;position: relative;top: 12px;">LISTE DES CONTRATS</div>
            <div class="action"><img class="download" src="/styles/img/download.png" alt="modifier" title="Télécharger"/></div>
            <table class="prospection" id="listeContrats"></table>
        </div>
        <div class="table table3">
            <div class="titleGrid" style="position: relative;">QUALITES</div>
            <table class="prospection" id="qualites"></table>
        </div>
        <div class="table table4">
            <div class="titleGrid" style="position: relative;">DETAIL DU CONTRAT</div>
            <table class="prospection wijmo-wijgrid-root wijmo-wijgrid-table" id="detail" style="width:640px" ></table>
        </div>
    </div>
</div>
<{$this->render('nav.tpl')}>


<script>
    
    // show silo nav if hidden
    $("#canvas_siloNav").css("display","block");
    //sub title
    $("#suTitreNav").text("Contrats engagés");

    var cellules=null;
    //init var   
    
    var contratName="<{$this->contratName}>";
    siloData=<{$this->siloData}>
        //console.log("silo data",siloData);
        
    controller="<{$this->controller}>";
    action="<{$this->action}>";

    //def variable
    var grid1;
    var grid2;
    var grid3;
    var camp;
    var pageSize=<{$this->pageSize}>;
    

    var contrats=<{$this->data}>;
    
    //console.log("contrats",contrats);
    
    if(contrats.contrats==""){
        alert("Ce produit n'existe pas  pour cette campagne.");
        location.hash="transaction_index";
        //exit script
        throw "";
    }

//move canvasCellFermes avant canvas
//$('#canvasCellFermes').insertBefore('#canvas'); 


//traitement 
//create silo detail

/**
*cherche la cellule selectionné en fonction du nom du contrat
*recupere l'index de la boucle pour recuperer les donné de la cellule selectionnée
*/

$.each(siloData.cellules.cellule,function(i,e){

    if(e['@attributes'].titre.toLowerCase()==contratName.toLowerCase()){
        cellIdTran=i;
    }
});
//create silo detail
createDSilo(siloData.cellules.cellule[cellIdTran],"2_",false);

//ajoute pastille contrat en cours

var produit=siloData.cellules.cellule[cellIdTran]['@attributes'].typect;

if(siloData.cellules.cellule[cellIdTran]['@attributes'] && parseInt(siloData.cellules.cellule[cellIdTran]['@attributes'].haslock)){

$("#canvas").prepend('<div id="pastilleContrat" class="cursor"><span>'+siloData.cellules.cellule[cellIdTran]['@attributes'].nbcontrats+'</span></div>');
}

/**
* construit dynamiquement les wijarrayreader de wijmo grid
*/

var autoReader1=[];
var autoReader2=[];
var autoReader3=[];

var lesContrats=contrats.contrats.contrat;

if(!isArray(lesContrats)){
      
lesContrats=convertToArray(lesContrats);

}


//fill autoReader 1
$.each(lesContrats,function(i,leContrat){
   
    // nous avons besoin seulement du premier contrat
    //les suivants seront identique en structures
    if(i==0){
        $.each(leContrat,function(h,colonne){
            // console.log("h",contrats.contrats.contrat[i][h]['@text']);
            // si les enfants ont un attribut et un attribut lib seulement
            if(colonne['@attributes'] && colonne['@attributes'].lib){
               autoReader1.push({name:colonne['@attributes'].lib,mapping:function(item){return item[h]['@text']}});
            }
        })  
    }
});

//fill autoReader 2
var listeDesContrats=lesContrats[0].listecontrats.contrat;

if(!isArray(listeDesContrats)){
      
    listeDesContrats=convertToArray(listeDesContrats);

}

$.each(listeDesContrats,function(z,element){

    $.each(element,function(h,colonne){


                // si les enfants ont un attribut et un attribut lib seulement
                if(colonne['@attributes'] && colonne['@attributes'].lib){
                    
                   autoReader2.push({name:colonne['@attributes'].lib,mapping:function(item){
                      
                      if(h=="prix" &&  !item[h]['@text']){
                        return "<div class='cadenas'></div>";
                      }else{
                        return item[h]['@text']
                        }                
                     }
                   });
                }
    });
})

//fill autoReader 3
var qualites=listeDesContrats[0].qualites.qualite;





    $.each(qualites,function(i,elements){

        autoReader3.push({name:"Critere",mapping:function(item){return item['@attributes']['critere']}});
        autoReader3.push({name:"Norme",mapping:function(item){return item['@attributes']['resultat']}});
    });



var reader1 = new wijarrayreader(autoReader1); 

var reader2 = new wijarrayreader(autoReader2);

var reader3 = new wijarrayreader(autoReader3);

//var currentQualites;

function lesQualites(){
    
    
    //contrat tolock click ici pour etre sur que la grille est rendue
    $(".cadenas").click(function(e){
    alert("click cadenas");
        if(siloData.cellules.cellule['@attributes'].nbContrats){
            location.hash="transaction_getcontrattolock/contrat/"+siloData.cellules.cellule['@attributes'].typect;
        }else{
            alert("Il n'y a pas optimiz a bloquer.")
        }
    })
    
    var selected = $("#listeContrats").wijgrid("selection").selectedCells();
    idRow=(pageSize*$("#listeContrats").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();

    var currentQualites= liste[idRow].qualites; 

        if(!isArray(currentQualites)){
            currentQualites=convertToArray(currentQualites);
        }

    try{
       
        mesQualites= currentQualites[0].qualite; 

        if(!isArray(mesQualites)){
            mesQualites=convertToArray(mesQualites);
        }

        
        grid3= $("#qualites").wijgrid({
            allowSorting: true,
            culture:"fr-FR",
            cellStyleFormatter: function (args){bzCenter(args)},
            //allowPaging: true,
            //pageSize: pageSize,
            data:new wijdatasource({
            reader:reader3,
            data:mesQualites
            })
            
        });    
    }catch(error){
    alert("une erreur s'est produite recharger la page");

    } 
    
    
    // grid detail
    var detail=liste[idRow].detail.td;
    
    if(!isArray(detail)){
            detail=convertToArray(detail);
        }
    
    //vide la table detail 
    $("#detail").empty();
    $("#detail").append("<thead><tr class='wijmo-wijgrid-headerrow'></tr></thead><tbody><tr class='wijmo-wijgrid-row ui-widget-content wijmo-wijgrid-datarow'></tr></tbody>")
    
    $.each(detail,function(i,e){

            //console.log("e",e['@text'])
            
            var text=e['@text']?e['@text']:"";
            
            $("#detail thead tr").append("<td class='wijgridth ui-widget wijmo-c1basefield ui-state-default wijmo-c1field'>"+e['@attributes'].lib+"</td>");
          
            $("#detail tbody tr").append("<td class='wijgridtd wijdata-type-string'>"+text+"</td>");

    });
    

}

function listeContrats(){

var selected = $("#contrats").wijgrid("selection").selectedCells();

//idRow=selected.item(0).rowIndex();
idRow=(pageSize*$("#contrats").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();



//analyse=  cellules.cellules.cellule[idRow].analyses.analyse?cellules.cellules.cellule[idRow].analyses.analyse:null;  

    
liste=lesContrats[idRow].listecontrats.contrat;
//liste=lesContrats[idRow].listecontrats.contrat;

//if convertion en tab    
if(!isArray(liste)){    
    liste=convertToArray(liste);
}


  
try{

    grid2= $("#listeContrats").wijgrid({
        allowSorting: true,
        allowPaging: true,
        pageSize: pageSize,
        data:new wijdatasource({
            reader:reader2,
            data:liste
        }),
        columns:[{visible:false},{visible:false}],
        selectionMode: "singleRow",    
        selectionChanged:lesQualites
    });    
}catch(error){
alert("une erreur s'est produite recharger la page");

}    
    

}

function makeDataGrid(){
 
// create datasource
if(!contrats.contrats) return;
contrat=contrats.contrats.contrat;
//if convertion en tab    
if(!isArray(contrat)){
contrat=convertToArray(contrat);
} 


// remote
grid1= $("#contrats").wijgrid({
allowSorting: true,
allowPaging: true,
pageSize: pageSize,
data:new wijdatasource({
    reader:reader1,
    data:contrat
}),
//columns: [{visible:false}],
selectionMode: "singleRow",    
selectionChanged: listeContrats
});

                
} 

// click telechargement
$(".download").click(function(){

    var selected = $("#listeContrats").wijgrid("selection").selectedCells();

    var tdoc=selected.item(0).row().data['tdoc'];
    var id=selected.item(0).row().data['id'];
    
     //$("#ifr_download").attr("src","/telechargement/index/tdoc/"+tdoc+"/id/"+id+"/from/"+controller)
    window.open("/telechargement/index/tdoc/"+tdoc+"/id/"+id+"/from/"+controller,"_blank");
    window.scrollTo(0,0);
    return false;
})


function getOptimiz(){
    if(action=="getoptimises") return;

    location.hash=controller+"_getoptimises/typeCt/"+siloData.cellules.cellule[cellIdTran]['@attributes'].typect;
    return;
   
}

if(siloData.cellules.cellule[cellIdTran].optimiz && siloData.cellules.cellule[cellIdTran].optimiz['@attributes'].nboptimiz){

    $("#canvas").prepend('<div id="pastilleOpti" class="cursor"><span>'+siloData.cellules.cellule[cellIdTran].optimiz['@attributes'].nboptimiz+'</span></div>');

}


$("#pastilleOpti").click(function(){
    location.hash="transaction_getoptimises/typeCt/"+produit;

})


$("#pastilleContrat").click(function(){

    location.hash="transaction_getcontrattolock/contrat/"+produit;


})
     //timer de rechargement de la page pour actualisation du prix de marché
     bzTimers.push(setInterval(function(){


        //location.hash="transaction_getdetailcontrat/contrat/"+contratName;
        //$(window).trigger("hashchange");
     },5000)
);
// trig event pour le menu gauche  a changer
$(window).trigger("menuToChange",[controller,"index"]);
</script>

