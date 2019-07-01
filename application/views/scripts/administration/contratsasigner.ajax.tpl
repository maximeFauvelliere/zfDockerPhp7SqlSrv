<script>
    controller="<{$this->controller}>";
    action="<{$this->action}>";
    var pageSize="<{$this->pageSize}>";
    $("#titreNav").html('Administration');
    $("#suTitreNav").empty();
    $("#suTitreNav").html("Contrats à signer");
    $(".navLeftMenu").css("display","block");
    try{
        $("#D_filter").wijdialog({disabled: true});
    }catch(error){}
    
</script>

<div id="wrapper_uploadFrame">
    <iframe id="uploadFrame" frameborder="0" name="uploadFrame" style="height: 50px;width:100%">
    </iframe>

</div>
<div id="D_uploadCT" class="trash" style="display:none">
     <img id="pjLoader" src="../images/preloader.gif" alt="chargement en cour"/>
     <div>
         <form id="fileUpload" methode="post" name="formUpload" encoding="multipart/form-data" method="post" enctype="multipart/form-data" target="uploadFrame" action="/administration/fileupload/">
             <input type="hidden"  MAX_FILE_SIZE="100000"/>
             <div id="nCt">
                 <h4>Vous souhaitez envoyer un contrat signé manuellement.</h4>
                 <h4>Rappel : Le numéro du contrat à envoyer est le :</h4>
                 <input id="F_idct" type="hidden" value="" name="idct"/>
                 <h4 id="numct" style="text-align: center;width: 100%">125633655</h4>
             </div>
             
             <div style="text-align:center;width:100%">
                <input type="button"  id="btWrapperFile" value="Sélectionner votre contrat"/>
             </div>
             <br/>
             <div>
                 * Formats acceptés : PDF, JPEG.
             </div>
             <div id="wrapperValidation" style="text-align:center;display: none">
                 <h3 id="ctName" style="width:100%;text-align: center;display:none"></h3>
                <input type="submit" value="envoyer" id="envoyer" name="valider"/>
                <button type="button" id="annuler2" name="annuler">annuler</button>
            </div>
             <div id="btFile" style="width:0px;overflow: hidden">
                <input id="btSelect2" type="file" name="bzUpload"/>
             </div>
         </form>
     </div>
</div>
<div class="grilles grilles_contrats">
    <div class="ListTab table">
        <div class="action"><a id="btSend" href="#" style="float:right"><img class="delLot"  src="/styles/img/upload.png" alt="Envoyer" title="Envoyer"/></a><img class="modLot" src="/styles/img/ico_signer.png" alt="Signer" title="Signer" /><a href="#"><img class="delLot" id="btDownload" src="/styles/img/download.png" alt="télécharger" title="Télécharger"/></a></div>
        <table class="table_contrats " id="contrats"></table>

    </div>
</div>
<div id="dialog" class="trash" style="display:none">
    <form id="ctForm">
        <div style="width:100%;text-align: center">
                 <h4>Vous souhaitez signer numériquement</h4>
                 <h4>le contrat numéro :</h4>
                 <h4 id="numct2" style="text-align: center;width: 100%"></h4>
        </div>
        <label for="pwd">Mot de passe</label>
        <input type="password" id="pwd" name="pwd" style="width:150px;"/>
        <br/>
        <br/>
        <input id="idCt" type="hidden" value="" name="idCt"/>
        <input id="path" type="hidden" value="" name="path"/>
        <input id="ctSign" type="hidden" value="" name="ctSign"/>
        <br/>
        <br/>
        <div style="text-align:center">
            <input type="submit" value="valider" id="valider" name="valider"/>
            <button type="button" id="annuler" name="annuler">annuler</button>
        </div>
    </form>

</div>

<{if $this->data}>
 
 <script> 
 var contrats=<{$this->data}>;
 
 var contrat=contrats.contrats.contrat;
 if(!isArray(contrat)){

    contrat=convertToArray(contrat);
 }
 
 //init
 // show silo nav if hidden
    $("#canvas_siloNav").css("display","block");
    // collapse le filtre si besoin
    try{
        if($("#D_filter").css("display")=="block"){
            $("#D_filter").wijdialog("toggle");
            $("#D_filter").wijdialog({disabled:true});
        }
    }catch(error){}

 //creation de la grille
 var grid1;
