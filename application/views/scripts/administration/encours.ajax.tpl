<!--affectation des data-->
<{if $this->data}>
 <script> 
    var adminData=<{$this->data}>
    var camp;
    controller="<{$this->controller}>";
    action="<{$this->action}>";
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
            <div class="titleGrid" style="float: left;position: relative;top: 12px;">LISTE DES FACTURES</div>
            <div class="action"><a href="/telechargement"><img class="delLot" id="btDownload" src="/styles/img/download.png" alt="télécharger" title="Télécharger" /></a></div>
            <table class="factures" id="lstFac" ></table>
        </div>
    </div>

    <div id="dialog"></div>
    </div>
<{$this->render('nav.tpl')}>
<script>
    var pageSize=<{$this->pageSize}>;
    // show silo nav if hidden
    $("#canvas_siloNav").css("display","block");
    //sub title
    $("#suTitreNav").text("En cours");

    //create gsilo [0] index de la cellule 
    createDSilo(siloData.cellules.cellule[1],"2_");

    //def variable
        var grid1;
        var grid2;


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
                    {name:'Date',mapping:function(item){return item['@attributes']['date']}},
                    {name:"Type",mapping:function(item){return item['@attributes']['type']}},
                    {name:'N°ct',mapping:function(item){return item['@attributes']['numct']}},
                    {name:"Quantité t",mapping:function(item){return item['@attributes']['qte']}},
                    {name:"Montant Net €",mapping:function(item){return item['@attributes']['mttnet']}}

    ]);


    function onSelectionChanged1(){


         try{
                $("#lstFac").wijgrid('destroy');
         }catch(error){


         }

     var selected = $("#factures").wijgrid("selection").selectedCells();
     //var idRow=selected.item(0).rowIndex();
     var idRow=(pageSize*$("#factures").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();
     factures=adminData[idRow].fact;

    if(!isArray(factures)){

    factures=convertToArray(factures);
    }

    try{    

    grid2= $("#lstFac").wijgrid({
        culture:"fr-FR",
        data:new wijdatasource({
        reader:reader2,
        data:factures
        }),
        cellStyleFormatter: function (args){bzCenter(args)},
        columns:[{visible:false},{visible:false},
                  {},
                  {},
                  {},
                  {},
                  {dataType:"number",dataFormatString: "n2"},
                  {dataType:"number",dataFormatString: "n2"}
                 ]
    });    
    }catch(error){
    alert("Une erreur s'est produite, rechargez la page.")
    }    



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
                    data:new wijdatasource({
                            reader:reader1,
                            data:adminData
                     }),
                    selectionMode: "singleRow",
                    selectionChanged: onSelectionChanged1
                }).wijgrid("setSize",640);


    }

       $("#btDownload").click(function(e){

        var selected = $("#lstFac").wijgrid("selection").selectedCells();
        
        var tdoc=selected.item(0).row().data['tdoc'];
        var id=selected.item(0).row().data['id'];
        
        //console.log("tdoc",tdoc);
        //console.log("id",id);
            window.open("/telechargement/index/tdoc/"+tdoc+"/id/"+id+"/from/"+controller,"_blank");
            window.scrollTo(0,0);
            return false;
    })

    // trig event pour le menu gauche  a changer
    $(window).trigger("menuToChange",[controller,action]);   
</script>

