<script>
     // override makeDataGrid appeller par eventhashchange
    function makeDataGrid(){};

    controller="<{$this->controller}>";
    action="<{$this->action}>";
    
    //undisplay menu left
    $(".navLeftMenu").css("display","none");
    $("#canvas_siloNav").removeClass();
     
    // collapse le filtre si besoin
     // collapse le filtre si besoin
    try{
        if($("#D_filter").css("display")=="block"){

                $("#D_filter").wijdialog("toggle");
        }
        
        $("#D_filter").wijdialog({disabled:true});
    }catch(error){}
    //change title nav
    $("#titreNav").text("Compte");
    $("#suTitreNav").text("");
    pageSize="<{$this->pageSize}>";
    
    var data=<{$this->data}>;

</script>

<div class="alertes" style="display:none"><p></p></div>
<div id="P_identifiant" >
    <span>votre identifiant : </span><input type="text" id="login" style="display:none" disabled="disabled"><{$this->userEmail}></input>
    <div><input type="button" id="btModPass" value="Modifiez votre mot de passe"/></div>
</div>
<div class="grilles" style="margin-left: 0px">
   
    <h3>Structures</h3>
    <div  id="wrapperStruct" class="table">
        <table class="grid" id="gridStruct"></table>
    </div>
     <h3>Adresses d'Executions</h3>
    <div class="table" id="wrapperExe">
        <table class="grid" id="gridExec"></table>
    </div>
    
</div>
    


<script>
    var gridExec;
         
var reader2= new wijarrayreader(
    [{name:'id',mapping:function(item){return item.idexec}},
    {name:"nom",mapping:function(item){return item.nom}},
    {name:'Addr1',mapping:function(item){return item.addr}},
    {name:'Addr2',mapping:function(item){return item.addr2}},
    {name:'Cp',mapping:function(item){return item.cp}},
    {name:'Ville',mapping:function(item){return item.ville}}
]);

 var gridStru;
         
var reader1= new wijarrayreader(
    [{name:'id',mapping:function(item){return item.idstr}},
    {name:"Titre",mapping:function(item){return item.titre}},
    {name:"Nom",mapping:function(item){return item.nom}},
    {name:'Siret',mapping:function(item){return item.siret}},
    {name:'TVA',mapping:function(item){return item.tva}},
    {name:"Type TVA",mapping:function(item){return item.typetva}},
    {name:"Coord. bancaires",mapping:function(item){return item.banque}}
]);

 // grid
function makeExecution(){

    var selected = $("#gridStruct").wijgrid("selection").selectedCells();
    //var idRow=selected.item(0).rowIndex();
    var idRow=(pageSize*$("#gridStruct").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();
 
    var struct=data.compte.structure
    
     if(!isArray(struct)){

        struct=convertToArray(struct);
    }
    
    var exec=struct[idRow].execution;
       
    if(!isArray(exec)){

        exec=convertToArray(exec);
    }
 

     gridExec= $("#gridExec").wijgrid({
                allowSorting: true,
                allowPaging: true,
                pageSize: pageSize,
                data: new wijdatasource({
                    reader:reader2,
                    data:exec
                }),
                selectionMode: "none",
                columns:[{visible:false}]
     
     }); 
     
    }





function makeStructure(){
    
     var struct=data.compte.structure
    
     if(!isArray(struct)){

        struct=convertToArray(struct);
    }
     gridStru= $("#gridStruct").wijgrid({
                allowSorting: true,
                allowPaging: true,
                pageSize: pageSize,
                data: new wijdatasource({
                    reader:reader1,
                    data:struct
                }),
                 selectionMode: "singlerow",
                 selectionChanged: makeExecution,
                 columns:[{visible:false}]
     }); 
     
    }

    
</script> 

<script>
    //show unshow modif pass
    $("#btModPass").click(function(){
        //declenche envois email pour changement.
        $.ajax({
            url:"/compte/changepwd/format/html",
            data:" a voir",
            type:"POST",
            success:function(data){
                $(".alertes p").text(data);
                $(".alertes").slideDown("slow",function(){
                    $(".alertes").delay(4000).slideUp("slow");
                });
                
                $.cookie("pwdLost", "true", { expires: 365 * 10, path: '/' });

            }
        })
    })
    


function myTimmer(){
makeStructure(); 
//makeExecution(); 
}

setTimeout(myTimmer,50);


</script>





 




