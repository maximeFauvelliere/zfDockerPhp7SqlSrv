<script>
    controller="<{$this->controller}>";
    action="<{$this->action}>";
    var pageSize=<{$this->pageSize}>;
    $("#titreNav").text("Documents");
    //undisplay menu left
     $(".navLeftMenu").css("display","none");
     $("#canvas_siloNav").removeClass();
     
     try{
        if($("#D_filter").css("display")=="block"){

                $("#D_filter").wijdialog("toggle");
        }
        
        $("#D_filter").wijdialog({disabled:true});
        
    }catch(error){}
</script>
<div id="wrapperContent">
<iframe id='ifr_download' name='bzDownload' src='' style="width:1px;border: none;height:1px;"></iframe>
    <div id="showDonwloadError" style="text-align:center;color:red;display:none;">
        Ce document n'est pas encore téléchargeable, son traitement est en cours.</br>Veuillez essayer ultérieurement.</p>
        <div style="text-align:center">
            <input type='button' value='fermer' onclick="$('#showDonwloadError').slideUp('slow')"/>
        </div>
    </div>
<div class="grilles" style="margin-left: 0px!important">
    
<div class="table" id="wrapperMessagerie2">
    <div class="action">
        <span style="text-align: left">
          <{if $this->selectList}>
            <select id="selectType">
                <option value="tout">Tout</option>
                <{foreach $selectList as $value}>
                    <option value="<{$value@key}>"><{$value}></option>
                <{/foreach}>
            </select>
           <{/if}>
            
        </span>
            <img id="btDownload" class="delLot delMessage" src="/styles/img/download.png" alt="télécharger"/>
    </div>
     <table class="grid" id="gridDoc"></table>
</div>
</div>
</div>



<script>
    // override makeDataGrid appeller par eventhashchange
    function makeDataGrid(){};
    // show silo nav if hidden
    $("#canvas_siloNav").css("display","block");
<{if isset($this->documents)}> 
   
    var documents=(<{$this->documents}>)?<{$this->documents}>:null;

//if convertion en tab    
    if(!isArray(documents) && documents){
      
          documents=convertToArray(documents.documents.document);
    }
<{/if}>

var gridDoc;
         
var reader= new wijarrayreader(
    [{name:'path',mapping:function(item){return item.path}},
    {name:'Type',mapping:function(item){return item.type}},
    {name:'Objet',mapping:function(item){return item.objet}},
    {name:"N°",mapping:function(item){return item.num}},
    {name:"Date",mapping:function(item){return item.date}} 
]);



//click download
$("#btDownload").click(function(){
     _gaq.push (['_trackEvent',"telechargement","documents",'telechargement de documents']);
     var selected = $("#gridDoc").wijgrid("selection").selectedCells();
     var path=selected.item(0).row().data['path'];
    
     //location.href="/telechargement/directdownload/path/"+path;
     window.open("/telechargement/directdownload/path/"+path,"_blank");

     //$("#ifr_download").attr("src","/telechargement/directdownload/path/"+path);
})


 // array
function makeGrid(documents){
    
    //if(!documents || !documents.document) { a voir pourquoi documents.document
    if(!documents) {
            $("#gridDoc").append("<h2>Vous n'avez pas de documents à afficher.</h2>");
            $(".action").css("display","none");
            return;
    }
    
     gridDoc= $("#gridDoc").wijgrid({
                //showFilter : true,
                culture:"fr-FR",
                allowSorting: true,
                allowPaging: true,
                pageSize: pageSize,
                pagerSettings: { mode: "numericFirstLast", position: "bottom"},/**todo image fleche**/
                data: new wijdatasource({
                    reader:reader,
                    data:documents,
                    loaded:function(data){
                        $("#suTitreNav").text("");
                        $("#titreNav").text("Documents");
                    }
                }),
                columns:[{visible:false}],
                selectionMode: "singleRow"
     }); 
    
    }


</script>

<script>

$("#selectType").change(function(e){

//ensure call the ajax datagrid source at each time.

    var mytab=new Array();
    var selectedList=$("#selectType option:selected").attr("value");
    
    // tout afficher
    if(selectedList=="tout"){
        $("#gridDoc").wijgrid("destroy");
        //re-create the grid
        makeGrid(documents);
        return;
    }
    //filtre
    $.each(documents,function(i,e){

        if(e['@attributes'].code==selectedList){
            mytab.push(e);
        }
       
    })

    $("#gridDoc").wijgrid("destroy");
    //re-create the grid
    makeGrid(mytab);
    
    

})



//delay for correctly size grid
setTimeout("makeGrid(documents)",50);
 

</script>

