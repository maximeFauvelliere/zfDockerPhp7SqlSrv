<script>
     // override makeDataGrid appeller par eventhashchange
    function makeDataGrid(){};
    
    var pageSize=<{$this->pageSize}>;
    //undisplay menu left
     $(".navLeftMenu").css("display","none");
     $("#canvas_siloNav").removeClass();
     
      // collapse le filtre si besoin
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
<input type="button" id="wrapperSendMail" value="Nous écrire"/>





<div id="wrapperSendcontent" style="display:none">
     <div id="pjointe"></div>
     <img id="pjLoader" src="../images/preloader.gif" alt="chargement en cour"/>
     <div id="formSelect">
         <form id="fileUpload" name="formUpload" encoding="multipart/form-data" method="post" enctype="multipart/form-data" target="uploadFrame" action="/push/fileupload/">
             <input type="hidden"  MAX_FILE_SIZE="100000"/>
             <input id="btSelect" type="file" name="bzUpload"/>
             <input type="submit" id="btEnvoyer"/>
         </form>
     </div>
    <table>
        <tbody>
            <tr id="sendSelect">
                <td>Ecrire à </td>
                <td>
                    <select>
                      <{section name=dest loop=$destinataires}>
                            <option value="<{$destinataires[dest].mail}>"><{$destinataires[dest].nom}></option>
                      <{/section}>
                    </select> 
                </td>
                <td id="ProgressUP">
                    <div style="width:100%;text-align: right;">
                    </div>
                </td>
            </tr>
            <tr>
                <label>Sujet : </label><input id="subject" type="text"></td>
            </tr>
            <tr id="sendcontent">
                <td colspan="3">
                    <textarea id="txtSend" rows="12" cols="60"> 
                        Entrez votre texte ici
                    </textarea>
                
                </td>
            </tr>
        </tbody>
    </table>
    <div class="ligneButton">
         <input id="btSend" type="button" value="Envoyer"/>
    </div>
   
</div>

<div class="grilles" style="margin-left: 0px!important">
    
<div class="table" id="wrapperMessagerie">
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
            <img class="delLot delMessage" src="/styles/img/ico_del.png" alt="supprimer"/>
    </div>
     <table class="grid" id="gridMessagerie"></table>
</div>
</div>
<div id="messageriecontent">
</div>
</div>

<script>

//focus and select text area 
$("#txtSend").focus(function(evt){
    $(this)[0].select();
})

//$("#selectType").change(function(){});

</script>


<script>
    // show silo nav if hidden
    $("#canvas_siloNav").css("display","block");

var messages=(<{$this->result}>)?<{$this->result}>:null;
messages=messages.notifications.notification.message;
//console.log("message",messages);

//if convertion en tab    
    if(!isArray(messages) && messages){
    
          messages=convertToArray(messages);
    }

var gridMessage;
         
var reader= new wijarrayreader(
    [{name:'id',mapping:function(item){return item['@attributes']['id']}},
    {name:"Etat",mapping:function(item){
        if(!parseInt(item['@attributes']['lu'])){
            return "<div class='lu'style='float:left' ></div><span style='padding-left:18px;font-weight:bold;font-size:10pt;'>non lu</span>";
        }
        
        return "<span style='padding-left:34px;font-weight:bold;font-size:10pt;'>lu</span>";
        }
    },
    {name:'type',mapping:function(item){return item['@attributes']['type']}},
    {name:'objet',mapping:function(item){return item['@attributes']['nom']}},
    {name:"pj",mapping:function(item){
                if(item['@attributes']['pjointe']!=""){
                       return "<div id='btgetpj'class='cursor' style='width:100%;height:100%;text-align:center' p='"+item['@attributes']['pjointe']+"'><div class='pjointe' style='margin:auto;' id='pj2'></div></div>";
                    }
                    return;
                }
                
    },
    {name:"date",mapping:function(item){return item['@attributes']['date']}} 
]);

//message change
// pour eviter double appel base sur ensureGontrole grid
var IdTab=new Array();

function messageChanged(evt){
    //
    setClick()
    //update notifications
    checkNotifications();

     var selection=$("#gridMessagerie").wijgrid("selection");
     var selected = selection.selectedCells();

     if(selected.indexOf()<=0) return;
     
     
    
      
     var pageIndex=$("#gridMessagerie").wijgrid('option','pageIndex');
     var idRow=selected.item(0).rowIndex();
     idRow=parseInt((pageSize*pageIndex)+idRow);
     //var idRow=selected.item(0).rowIndex();
     var dataGrid=$("#gridMessagerie").wijgrid("data");
     
 
     //var idMessage=selected.item(0).value().toString();
      var idMessage=dataGrid[selected.item(1).rowIndex()+(pageIndex*pageSize)]['id'];
     
     if($(selected.item(0).value()).hasClass("lu")){
        // change state 
        dataGrid[selected.item(0).rowIndex()+(pageIndex*pageSize)]["Etat"]="<span style='padding-left:34px;font-weight:bold;font-size:10pt;'>lu</span>";
        //reset
        $("#gridMessagerie").wijgrid("ensureControl", true);
        
        $(selected.item(0).container()).parent().parent().css("color","#614A41");
        //set notread
        setNotRead();
       
     }
     
     //load content

     $("#messageriecontent").html(messages[idRow]["contenu"]);
     
      /*
    *controle de la boucle avec ensure controle lorsque message non lu
    *evite un double appel a la base
    */
    if($.inArray(idMessage, IdTab)!=-1) return false;
    IdTab.push(idMessage);
    //set message read by ps
    $.ajax({
        url:"/push/messageread/format/html",
        data:{"idMessage":idMessage},
        succes:function(){checkNotifications()}
    })

}

