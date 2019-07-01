<!--affectation des data-->
<{if $this->data}>
 <script> 
  var adminData=<{$this->data}>
 var camp;
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
            <div class="titleGrid">FACTURES</div>
            <table class="factures" id="factures"></table>

        </div>
        <br/><br/>
        <div class="table table2">
             <div class="titleGrid" style="float: left;position: relative;top: 12px;">DETAIL DES FACTURES</div>
            <div class="action"><img class="btVisu" src="/styles/img/picto_oeil.png" alt="Visualiser" title="Visualiser"/><a href="#"><img class="delLot" id="btDownload" src="/styles/img/download.png" alt="Télécharger" title="Télécharger" /></a></div>
            <table class="factures" id="lstFac" ></table>
        </div>
    </div>



    <div id="dialog" class="trash" title="Détail de la facture">
        <div id="detailHisto">
            <div class="table table3" style="border-top:0px;padding-left:0px;">
                <table id="detFac" ></table>
            </div>
            <table>
                 <tr>
                    <td class="wraperLabel det_fact">
                        Type paiement
                    </td>
                    <td id="tpaiement">

                    </td>
                    <td class="wraperLabel det_fact">
                        Date paiement
                    </td>
                    <td id="datePaiement">

                    </td>

                </tr>
                <tr>
                   <td class="wraperLabel det_fact">
                        Banque
                    </td>
                    <td id="banque">

                    </td>
                    <td class="wraperLabel det_fact">
                        Réglé
                    </td>
                    <td id="reglement">

                    </td> 

                </tr>

            </table>
        </div>

    </div>
</div>
<{$this->render('nav.tpl')}>
<script>
var pageSize=<{$this->pageSize}>;
// show silo nav if hidden
$("#canvas_siloNav").css("display","block");
//sub title
$("#suTitreNav").text("Historique");


controller="<{$this->controller}>";
action="<{$this->action}>";

//create gsilo [0] index de la cellule 
createDSilo(siloData.cellules.cellule[0],"2_");


//def variable
    var grid1;
    var grid2;
    var grid3;

//reader
var reader1 = new wijarrayreader([
                 
                
                {name:'Camp',mapping:function(item){return item['@attributes']['camp']}},
                {name:'Culture',mapping:function(item){return item['@attributes']['culture']}},
                {name:'Nom',mapping:function(item){return item['@attributes']['nom']}},
                {name:'Nb Factures',mapping:function(item){return item['@attributes']['nbfac']}}
               
               
]);    
var reader2= new wijarrayreader([
                {name:'id',mapping:function(item){return item['@attributes']['id']}},
                {name:'tdoc',mapping:function(item){return item['@attributes']['tdoc']}},
                {name:'N° Fac',mapping:function(item){return item['@attributes']['numfac']}},
                {name:'Date',mapping:function(item){return item['@attributes']['datetech']}},
                {name:"Type",mapping:function(item){return item['@attributes']['type']}},
                {name:'N°ct',mapping:function(item){return item['@attributes']['numct']}},
                {name:"Quantité t",mapping:function(item){return item['@attributes']['qte']}},
                {name:"Montant Net",mapping:function(item){return item['@attributes']['mttnet']}}
                
      
]);

var reader3= new wijarrayreader([
                {name:'Libellé',mapping:function(item){return item['@attributes']['lib']}},
                {name:'Montant',mapping:function(item){return item['@attributes']['mtt']}},
                {name:"Détail",mapping:function(item){return item['@attributes']['detail']}}
]);



