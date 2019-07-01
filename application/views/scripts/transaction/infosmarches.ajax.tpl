<script>
    //clear function
    function makeDataGrid(){};
    controller="<{$this->controller}>";
    action="<{$this->action}>";
    $("#titreNav").html('Transaction');
    $("#suTitreNav").empty();
    $("#suTitreNav").html('Infos marchés');
    
     // collapse le filtre si besoin
    try{
        if($("#D_filter").css("display")=="block"){

                $("#D_filter").wijdialog("toggle");
        }
        
        $("#D_filter").wijdialog({disabled:true});
    }catch(error){}
    
    var pageSize=<{$this->pageSize}>;
</script> 

<{$this->render('nav.tpl')}>

<{if $this->message}><h1><{$this->message}></h1><{/if}>
<div class="content unselectable">
    <iframe id='ifr_download' name='bzDownload' src='' style="width:1px;border: none;height:1px;"></iframe>
    <div id="showDonwloadError" style="text-align:center;color:red;display:none;">
        Ce document n'est pas encore téléchargeable, son traitement est en cours.</br>Veuillez essayer ultérieurement.</p>
        <div style="text-align:center">
            <input type='button' value='fermer' onclick="$('#showDonwloadError').slideUp('slow')"/>
        </div>
    </div>
    

    <div id="eurodollar" class="table">
        
        <h3 class="titleGrid" style="font-weight: normal;position: relative;top: -10px;margin:0px">INFORMATIONS</h3>
        <{if $this->infosMarcheData}>
       
        <table id="convertion">
            <tbody>
                <tr>
                    <td class="wijgridth" style="padding:5px"><{$infosMarcheData->eurodollar->nom}> </td>
                    <td class="wijmo-wijgrid-row" style="padding:5px"><{$infosMarcheData->eurodollar->valeur}></td>
                    
                </tr>
                <tr>
                    <td class="wijgridth" style="padding:5px"><{$infosMarcheData->petrole->nom}> </td>
                    <td class="wijmo-wijgrid-row" style="padding:5px"><{$infosMarcheData->petrole->valeur}></td>
                    
                </tr>
            </tbody>
        </table>
        <{else}>
  
            Pas de données disponibles. Veuillez nous excuser pour ce désagrément.
  
        <{/if}>
                    
    </div>

    <div id="chicago" class="table">
         <h3 class="titleGrid" style="font-weight: normal;position: relative;top: -10px;margin:0px">COTATION CBOT CHICAGO</h3>
        <{if $this->infosMarcheData}>
         <table style="border:2px">
            <thead>
                
                    <th>Echéance</th>
                    <th>Cloture cts/Bu</th>
                    <th>Variation</th>
               
            </thead>
            <tbody>
                
                <{foreach from=$infosMarcheData->chicago->echeances item=item}>
                    <tr>
                        <td class="wijgridth" style="padding:5px"><{$item->echeance}></td>
                        <td class="wijmo-wijgrid-row" style="padding:5px"><{$item->valeur}></td>
                        <td class="ui-state-highlight" style="padding:5px"><{if $item->variation>0}>+ <{$item->variation}><{else}> <{$item->variation}><{/if}></td>
                    </tr>
                 <{/foreach}>  
            </tbody>
        </table>
         <{else}>
  
            Pas de données disponibles. Veuillez nous excuser pour ce désagrément.
  
        <{/if}>
    </div>

    <div id="matif" class="table" style="min-height:400px;width:868px">
        
    </div>
          
    <div class="table T_infosmarches" style="width:868px">
        <{if $this->infosMarcheData}>
        <h3 class="titleGrid" style="font-weight: normal;position: relative;top: -10px;margin:0px"><{$infosMarcheData->datemarches}></h3>
    <{foreach from=$infosMarcheData->accordion key=key item=item}>
        <div id="bzAccordion">
            <{foreach from=$item key=accordionTitle item=accordionDiv}>
                <{if $accordionTitle=="marches"}>
                    <{foreach from=$accordionDiv key=type item=typeDiv}>
                    
                        <h3 ><{$typeDiv.label}></h3>
                        <div>
                            <div class="bz_caroussel">
                                <ul>
                                    <li>
                                        <table style="width:100%;border-collapse:collapse">
                                            <tbody>
                                                <{foreach from=$typeDiv key=culture item=cultureDiv name="cult"}>

                                                <{if $culture=="culture"}>
                                                    <tr>
                                                        <td><{$cultureDiv.label}></td>
                                                        <td style="width:200px">

                                                            <div id="wijlinechart_<{$cultureDiv.nom}>" class="ui-widget ui-widget-content ui-corner-all bzChart" style="width: 200px; height: 200px; background:#EDECE6;;"></div>

                                                            <script>
                                                                setTimeout(function(){

                                                                    var xArray = [<{foreach from=$cultureDiv->graphe->x->pt key=pt item=ptDiv }>new Date("<{$ptDiv}>"),<{/foreach}>];

                                                                    var yArray = [<{foreach from=$cultureDiv->graphe->y->pt key=pt item=ptDiv }><{$ptDiv}>,<{/foreach}>];

                                                                $("#wijlinechart_<{$cultureDiv.nom}>").wijlinechart({
                                                                culture:"fr-FR",
                                                                animation:{enabled:false},
                                                                axis: {

                                                                    x:{
                                                                        annoFormatString:"dd-MM",


                                                                        /*text:"",
                                                                        annoMethod: "valueLabels",
                                                                        valueLabels: ["t","a","b","c","e","f"],*/
                                                                        labels:{
                                                                            style: {
                                                                            fill: "#000000",
                                                                            'font-size':"8pt"

                                                                            }

                                                                        } 


                                                                    },
                                                                    y: {

                                                                        //traits horizontaux
                                                                        gridMajor:{
                                                                            visible:true,
                                                                            style:{
                                                                                stroke:"#000000",
                                                                                "stroke-width": "0.5",
                                                                                "stroke-dasharray":"none"
                                                                            }

                                                                        },
                                                                        labels:{
                                                                            style: {
                                                                            fill: "#000000",
                                                                            'font-size':"9pt"
                                                                            }
                                                                        },


                                                                    }
                                                                },
                                                                showChartLabels: false,
                                                                header: {
                                                                                 text: ""
                                                                             },
                                                                hint: {
                                                                    content: function () {

                                                                        return Globalize.format((this.x),'dd/MM/y','fr')+ '\n' + this.y + '';
                                                                    },
                                                                    contentStyle: {
                                                                        "font-size": 10
                                                                    },
                                                                    offsetY: -10
                                                                },
                                                                legend: {
                                                                    visible: false
                                                                },
                                                                seriesList: [
                                                                        {
                                                                            label: "cultures",
                                                                            legendEntry: true,
                                                                            data: {
                                                                                x: xArray,
                                                                                y: yArray
                                                                            },
                                                                            markers: {
                                                                                visible: true,
                                                                                type: "circle"
                                                                            }
                                                                        }
                                                                    ]
                                                            })
                                                                },50);



                                                            </script>
                                                        </td>
                                                        <td style="border-right:none">
                                                            <h3><{$cultureDiv->titre}></h3>
                                                            <{$cultureDiv->des}>
                                                        </td>
                                                    </tr>
                                                <{/if}>
                                                <{/foreach}>
                                            </tbody>
                                        </table>
                                    </li>
                                    <li>
                                        <p>
                                            <{$typeDiv->detail}>
                                        </p>
                                    </li>
                                </ul>
                            </div>
                           <div  class="wrapperbt unselectable" ><div class="unselectable wrapperBtTxt"></div></div>
                        </div>
                    <{/foreach}>
                <{else}>
                    <{if !empty($accordionDiv.label)}>
                        <h3><{$accordionDiv.label}></h3>

                        <{if $accordionTitle=='filieres'}>
                            <div><{$accordionDiv->txt}></div>
                        <{else}>
                            <div>
                                <div class="action"><img class="download" src="/styles/img/download.png" alt="modifier" title="Télécharger"/></div>
                                <table id="bilanInfoMarche">
                                    <thead>
                                        <tr>
                                            <td>url</td>
                                            <th>Date</th>
                                            <th>Type</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <{foreach from=$accordionDiv->documents->doc key=doc item=docDiv}>
                                            <tr>
                                                <td>
                                                    <{$docDiv.url}>
                                                </td>
                                                <td>
                                                    <{$docDiv.date}>
                                                </td>
                                                <td>
                                                    <{$docDiv.nom}>
                                                </td>

                                            </tr>
                                        <{/foreach}>
                                    </tbody>
                                </table>
                            </div>
                        <{/if}>
                    <{/if}>

                <{/if}>
            <{/foreach}>
        </div>
    <{/foreach}>
    </div>
  <{else}>
  
  Pas de données disponibles. Veuillez nous excuser pour ce désagrément.
  
  <{/if}>