function indexChange(evt){
addDelClick()
    
};


 // array
function makeMessagerie(messages){

    if(!messages) {
            $("#gridMessagerie").append("<h2>Vous n'avez pas de messages à afficher.</h2>");
            $("#messageriecontent").css("display","none");
            $(".action").css("display","none");
            ;return
    }
    
     gridMessage= $("#gridMessagerie").wijgrid({
                //showFilter : true,
                columns: [{visible:false},{},{},
                          {},{},{}],
                allowSorting: true,
                allowPaging: true,
                pageSize: pageSize,
                pagerSettings: { mode: "numericFirstLast", position: "bottom"},/**todo image fleche**/
                data: new wijdatasource({
                    reader:reader,
                    data:messages,
                    loaded:function(data){
                        $("#suTitreNav").text("");
                        $("#titreNav").text("Messagerie");
                    }
                }),
                selectionMode: "singleRow",
                selectionChanged: messageChanged
               
                //pageIndexChanged:indexChange
                
     
     }); 
     
     
     
     //$("#gridMessagerie").data("wijgrid").options.filterOperatorsListShowing=['messages'];
    }


//addClick to trash
        $(".delMessage").click(function(evt){
            
            var selection=$("#gridMessagerie").wijgrid("selection");
            var selected = selection.selectedCells();

            var dataGrid=$("#gridMessagerie").wijgrid("data");
            
            var pageIndex=$("#gridMessagerie").wijgrid('option','pageIndex');
            var idRow=selected.item(0).rowIndex();
            idRow=parseInt((pageSize*pageIndex)+idRow);
            var messageId=dataGrid[selected.item(1).rowIndex()+(pageIndex*pageSize)]['id'];
            
            $.ajax({
                url:"/push/messagedelete/format/json",
                data:{"idMessage":messageId},
                success:function(data){
                    //if(!data) return;
                    //deleted row
                    $.each(dataGrid,function(i,e){
                        
                        if(!e){return;}
                        
                        if(messageId==e.id){
                            dataGrid.splice(i,1);
                            //re paint grid
                            $("#gridMessagerie").wijgrid("ensureControl", true);

                        }
                    })
                    
                    checkNotifications();
                }
            })
        })

// add color on not read messages
function setNotRead(){
    $(".lu").parent().parent().parent().css("color","#75C058");
}
//exec
setNotRead();

</script>

<script>
// show form mail
$("#wrapperSendMail").click(function(){
    $("#wrapperSendcontent").slideToggle('slow');
})

$("#pjLoader").bind("uploadEnd",function(){

    $("#pjLoader").css("display","none");
    $("#btSend").attr("disabled",false);
    $("#ProgressUP div").html("Chargement pièce jointe terminé.");
    pjUpload=true;
    
})

var pjUpload=false;
//select file upload
$("#pjointe").click(function(e){
        //$(e.target).css("display","none");
        if(pjUpload) {
            alert("Une seule pièce jointe peut être envoyée par email.")
            return false;
        }
        $("#btSelect").trigger("click");

})

$("#btSelect").on("cancel",function(e){

    alert("cancel");
});

$("#btSelect").change(function(e){

    $("#pjLoader").css("display","block");
    $("#ProgressUP div").html("Envois pièce jointe ...");
    $("#btSend").attr("disabled","disabled");
    $("#btEnvoyer").trigger("click");
    
})
//------------fin upload-----------------//


//send mail
$("#btSend").click(function(){

    var txt=escape($("#txtSend").val());
    var a=$("#sendSelect option:selected").val();
    var subject=escape($("#subject").val());
   
    var data={"a":a,"subject":subject,"txt":txt};
    $.ajax({
        url:"/push/sendmail/format/json",
        data:data,
        type:"POST",
        success:function(data){
           
            data=JSON.parse(data);
            if(data.error==0){
                alert(data.msg);
            }else{

                alert(data.msg);
            }
            
            $("#wrapperSendcontent").slideToggle("slow");
            
        },
        error:function(a,b,c){
            /*console.log(a);
            console.log(b);
            console.log(c);*/
        }

    })


});


$("#selectType").change(function(e){

//------------test data grid--------------------------
//ensure call the ajax datagrid source at each time.

    var mytab=new Array();
    var selectedList=$("#selectType option:selected").attr("value");
    // tout afficher
    if(selectedList=="tout"){
        
        //re-create the grid
        try{
            $("#gridMessagerie").wijgrid("destroy");
        }catch(e){
    
        }
        makeMessagerie(messages);
        return false;
    }
    //filtre
    $.each(messages,function(i,e){

        if(e['@attributes'].type==selectedList){
            mytab.push(e);
        }

    })
    
    try{
        $("#gridMessagerie").wijgrid("destroy");
    }catch(e){
    
    }
    
    //re-create the grid
    makeMessagerie(mytab);
    setNotRead();
    

})

function setClick(){

$("#btgetpj").click(function(){
   //return false;
    var path=$("#btgetpj").attr("p");
    $("#ifr_download").attr("src","/telechargement/directdownload/path/"+path);
 
    //location.href="/telechargement/directdownload/path/"+path;//+"/c/transaction/a/infosmarches";

})

}







//delay for correctly size grid
setTimeout("makeMessagerie(messages)",50);
 

</script>