function onSelectionChanged2(){

     var selected = $("#factures").wijgrid("selection").selectedCells();
     var idRow=(pageSize*$("#factures").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();

     var selected2 = $("#lstFac").wijgrid("selection").selectedCells();
     var idRow2=(pageSize*$("#lstFac").wijgrid('option','pageIndex'))+selected2.item(0).rowIndex();
     
     
     var fact=adminData[idRow].fact;

     if(!isArray(fact)){

                fact=convertToArray(fact);
            }
    //target fact detail 
    fact=fact[idRow2];
   
    $("#tpaiement").text(fact['@attributes'].typaiem);
    $("#datePaiement").text(fact['@attributes'].datetech);
    $("#banque").text(fact['@attributes'].bque);
    $("#reglement").text(fact['@attributes'].regle);
    try{
        $("#detFac").wijgrid('destroy');
     }catch(e){
     
     }
     makeDetail() 
     //pour bug affichage dans popup
     try{
        $("#detFac").wijgrid('refresh');
     }catch(e){
     
     }
               
}

function onSelectionChanged1(){
    
     //destruction grid for bug two call   
     try{
            $("#lstFac").wijgrid('destroy');
     }catch(e){
     
     }

     var selected = $("#factures").wijgrid("selection").selectedCells();
     //var idRow=selected.item(0).rowIndex();
     var idRow=(pageSize*$("#factures").wijgrid('option','pageIndex'))+selected.item(0).rowIndex()
     
     factures=adminData[idRow].fact;

    if(!isArray(factures)){
    
        factures=convertToArray(factures);
    }
    
    //console.log("factures",factures)

    try{    

    grid2= $("#lstFac").wijgrid({
    culture:"fr-FR",
    allowSorting: true,
    allowPaging: true,
    pageSize: pageSize,
    cellStyleFormatter: function (args){bzCenter(args)},
    data:new wijdatasource({
    reader:reader2,
    data:factures
    }),
    columns: [{visible:false},{visible:false},{},{},{},{},{dataType:"number",dataFormatString: "n3"},{dataType:"number",dataFormatString: "n2"}],
    selectionMode: "singleRow",
    selectionChanged: onSelectionChanged2,
    rendered:function(){
            
            // click
            $(".btVisu").click(function(){
            
                 $('#dialog').wijdialog('open');

            })
}

}).wijgrid("setSize", 640);
}catch(error){
alert("Une erreur s'est produite, rechargez la page."+error)
}    
    

 
}

function makeDetail(){

            var selected = $("#factures").wijgrid("selection").selectedCells();
            var idRow=selected.item(0).rowIndex();

           var selected2 = $("#lstFac").wijgrid("selection").selectedCells();
           var idRow2=selected2.item(0).rowIndex();
           
           var details=adminData[idRow].fact;
           
           if(!isArray(details)){

                details=convertToArray(details);
            }
            
            //target table
            details=details[idRow2];
            //traget detail object
            details=details.details.detail;
            
            if(!isArray(details)){

                details=convertToArray(details);
            }

             // call grid 1 ajax call
            grid3= $("#detFac").wijgrid({
                
                culture:"fr-FR",
                data:new wijdatasource({
                        allowSorting: true,
                        allowPaging: true,
                        pageSize: pageSize,
                        reader:reader3,
                        data:details
                      }),
                columns:[{},{dataType:"number",dataFormatString: "c2"},{dataType:"number",dataFormatString: "c2"}]
                        
                      
            });

}

function makeDataGrid(){

adminData=adminData.administration.factures;


//if convertion en tab    
if(!isArray(adminData)){
adminData=convertToArray(adminData);
} 
    // call grid 1 ajax call
            grid1= $("#factures").wijgrid({
                culture:"fr-FR",
                allowSorting: true,
                allowPaging: true,
                pageSize: pageSize,
                data:new wijdatasource({
                        reader:reader1,
                        data:adminData
                 }),
                selectionMode: "singleRow",
                selectionChanged: onSelectionChanged1
            });
      

}

 $('#dialog').wijdialog({
                              autoOpen: false,
                              modal:true,
                              width:800,
                              captionButtons: {
                              refresh: { visible: false},
                              pin: { visible: false},
                              minimize: { visible: false},
                              maximize: { visible: false},
                              toggle: { visible: false},
                              close:{visible:false}
                          }
                      });

  $("#dialog").wijdialog({ open: function (e) {
                
              
                            var dialog=$(e.target);
                                if(!$(".sc-bt-dialog-close").length){
                                     $(e.target).parent().find(".ui-dialog-titlebar").append("<span class='sc-bt-dialog-close' style='cursor:pointer;position:absolute;right:5px;' ></div>");
                                            $(".sc-bt-dialog-close").bind("click",function(e){
                                                dialog.wijdialog('close');
                                            })
                                 }
                       
                 
                 /*
                 *appeler 2 fois car bug affichage a la premiere
                 *a revir si tps
                 */
                makeDetail();
                onSelectionChanged2();
                }
        });
        
    $("#btDownload").click(function(e){

    var selected = $("#lstFac").wijgrid("selection").selectedCells();

    var tdoc=selected.item(0).row().data['tdoc'];
    var id=selected.item(0).row().data['id'];
    
     data={"tdoc":tdoc,"id":id,"from":controller+"_"+action}
     
    window.open("/telechargement/index/tdoc/"+tdoc+"/id/"+id+"/from/"+controller,"_blank");

    //scroll 
    window.scrollTo(0,0);
    return false;
})

     // trig event pour le menu gauche  a changer
    $(window).trigger("menuToChange",[controller,action]);   
</script>



