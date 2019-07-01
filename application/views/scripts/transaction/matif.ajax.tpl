<script>
    
    var matifData=<{$data}>;
    var grid1;
    
    var reader1 = new wijarrayreader([
    {name:'id',mapping:function(item){return item.id}},
    {name:'titre',mapping:function(item){return item.titre}},
    {name:'Echeance',mapping:function(item){return item.echeance}},
    {name:'Qté ach',mapping:function(item){return item.qteask}},
    {name:'Achat',mapping:function(item){return item.ask}},    
    {name:'Vente',mapping:function(item){return item.bid}},
    {name:'Qté Vte',mapping:function(item){return item.qtebid}},
    {name:'Dernier traité',mapping:function(item){return item.last}},
    {name:'Var.',mapping:function(item){if(item.variation>0){return "+"+item.variation}else{return item.variation}}},
    {name:'+haut',mapping:function(item){return item.high}},
    {name:'+bas',mapping:function(item){return item.low}},
    {name:'Volume traité',mapping:function(item){return item.dailyvolume}}, 
    //{name:'Volume total',mapping:function(item){return item.posopen}},
    {name:'Pos. Ouv.',mapping:function(item){return item.posopen}},
    {name:'Cloture',mapping:function(item){return item.settlement}}        
]); 

$(document).ready(function(){

    if(!matifData.cultures.culture){
        $("#matif").html("Pas de données disponibles. Veuillez nous excuser pour ce désagrément.")
        return false;
    }
    $("#tabs").tabs({
        create:function(event,ui){
            //console.log("ui",ui.panel.selector);
            activeTab = $( "#tabs" ).tabs( "option", "active" );
            makeGridMatif(activeTab);

        },
        beforeActivate:function( event, ui ){
            var active = $( "#tabs" ).tabs( "option", "active" );
            $("#culture_"+active).wijgrid("destroy");
        },
        activate:function( event, ui ) {

              var active = $( "#tabs" ).tabs( "option", "active" );
              
              makeGridMatif(active);  
             
              
        }

    });
   
})

function makeGridMatif(activeTab){

            if(!matifData.cultures.culture){
                
                return false;
            }
    //cours
    //console.log("matifData1",matifData);
            var cours=matifData.cultures.culture[activeTab].cours.cour;
            //console.log("cours",cours);

            //if convertion en tab    
            if(!isArray(cours)){
                cours=convertToArray(cours);
            } 
            
            
            // remote
            grid1= $("#culture_"+activeTab).wijgrid({
            culture:"fr-Fr",
            allowSorting: false,
            data:new wijdatasource({
                reader:reader1,
                data:cours,
            loaded: function (data){

            }
            }),

            columns:[
              {visible:false},
              {visible:false},
              {width:"100px"},
              {width:"70px"},
              {width:"70px"},
              {width:"70px"},
              //{width:"60px",dataType:"number",dataFormatString: "n2"},

              {width:"70px"},
              {width:"70px"},
              {width:"70px"},
              {width:"70px"},
              {width:"70px"},
              {width:"70px"},
              {width:"70px"},
              {width:"70px"}

              ],
            ensureColumnsPxWidth : true,
           // cellStyleFormatter:test,
            //rendered:actions,
            selectionMode: "singleRow"   

            }).wijgrid("setSize",1200);
}