</div>

    



<style>
    /** css ici pour override **/
    .bz_caroussel{
        width:830px;
        overflow:hidden;
    }
   .bz_caroussel ul{
         display:table;
         width:1900px;
         padding:0!important;
         position:relative;
         background-color:#EDECE6;
        }
        
    .bz_caroussel li{
        float: left;
        width: 830px;
        list-style: none outside none;
        margin: 0;
        position: relative;
        
        display:table;
          
    }
    .bz_caroussel tr{
            width:100%;
            background-color:#EDECE6;
        }
    .bz_caroussel td{
        
        vertical-align:middle!important;
        /*text-align:center!important;*/
        border-bottom:solid 5px #ffffff;
        border-right:solid 3px #ffffff;
        
        }
        
      
    
    
</style>
<script>

   try{
       if($("#D_filter").css("display")=="block"){

            $("#D_filter").wijdialog("toggle");
        }

       $("#D_filter").wijdialog({disabled:true});
    }catch(error){

    };
   

 

   /*----CREATE ACCORDION----------------------------*/
   
   $("#bzAccordion").wijaccordion({
   
        requireOpenedPane: false,
        selectedIndexChanged: function (e){
            // en attente
            
            setSlideBtHeight(e);
        },
        create: function(e) {
            
            setSlideBtHeight(e);
            
        },
        activate:function(){
            //gesion hauteur bouton slide
            
        }

    });
    
    // set height for bt slide
    function setSlideBtHeight(e){
   
            var activePanel=$(e.target).find(".wijmo-wijaccordion-content-active")
            
            $.each(activePanel,function(i,e){
                var slideBt=$(e).find(".wrapperbt");

               //gesion hauteur bouton slide
                setTimeout(function()
                {
                    $(slideBt).css("height",$(e).css("height"));
                    var padding=(parseInt($(e).css("height"))/2);
                    $(slideBt).find("div").css("top",padding+"px");
                    
                },50);
                })
    }
   
    // hack pour click sur text dans wrapper
    $(".wrapperbt div").click(function(e){
        
        //console.log("parent",$(e.target).parent())
        $(e.target).parent().trigger("click");
    })
    
    $(".wrapperbt").click(function(e){
               // console.log("wraper bt click")
               // console.log("e.target",$(e.target).parent().parent().find(".bz_caroussel"))
                var bzCaroussel=$(e.target).parent().parent().find(".bz_caroussel");
                //console.log("bzCaroussel",bzCaroussel);
                //console.log("left",$(bzCaroussel).find("ul").css("left"))
                if($(bzCaroussel).find("ul").css("left")=="0px" || $(bzCaroussel).find("ul").css("left")=="auto"){
                    //console.log("left==0px")
                    //forward
                    //sens des fleches
                    
                    $(e.target).find('div').css("background-position","-30px center");
                    $(bzCaroussel).find("ul").animate({ left: "-830px" },1000,function(){

                    //change le texte du btwrapper
                    //$(e.target).find("div").empty();
                    //$(e.target).find("div").html("réduire</br>l'analyse");
        
                    });
                }else{
                    //backward
                    //console.log("backward");
                    //sens des fleches
                    $(e.target).find('div').css("background-position","0px center");
                    $(bzCaroussel).find("ul").animate({ left: "0px" },1000,function(){

                        //change le texte du btwrapper
                        
                        //$(e.target).find("div").empty();
                        //$(e.target).find("div").html("Pour aller</br>plus loin</br> dans l'analyse");
        
                    });
                }
                
                
            })
    
    
      //grid
            try{
                $("#bilanInfoMarche").wijgrid({
                    //rendered:actions,
                    selectionMode:"singleRow",
                    columns:[{visible:false}]
                });
            }catch(error){
            
            }  
    // click telechargement
$(".download").click(function(){

    var selected = $("#bilanInfoMarche").wijgrid("selection").selectedCells();

    idRow=selected.item(0).rowIndex(); 
    var path=$("#bilanInfoMarche").wijgrid("data")[idRow][0];
    $("#ifr_download").attr("src","/telechargement/directdownload/path/"+path);
 
    
    //location.href="/telechargement/directdownload/path/"+path;//+"/c/transaction/a/infosmarches";
   

})        
    
    // call matif first time 
    function callMatif(){
        
        $("#matif").empty();
        $("#matif").append('<div id="preload_matif" style="width:100%;height:50px;"><span>Actualisation en cours...</span></div>');
        
        $.ajax({
            url:"/transaction/matif/format/html",
            success:function(data){
                $("#preload_matif").remove();
                $("#matif").append(data);
            }
        })
    }
    
    callMatif();
    
    

    // trig event pour le menu gauche  a changer
    $(window).trigger("menuToChange",[controller,action]);      
</script>