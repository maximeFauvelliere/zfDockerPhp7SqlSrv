<script>
    
    $("#titreNav").html('Transaction');
    $("#suTitreNav").empty();
    $("#suTitreNav").html('Synthèse commerciale');
    
     // collapse le filtre si besoin
    try{
        if($("#D_filter").css("display")=="block"){

                $("#D_filter").wijdialog("toggle");
        }
        
        $("#D_filter").wijdialog({disabled:true});
    }catch(error){}
    //cache pour chargement données

    //clear function
    function makeDataGrid(){};
    controller="<{$this->controller}>";
    action="<{$this->action}>";
    var pageSize=<{$this->pageSize}>;
    
    
        
    if(!typeof(paintPies1)=='undefined'){
        paintPies1==null;
    }
    
    if(!typeof(paintPies2)=='undefined'){
	paintPies2==null;
    }
    
    if(!typeof(bubble)=='undefined'){
	bubble==null;
    }
    
</script>




<{if $this->message}><h1><{$this->message}></h1><{/if}>
<div class="content">
    
    <div class="analyseCom" style="width:868px">

        <h3  id="tittle_sc"class="" style="background-color:#83B81A!important">Synthèse commerciale
                <span id="context-help"><img src="/images/metier/info1.png"/></span>
        </h3>
        <div id="analyseComBzcarousel" class="bz_caroussel">
                                <ul id="listBzcar" style="margin-top:0px!important">
                                    <li>
                                        <table style="width:100%;border-collapse:collapse">
                                            <tbody>
                                                <tr id="tr_synthese">
                                                    <td colspan="2">
                                                        <div id="Acom_mask1">
                                                        <div id="wrapperPreloader" >
                                                               <h5>Chargement de vos données....</h5>
                                                               <img id="pjLoader_SC" alt="chargement en cour" src="/images/preloader_white.gif">
                                                        </div>
                                                        </div>
                                                       <{* <div id="wrapperNbCt">
                                                            <div id="pCT"><{$data->ctna}></div>
                                                            <div id="qtTxt" style="padding-left: 25px">Contrat(s) non affiché(s) en cours de validation.</div>
                                                        </div>*}>
                                                        <h5  style="">Evolution de vos contrats</h5>
                                                        <div class="ac_content">
                                                            <div id="synthese" style="overflow:hidden"></div>

                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr id="tr_pies" >
                                                    <td style="height:435px;vertical-align: top!important">
                                                        <h5  style="">Synthèse des engagements par culture</h5>
                                                        <div id="cultPie" class="ui-widget ui-widget-content ui-corner-all">
                                                        </div>
                                                    </td>
                                                    <td style="height:435px;vertical-align: top!important">
                                                        <h5  style="">Synthèse des engagements par structures et  par culture</h5>
                                                        <div id="structPie" class="ui-widget ui-widget-content ui-corner-all">
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <div id="bubble" style="width: 700px; height: 300px;"></div>
                                                      <{*  <div id="btDepotBubble" style="display:none">Dépot en date </br>du 11/04/13=256t</div>*}>
                                                        <div id="tableBubble">

                                                            <div id="table_detail">
                                                                <table class="prospection" id="detailBubble"></table>

                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </li>
                                    <li id="synthGlobal">
                                    </li>
                                </ul>
        </div>
        <div  class="wrapperbt unselectable" ><div class="unselectable wrapperBtTxt"></div>
        </div>
        </div>
                                                            
</div>
<div id="syntheseMask" style="width:100%;height:100%;position:absolute;top: 10px;background-color: white;z-index:9000">
  
    <div id="preloader" style="top:100px;left:38%;"></div>
    <div style="width:90%;height:90%;text-align: center;padding-top: 100px;">Chargement de votre synthèse ....</div>
</div>
<script>

    /**
    *
    *@todo sur toute les page ajax reinitialiser les variables a null pour garbage collector
    * important 
    */
   try{
       if($("#D_filter").css("display")=="block"){

            $("#D_filter").wijdialog("toggle");
        }

       $("#D_filter").wijdialog({disabled:true});
    }catch(error){
        
    }
   
   var selectedCamp=["2012","2013","2014","2015"];
 
   
    // hack pour click sur text dans wrapper
    $(".wrapperbt div").click(function(e){
        $(".wrapperbt").trigger("click");
    })
    
    $(".wrapperbt").click(function(e){

      
                var bzCaroussel=$(e.target).parent().parent().find(".bz_caroussel");
                if($(bzCaroussel).find("ul").css("left")=="0px"){
                    //Backward
                    //sens des fleches
                    $(e.target).find('div').css("background-position","-30px center");
                    $(bzCaroussel).find("ul").animate({ left: "-830px" },1000,function(){

                    //change le texte du btwrapper
                        //$(e.target).find("div").empty();
                        //$(e.target).find("div").html("graph");
                        
                        if($("#synthGlobal table").length>0) return false;
                        //load data tableau
                            $.ajax({
                                    url:"/transaction/analysecomsynthese/format/html/",
                                    success:function(data){

                                         $("#synthGlobal table").remove();
                                         $("#synthGlobal").append(data);


                                    },
                                    error:function(error){

                                    }
                                })
                   
                    });// fin animate
                }else{
                    //forward
                    //sens des fleches
                    $(e.target).find('div').css("background-position","0px center");
                    $(bzCaroussel).find("ul").animate({ left: "0px" },1000,function(){
                        
                        
        
                    });
                }
                
                
            })
    
    
      
          