//timer de rechargement  des marchés
    bzTimers.push(setInterval(function(){
            
            //disable tabs
            $( "#tabs").tabs( {disabled:true });
            
            $.ajax({
                url:"/transaction/matif/format/json",
                success:function(data){
                  
                    if(data.error){
                        alert(data.error);
                        location.href="/";
                    }
                    matifData=data;
                     $("#date_marches_matif").html(matifData.cultures.datemarches);
                    //console.log("matifDatta2",matifData)
                },
                error:function(x,a,b){
                    //console.log("x",x);
                    //console.log("a",a);
                    //console.log("b",b);
                    alert("Une erreur est survenue, il est possible que les cours ne soient pas à jour.Vous allez être redirigé.")
                    location.hash="transaction_infosmarches";
                    $(window).trigger("hashchange");
                }
            })
            
            var active =$( "#tabs" ).tabs( "option", "active" );
            $("#culture_"+active).wijgrid("destroy");
            $("#matif").append('<div id="preload_matif" style="width:100%;height:50px;"><span>Actualisation en cours...</span></div>');
            setTimeout(function(){
                $("#preload_matif").remove();
                //enabled tabs
                $( "#tabs").tabs( {disabled:false });
                $("#date_marches_matif").empty();
               
                makeGridMatif(active);
            },200)
            
            
         },30000)
    );
    
</script>


<div>
    <h3 id="date_marches_matif" style="font-weight: normal;position: relative;top: -10px;margin:0px;display: inline" class="titleGrid"><{$matifdata->datemarches}> </h3><div class="cursor" style="float:right" id="pict_courbes"></div> <div style="position:relative;top:0px;left:0px;width:250px;">rafraîchissement toutes les 30 sec.</div>
        <div id="tabs">
                    <ul>
                        <{foreach from=$matifdata->culture item=culture}>
                        <li class="ongletSous"><a  href="#tabs-<{$culture@index}>"><{$culture->nom}></a></li>
                       <{/foreach}>
                        
                    </ul>
                    <{foreach from=$matifdata->culture item=culture}>
                        <div id="tabs-<{$culture@index}>" class="tabsMatif">
                            
                            <table class="matif" id="culture_<{$culture@index}>"></table>
                        </div>
                    <{/foreach}>
                    
<!--                    <div id="test0">
                            
                            <table class="matif" id="cours"></table>
                        </div>-->
            
                </div>
</div>
                    
<div id="dialog" class="trash" title="Matif Blé novembre 2013" style="display: none">
    <div style="width:100%">
        <div id="tabCourbes" style="width:300px;margin:auto;" class="ui-tabs ui-widget ui-widget-content ui-corner-a">
                        <ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
                            <li class="ongletSous ui-state-default ui-corner-top ui-tabs-active ui-state-active"><a  href="#3" id="line">Courbes</a></li>
                            <li class="ongletSous ui-state-default ui-corner-top"><a  href="#6" id="candles">Bougies</a></li>
                        </ul>
        </div>
    </div>
    <br/>
    <div id="highstock"  style="height: 500px; min-width: 500px">
    </div>
</div>

                   
                    
<script>
    
  
        $('#dialog').wijdialog({
                              autoOpen: false,
                              modal:true,
                              width:1000,
                              captionButtons: {
                              refresh: { visible: false},
                              pin: { visible: false},
                              minimize: { visible: false},
                              maximize: { visible: false},
                              toggle: { visible: false},
                              close:{visible: false}
                          }
                      });
    
    //data to chart
    var dataCharts="";
    
    // click courbes
    $("#pict_courbes").click(function(evt){
        
            
               var selected = grid1.wijgrid("selection").selectedCells();

                var idmh=selected.item(0).row().data['id'];
                
                var title=selected.item(0).row().data['titre'];
                
                //titre dialog
               $('#dialog').wijdialog({title:title,

                    open:function(e,ui){

                    var dialog=$(e.target);
                    if(!$(".sc-bt-dialog-close").length){
                         $(e.target).parent().find(".ui-dialog-titlebar").append("<span class='sc-bt-dialog-close' style='cursor:pointer;position:absolute;right:5px;' ></div>");
                                $(".sc-bt-dialog-close").bind("click",function(e){
                                    dialog.wijdialog('close');
                                })
                        }
                    }

});


//idRow=(pageSize*$("#contrats").wijgrid('option','pageIndex'))+selected.item(0).rowIndex();


               // call ajax ps
           $(function() {
               
               $.ajax({
                   url:'/courbesmatif/index/format/json',
                   dataType:"json",
                   type:"POST",
                   data:{"idmh":idmh},
                   success:function(data){
                       // create the chart
                       createCandles(data);
                   }
               })
                  
	
});
  
                $('#dialog').wijdialog('open');
            
        })
        