//reader
var reader1 = new wijarrayreader([
                
                {name:"is_waiting",mapping:function(item){return item['etat']['@attributes']['etat']}},
                {name:'N°ct',mapping:"idct"},
                {name:'Date Contractualisation',mapping:"date"},
                {name:'Quantité',mapping:"qte"},
                {name:"Nb Hectares",mapping:"nbha"},
                {name:"Prix",mapping:"prix"},
                {name:"Date Paiement",mapping:"dp"},
                {name:"Etat",mapping:function(item){return item['etat']['@text']}}
                
]);

function makeGrid(){

    $("#contrats").wijgrid({
                allowSorting:true,
                allowPaging:true,
                culture:"fr-FR",
                pageSize:pageSize,
                cellStyleFormatter: function (args){bzCenter(args)},
                data:new wijdatasource({
                    reader:reader1,
                    data:contrat}),
               columns:[
                       {visible:false},
                       {},
                       {},
                       {dataType:"number",dataFormatString: "n3"},
                       {dataType:"number",dataFormatString: "n3"},
                       {dataType:"number",dataFormatString: "n2"},
                       ],
               selectionMode: "singleRow"
            });

     // affect click
     $(".modLot").click(function(){
                
                if(!$("#contrats").wijgrid("data").length) return false;
                var selected = $("#contrats").wijgrid("selection").selectedCells();
                var idCt=selected.item(0).value();
                
                var idRow=selected.item(0).rowIndex();
                var path=contrat[idRow]['@attributes']['path'];
                var ctSign=contrat[idRow]['@attributes']['ctsign'];
    
                
                //etat du contrat si en cour pas de signature
                var etat=selected.item(0).row().data['is_waiting'];
                if(parseInt(etat)){
                    alert("Contrat en cours de validation.");
                    return false;
                }
                //initialize dialog
                $("#dialog").wijdialog({
                    autoOpen:false,
                    modal: true,
                    captionButtons:{pin: { visible: false },
                    refresh: { visible: false },
                    toggle: { visible: false },
                    minimize: { visible: false },
                    maximize: { visible: false },
                    close: { visible: false } },
                    title:"Signature contrat en ligne."
                });
        
                
                $("#dialog").wijdialog({ 
                    open: function (e) {$('#pwd').attr('value','');$('#pwd').focus() } 
                });

                //affect dialog var
                $("#idCt").val(idCt);
                $("#numct2").empty();
                $("#numct2").html(idCt);
                
                $("#path").val(path);
                $("#ctSign").val(ctSign);
                
                //ouverture du dialog   
                $("#dialog").wijdialog('open');
                
    })
    
    //validation formulaire
       $('#ctForm').submit(function(e){
            $("#valider").attr("disabled","disabled");
        //validator
         if(!$('#pwd').val().length){
             
                alert("Vous devez entrer votre mot de passe pour signer votre contrat.");
                     $('#pwd').focus();
                     $("#valider").removeAttr("disabled");
                 return false;  
             }

        //envois du formulaire  
        $.post('/administration/ctvalidation/format/json',
                $("#ctForm").serialize(),
                function(data) {
                     //traitement du retour
                      switch(data[0].erreur){
                                //succes contrat validé
                                case "0":
                                    alert(data[0].msgerreur);
                                    $("#dialog").wijdialog('close');
                                    $("#dialog").wijdialog('destroy');
                                    
                                    var selected = $("#contrats").wijgrid("selection").selectedCells();
                                    var idRow=selected.item(0).row();
                                    
                                    // mise a jour des data de la grille
                                    $("#contrats").wijgrid("data").splice(idRow,1);
                                    //mise a jour des data dans la liste contrat
                                    contrat.splice(idRow,1);
                                    
                                    // si plus de contrats a signer
                                    if(!$("#contrats").wijgrid("data").length){
                                        alert("Vous n'avez plus de contrats à signer.")
                                    }
                                    $("#contrats").wijgrid("ensureControl", true);
                                     $("#valider").removeAttr("disabled");
                                    /*console.log("data wijgrid",$("#contrats").wijgrid("data"));
                                    console.log("contrat slice",contrat);*/
                                    return;
                                break;
                                //gestion des erreurs    
                                case "1":
                                    alert('Une erreur  est survenue.');
                                    $("#dialog").wijdialog('close');
                                    $("#valider").removeAttr("disabled");
                                    return;
                                break;
                                case "2":
                                    alert(data[0].msgerreur);
                                    $("#dialog").wijdialog('close');
                                    $("#valider").removeAttr("disabled");
                                    return;
                                break;
                                case "3":
                                    alert(data[0].msgerreur);
                                    $("#dialog").wijdialog('close');
                                    $("#valider").removeAttr("disabled");
                                    return;
                                break;    

                          }       
                });
                
                // stop form submit 
                return false;
           
    })
    
     //annulation formulaire
    $('#annuler').click(function(e){
        $("#dialog").wijdialog('close');
        //$("#dialog").wijdialog('destroy');
    });
    //annulation dialog envois ct
    $('#annuler2').click(function(e){
        $("#D_uploadCT").wijdialog('close');
        //$("#dialog").wijdialog('destroy');
    });
   
}