setTimeout(function(){
  
        // synthese multiple charte
       $("#synthese").wijcompositechart({
                
                //create preféré a painted qui est appelé deux fois 
                create: function( event, ui ) {
                        $.ajax({
                            url:"/transaction/analysecomcultures/format/html/",
                            success:function(data){
                               
                                $("#main").append(data);
                                $("#Acom_mask1").css("display","none");
                                paintPies1();
                            },
                            error:function(error){
                            
                                alert("error"+error)
                            }
                
                        })
                     
                },
                culture:"fr-FR",
                axis: {
                    y: [{
                        textVisible:true,
                        autoMax:false,
                        autoMin:false,
                        min:parseInt(<{$data->axis->y.min}>),
                        max:parseInt(<{$data->axis->y.max}>)+<{$data->axis->y.max}>*0.25,
                        text: "<{$data->axis->y.label}>"
                       
                        },
                        //y2
                        {
                          textVisible:false,
                          autoMax:false,
                          autoMin:false,
                          min:parseInt(<{$data->axis->y.min}>),
                          max:parseInt(<{$data->axis->y.max}>)+<{$data->axis->y.max}>*0.25,
                          //traits horizontaux
                            gridMajor:{
                                visible:false

                            }
                           
                        }
                    ],
                    x:{
                        text: ""
                    }
                },
                stacked: false,
                hint: {
                    content: function (e) {

                        if(this.type=="column"){
           
                            return this.label+'\n'+"Prix moyen"+ '\n ' + this.data.pxmoy[this.index];
                        }
                        

                            return this.label + '\n ' + this.y+" t" ;
                        
                        
                        
                    }
                },
                header: {
                    text: ""
                },
                seriesList: [
                  <{foreach from=$data->serielist->bargraph->column item=column}>                
                    {
                    type: "column",
                    label: "<{$column.label}>",
                    legendEntry: true,
                    data: { 

                        x:[<{foreach from=$column->gdata->x->pt item=pt}>'<{$pt}>'<{if !$pt@last}>,<{/if}><{/foreach}>], 
                        y: [<{foreach from=$column->gdata->y->pt item=pt}>parseInt(<{$pt}>)<{if !$pt@last}>,<{/if}><{/foreach}>],
                        Lpxmoy:[<{foreach from=$column->gdata->y item=Lpxmoy}>'<{$Lpxmoy.Lpxmoy}>'<{/foreach}>],
                        pxmoy:[<{foreach from=$column->gdata->y->pt item=ptp}>'<{$ptp.pxmoy}>'<{if !$ptp@last}>,<{/if}><{/foreach}>],
                        camp:[<{foreach from=$column->gdata->x->pt item=ptp}>'<{$ptp.camp}>'<{if !$ptp@last}>,<{/if}><{/foreach}>]
                        }
                        
                    },
                <{/foreach}>
                <{foreach from=$data->serielist->lines->line item=line}>
                    {
                        type: "line",
                        label: "<{$line.label}>",
                        legendEntry: true,
                        data: {
                            x: [<{foreach from=$line->gdata->x->pt item=ptx}>'<{$ptx}>'<{if !$ptx@last}>,<{/if}><{/foreach}>],
                            y: [<{foreach from=$line->gdata->y->pt item=pt}>parseInt(<{$pt}>)<{if !$pt@last}>,<{/if}><{/foreach}>]
                        },
                        markers: {
                            visible: true,
                            type: "circle"
                        },
                        yAxis: 1
                    },
                <{/foreach}>
                 
                ],
        
                seriesStyles: [
                     <{foreach from=$data->serielist->bargraph->column item=column}>                
                    {
                        fill:"<{$column.color}>",stroke: "<{$column.color}>", "stroke-width": 0, opacity: 1
                    }<{if !$column@last}>,<{/if}>
                <{/foreach}>
                    ]
            });
            
            var lastCamp="<{$data.defcamp}>";
            //click bargraph
            $("#synthese").wijcompositechart({click: function(e, data) {
               
                if(data.type=="column"){
                    //change culture
                    var index=data.index;
                    var camp=data.data.camp[index];
                    
                    //verifie si la camp demandée est affichée
                 
                 
                    if(camp==lastCamp) return false;
                    lastCamp=camp;
                     $.ajax({
                            url:"/transaction/analysecomcultures/format/html/camp/"+camp,
                            success:function(data){
                               
                               try{
                                $("#cultPie").wijpiechart("destroy");
                               }catch(error){
                               
                               }
                                $("#main").append(data);
                                paintPies1();
                            },
                            error:function(error){
                            
                                alert("error"+error)
                            }
                
                        })
                }

            } })
            
           
    
            // preloader off
            $("#wrapperPreloader").css("display","none");


},100)


    // trig event pour le menu gauche  a changer

    $(window).trigger("menuToChange",[controller,action]);      
</script>