/**
* create candle stock
 */
 var ohlc = [],volume = [],lineClose = [];
 
 function createCandles(data){
                                //reset tableaux
                                ohlc = [],volume = [],lineClose = [];
                                
		var dataLength = data.length;
			
		for (i = 0; i < dataLength; i++) {
			ohlc.push([
				data[i][0], // the date
				data[i][1], // open
				data[i][2], // high
				data[i][3], // low
				data[i][4] // close
			]);
                        
                        lineClose.push([ data[i][0], // the date
                                        data[i][4]// close
                        ]);
			
			volume.push([
				data[i][0], // the date
				data[i][5] // the volume
			])
		}
               
               
   //aplly options
 Highcharts.setOptions({
	lang: {
		months: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin','Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'],
		weekdays: ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi']
	}
  })
 
    $('#highstock').highcharts('StockChart', {
        

		    rangeSelector: {
		        selected: 1
		    },

		    title: {
		        text: ''
		    },

		    yAxis: [{
		        title: {
		            text: 'Cours'
		        },
		        height: 200,
		        lineWidth: 2
		    }, {
		        title: {
		            text: 'Volume'
		        },
		        top: 300,
		        height: 100,
		        offset: 0,
		        lineWidth: 2
		    }],
		    
		    series: [{
		        type: 'line',
		        name: 'cours',
		        data: lineClose
		    },{
                        type: 'candlestick',
		        name: 'cours',
		        data: ohlc,
                        visible:false
                    
                    }, {
		        type: 'column',
		        name: 'Volume',
		        data: volume,
		        yAxis: 1
		    }]
		});
 }
 
 
        
$("#tabCourbes li").click(function(evt){
    
        //gestion style
         $("#tabCourbes li").removeClass("ui-tabs-active").removeClass("ui-state-active");
         $(evt.target).parent().addClass("ui-tabs-active").addClass("ui-state-active");
         //charting
        var chart = $('#highstock').highcharts();
        
        if($(evt.target).attr("id")=="candles"){
            
            chart.series[1].show();
            chart.series[0].hide();
                    
            //chart.series[0].setData(ohlc[0]);

            
        }else{
           chart.series[0].show();
            chart.series[1].hide();
        }

       
                        chart.redraw();

        return false;

})

    /**
 * Dark blue theme for Highcharts JS
 * @author Torstein Hønsi
 */