//upload de contrat
$("#btWrapperFile").click(function(e){
    
    $("#btSelect2").trigger("click");
    
})

//event change select
$("#btSelect2").change(function(e){
    $("#ctName").html($(e.target).val());
    $("#ctName").css("display","block");
    $("#wrapperValidation").css("display","block");
    $("#btWrapperFile").css("display","none");
});

$("#btSend").click(function(e){

    if(!$("#contrats").wijgrid("data").length) return false;
    
    var selected = $("#contrats").wijgrid("selection").selectedCells();
    var idCt=selected.item(0).value();
    
    //etat du contrat si en cour pas de signature
    var etat=selected.item(0).row().data['is_waiting'];
   
    if(parseInt(etat)){
        alert("Contrat en cours de validation.");
        return false;
    }

    $("#btWrapperFile").css("display","inline");
    $("#wrapperValidation").css("display","none");
   
    
    //empty contratName in h
    $("#ctName").empty();
    $("#numct").html(idCt);
    $("#F_idct").val(idCt);
    
    $("#D_uploadCT").wijdialog("open");

    return false;
})
//------------------------------------
$("#btDownload").click(function(){
     _gaq.push (['_trackEvent',"telechargement","contratasigner",'telechargement de documents']);
     var selected = $("#contrats").wijgrid("selection").selectedCells();
     var idRow=(pageSize* $("#contrats").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();
     
     var path=contrat[idRow]["@attributes"]['path'];
     //console.log("contrat",contrat);
    //console.log("path",contrat[idRow]["@attributes"]['path']);
     //location.href="/telechargement/directdownload/path/"+path;
     window.open("/telechargement/directdownload/ctsign/1/path/"+path,"_blank");
     return false;
})
//------------------------

$("#fileUpload").on("submit",function(){

    $("#D_uploadCT").wijdialog('close');
})

$("#fileUpload").bind("uploadEnd",function(e,result){


if(result.result=="success"){
    alert("Votre contrat a été envoyé avec succès et pris en compte par nos services.")
}else{
    alert("Une erreur est survenue.")
}

})

//delay pour construction grid
setTimeout(function(){
    makeGrid();
    $("#D_uploadCT").wijdialog({
                    autoOpen:false,
                    modal: true,
                    captionButtons:{
                        pin: { visible: false },
                        refresh: { visible: false },
                        toggle: { visible: false },
                        minimize: { visible: false },
                        maximize: { visible: false },
                        close: { visible: false }
                        },open:function(e){
                            var dialog=$(e.target);
                                if(!$(".sc-bt-dialog-close").length){
                                     $(e.target).parent().find(".ui-dialog-titlebar").append("<span class='sc-bt-dialog-close' style='cursor:pointer;position:absolute;right:5px;' ></div>");
                                            $(".sc-bt-dialog-close").bind("click",function(e){
                                                dialog.wijdialog('close');
                                            })
                                 }
                        },
                    title:"Envoi contrat signé manuellement.",
                    width:380,
                });
},100)

// trig event pour le menu gauche  a changer
    $(window).trigger("menuToChange",[controller,action]); 

 </script>

<{/if}>
