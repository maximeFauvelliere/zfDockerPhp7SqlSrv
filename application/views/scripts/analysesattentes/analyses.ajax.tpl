<div class="content">
    
    <div class="grilles analysesAttente">
        <div class="table table1" style="max-width: 640px">
            <div class="titleGrid">ANALYSES EN ATTENTE</div>
            <table class="prospection" id="analyses">
            </table>
        </div>
        
            <div class="table table2" style=" max-width: 640px" >
                <div class="titleGrid">QUALITES</div>
                <table class="prospection" id="qualites">

                </table>
            </div>
            <div class="table table3" style=" max-width: 640px" >
                <div class="titleGrid">COMMENTAIRE</div>
                <div id="com_analyse" style="display: none;">
                    
                </div>
            </div>
       
    </div>
</div>

<div id="affectLots" class="trash" style="display:none">
    <div id="titre" style="display:inline-block;width:100%;text-align:center;font-weight: bold"></div><br/>
      <div style="float:left">
            <form name="affectLots">
                <table id="lesLots" class="wijmo-wijgrid-root wijmo-wijgrid-table" style="text-align:center;width:550px;">
                    <thead>
                        <th class="wijgridth "></th>
                        <th class="wijgridth ">Camp</th>
                        <th class="wijgridth ">Nom</th>
                        <th class="wijgridth ">Culture</th>
                        <th class="wijgridth ">Structure</th>
                        <th class="wijgridth ">Type</th>
                        
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </form>
                <table style="width:580px">
                    <tr>
                        <td style="text-align: center">
                            <input id="btCloseAffLot" style="margin:auto;text-align: center" type="button" value="Valider" />
                        <td>
                    </tr>
                </table>
         </div>
   
</div>