Highcharts.theme = {
   colors: ["#83B81A", "#83B81A", "#83B81A", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee",
      "#83B81A", "#DF5353", "#7798BF", "#aaeeee"],
   chart: {
      backgroundColor: "#fff",
      borderColor: '#fff',
      borderWidth: 2,
      className: 'beuzelin',
      plotBackgroundColor: 'rgba(255, 255, 255, .1)',
      plotBorderColor: '#CCCCCC',
      plotBorderWidth: 1
   },
   title: {
      style: {
         color: '#83B81A',
         font: 'bold 16px ubuntu,"Trebuchet MS", Verdana, sans-serif'
      }
   },
   subtitle: {
      style: {
         color: '#666666',
         font: 'bold 12px ubuntu,"Trebuchet MS", Verdana, sans-serif'
      }
   },
   xAxis: {
      gridLineColor: '#EDECE6',
      gridLineWidth: 1,
      labels: {
         style: {
            color: '#605046'
         }
      },
      lineColor: '#A0A0A0',
      tickColor: '#A0A0A0',
      title: {
         style: {
            color: '#605046',
            fontWeight: 'bold',
            fontSize: '12px',
            fontFamily: 'Trebuchet MS, Verdana, sans-serif'

         }
      }
   },
   yAxis: {
      gridLineColor: '#EDECE6',
      labels: {
         style: {
            color: '#605046'
         }
      },
      lineColor: '#A0A0A0',
      minorTickInterval: null,
      tickColor: '#A0A0A0',
      tickWidth: 1,
      title: {
         style: {
            color: '#605046',
            fontWeight: 'bold',
            fontSize: '12px',
            fontFamily: 'Trebuchet MS, Verdana, sans-serif'
         }
      }
   },
   tooltip: {
      backgroundColor: 'rgba(0, 0, 0, 0.75)',
      style: {
         color: '#F0F0F0'
      }
   },
   toolbar: {
      itemStyle: {
         color: 'silver'
      }
   },
   plotOptions: {
      line: {
         dataLabels: {
            color: '#CCC'
         },
         marker: {
            lineColor: '#333'
         }
      },
      spline: {
         marker: {
            lineColor: '#333'
         }
      },
      scatter: {
         marker: {
            lineColor: '#333'
         }
      },
      candlestick: {
         lineColor: 'black'
      }
   },
   legend: {
      itemStyle: {
         font: '9pt Trebuchet MS, Verdana, sans-serif',
         color: '#A0A0A0'
      },
      itemHoverStyle: {
         color: '#FFF'
      },
      itemHiddenStyle: {
         color: '#444'
      }
   },
   credits: {
      style: {
         color: '#666'
      }
   },
   labels: {
      style: {
         color: '#605046'
      }
   },


   navigation: {
      buttonOptions: {
         symbolStroke: '#DDDDDD',
         hoverSymbolStroke: '#FFFFFF',
         theme: {
            fill: {
               linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
               stops: [
                  [0.4, '#606060'],
                  [0.6, '#333333']
               ]
            },
            stroke: '#000000'
         }
      }
   },

   // scroll charts
   rangeSelector: {
      buttonTheme: {
         fill:"#D6DE52",
         stroke: '#000000',
         style: {
            color: '#605046',
            fontWeight: 'bold'
         },
         states: {
            hover: {
               fill: "#83B81A",
               stroke: '#000000',
               style: {
                  color: 'white'
               }
            },
            select: {
               fill: "#83B81A",
               stroke: '#000000',
               style: {
                  color: '#605046'
               }
            }
         }
      },
      inputStyle: {
         backgroundColor: '#fff',
         color: '#605046'
      },
      labelStyle: {
         color: '#605046'
      }
   },

   navigator: {
      handles: {
         backgroundColor: '#666',
         borderColor: '#AAA'
      },
      outlineColor: '#605046',
      maskFill: 'rgba(96, 80, 70, 0.5)',
      series: {
         color: '#83B81A',
         lineColor: '#83B81A'
      }
   },

   scrollbar: {
      barBackgroundColor: {
            linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
            stops: [
               [0.4, '#888'],
               [0.6, '#555']
            ]
         },
      barBorderColor: '#CCC',
      buttonArrowColor: '#CCC',
      buttonBackgroundColor: {
            linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
            stops: [
               [0.4, '#888'],
               [0.6, '#555']
            ]
         },
      buttonBorderColor: '#CCC',
      rifleColor: '#FFF',
      trackBackgroundColor: {
         linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1 },
         stops: [
            [0, '#000'],
            [1, '#333']
         ]
      },
      trackBorderColor: '#666'
   },

   // special colors for some of the
   legendBackgroundColor: 'rgba(0, 0, 0, 0.5)',
   legendBackgroundColorSolid: 'rgb(35, 35, 70)',
   dataLabelsColor: '#444',
   textColor: '#C0C0C0',
   maskColor: 'rgba(255,255,255,0.3)'
};

// Apply the theme
var highchartsTheme = Highcharts.setOptions(Highcharts.theme);

</script>
    
    