<script>
    controller="analysesattentes";
    var grid1;
    var grid2;
    var pageSize=<{$this->pageSize}>;
    var analysesAttentes=<{$this->data}>;
    //console.log("analyses en attente", analysesAttentes);
    
    var reader1 = new wijarrayreader([
                {name:'idana',mapping:function(item){return item.id}},
                {name:'clecu',mapping:function(item){return item.clecu}},
                {name:'Camp',mapping:function(item){return item.camp}},
                {name:'Nom',mapping:function(item){return item.nom}},
                {name:'Culture',mapping:function(item){return item.cult}}, 
                {name:'Type',mapping:function(item){return item.type}}, 
                {name:'Affectation',mapping:function(item){return '<div style="z-index:-1;width:100%;text-align:center;"><input type="button" class="affect" value="affecter"/></div>'}},
    ]);  
    
    var reader2 =  new wijarrayreader([
                {name:'Critères',mapping:function(item){return item['@attributes']['code']}},
                {name:'Resultats',mapping:function(item){return item['@attributes']['value']}}   
       
    ]);  

    function onSelectionChanged1(){
        
        try{
            $("#qualites").wijgrid('destroy');
        }catch(e){
        
        }
        var selected = $("#analyses").wijgrid("selection").selectedCells();
        var idRow=(pageSize*$("#analyses").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();
        
        //commentaire
        var dataAna=analysesAttentes.analyses.analyse;
        if(!isArray(dataAna)){
            dataAna=convertToArray(dataAna);
        }
        //vide comm si com
        $("#com_analyse").html("");
        $("#com_analyse").css("display","none");
       if(dataAna[idRow].com){
            $("#com_analyse").html(dataAna[idRow].com);
           $("#com_analyse").css("display","block");
       }
        
        
        var qualites=analysesAttentes.analyses.analyse;
       
        if(!isArray(qualites)){
            qualites=convertToArray(qualites);
        }
        
        var critere=qualites[idRow].qualite.critere;
        
        if(!isArray(critere)){
            critere=convertToArray(critere);
        }
        
        grid2= $("#qualites").wijgrid({
            selectionMode:"none",
            data: new wijdatasource({
                reader:reader2,
                data:critere})
           
        }); 
        
    }
    
    var analyses = analysesAttentes.analyses.analyse;

    if(!isArray(analyses)){
       analyses=convertToArray(analyses);
    }
    

    function makegrid(){
        grid1= $("#analyses").wijgrid({
                allowSorting: true,
                allowPaging: true,
                pageSize: pageSize,
                data: new wijdatasource({
                    reader:reader1,
                    data:analyses}),
                columns: [{visible:false},{visible:false},{width:50},{width:190},{width:100},{width:150},{width:150}],
                ensureColumnsPxWidth: true,
                selectionMode: "singleRow",
                selectionChanged: onSelectionChanged1

            });  
    } 



    setTimeout(function(){
        makegrid();
        // click 
        $(".affect").click(function(e){
        
                setTimeout(function(){

                        var selected = $("#analyses").wijgrid("selection").selectedCells();
                        var idana=selected.item(0).row().data['idana'];
                        var clecu=selected.item(0).row().data['clecu'];

                        $.ajax({
                            url:"/analysesattentes/setanalyse/clecu/"+clecu+"/idana/"+idana+"/format/html/",
                            success:function(data){
                                data=JSON.parse(data);

                                $.each(data,function(i,e){
                                    var champs;
                                    $("#affectLots span").text("Analyse : "+e.nom);
                                    $("#titre").text("Analyse : "+e.nom);
                                    var idLot;
                                    if(!isArray(e.lot)){
                                        e.lot=convertToArray(e.lot);
                                    }
                                    
                                    // si aucun lot n'est affecté (anormal)
                                    if(e.lot.length <1){
                                        //fill tbody
                                        $("#lesLots tbody").html("<tr><td colspan=4 ><h4 style='padding-left:35px;color:red'>Il n'y a pas de lots disponibles pour cette analyse</h4></td></tr>");
                                        return false;
                                    }
                                    //les lots
                                    //index pour pair
                                    var _i=1;
                                    $.each(e.lot,function(b,c){
                                        
                                        // alternate style for grid
                                        if(_i % 2 == 0){
                                             champs+='<tr class="wijmo-wijgrid-row">';
                                        }else{
                                            champs+='<tr class="wijmo-wijgrid-alternatingrow">';
                                        }
                                        _i++;                                       
                                        $.each(c,function(u,a){
                        
                                            if(u!="id"){
                                                
                                                if(!a){
                                                   // console.log("a2",a);
                                                }
                                                champs+="<td>"+a+"</td>";
                                            }else{
                                                champs+='<td><input class="lotsAffecte" idgra="'+e.id+'" idlot="'+a+'" type="checkbox" name="selection"/></td>';
                                                
                                            }
                                        })
                                        
                                        champs+="</tr>";
                                    }) 
                                    
                                    // les qualités
                                    var criteres;
                                    if(!isArray(e.qualites.critere)){
                                        e.qualites.critere=convertToArray(e.qualites.critere);
                                    }
                                    $.each(e.qualites.critere,function(i,e){
                                        
                                        criteres+="<tr> <td>"+e['@attributes']['code']+"</td><td>"+e['@attributes']['value']+"</td> </tr>";
                                
                                    })
                                    

                                   //fill tbody
                                   $("#lesLots tbody").html(champs);
                                   //fill quality
                                   $("#desQualites tbody").html(criteres);
                                })
                                // create dialogue
                                $("#affectLots").wijdialog({
                                        autoOpen:true,
                                        modal: true,
                                        captionButtons:{
                                        pin: { visible: false },
                                        refresh: { visible: false },
                                        toggle: { visible: false },
                                        minimize: { visible: false },
                                        maximize: { visible: false },
                                        close: { visible: false} 
                                        },
                                        title:"Affecter lots",
                                        width:"600",
                                        maxHeight:"600",
                                        open:function(e){
                                            var dialog=$(e.target);
                                            if(!$(".sc-bt-dialog-close").length){
                                                 $(e.target).parent().find(".ui-dialog-titlebar").append("<span class='sc-bt-dialog-close' style='cursor:pointer;position:absolute;right:5px;' ></div>");
                                                        $(".sc-bt-dialog-close").bind("click",function(e){
                                                            dialog.wijdialog('close');
                                                        })
                                             }
                                        },
                                        close:function(){
                                            
                                            $("#affectLots").wijdialog("destroy");
                                            $("#lesLots tbody tr").remove();
                                            $("#desQualites tbody tr").remove();
                                            location.hash="/analysesattentes_analyses";
                                        },
                                        create:function(){
                                            $(".lotsAffecte").unbind("change");
                                            $(".lotsAffecte").bind("change",function(e){
                                                    var idlot=$(this).attr("idlot");
                                                    var idgra=$(this).attr("idgra");
                                                    var checked=$(this).attr("checked")?1:0;
                                                    
                                                    

                                                    $.ajax({
                                                        url:"/analysesattentes/affecteanalyse/idlot/"+idlot+"/idgra/"+idgra+"/checked/"+checked+"/format/json",
                                                        success:function(data){
                                                            /**
                                                            *@todo gerer retour erreur+success
                                                            */
                                                           
                                                            if(!parseInt(data.erreur)){
                                                                //alert(data.msgerreur);
                                                            }else{
                                                                alert("Une erreur s'est produite, votre analyse n'est peut être pas affectée.");
                                                            }
                                                        }
                                                        
                                                    })
                                            });
                                        }

                                    }); 



                            }
                        })
                        
                        },100);
        });
    },500);

    $("#btCloseAffLot").click(
        function(){
            $("#affectLots").wijdialog("close");
            location.hash="prospection_index";
        }
    )

</script>