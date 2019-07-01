 
<div  data-role="page" id="mygraph"><!-- graph-->
            <div id="change-orientation">
                <p>Tournez votre téléphone pour afficher la courbe.</p>
                <a href="#" data-rel="back" data-role="button" data-theme="c"  data-iconpos="notext" class="ui-btn-right">Retour</a>
            </div>

            <div data-role="content" >
                <div class="header-content" style="font-size: 12px;margin: 5px;padding: 2px;">
                    <span id="ech-marche-graph"> </span><div id="bt-chart-close-wrapper"><a href="" data-role="button" data-rel="back">Fermer</a></div>
                </div>
                <div id="charts-wrapper">

                    <div id="highstock"></div>
                </div>
            </div>
            
             <script>
                 
                //decalageBody();
                
                $("#bt-chart-close-wrapper a,#change-orientation a").off("tap",function(e){
                                               $(e.currentTarget).removeClass("ui-btn-active");
                                                   }).on("tap",function(e){
                                                             
                                                             $(e.currentTarget).addClass("ui-btn-active");
                                                             
                })
                 
          
            /**
             * create candle stock
             */
            var ohlc = [], volume = [], lineClose = [];

            function createCandles(data) {
                //reset tableaux
                ohlc = [], volume = [], lineClose = [];

                var dataLength = data.length;

                for (i = 0; i < dataLength; i++) {
                    ohlc.push([
                        data[i][0], // the date
                        data[i][1], // open
                        data[i][2], // high
                        data[i][3], // low
                        data[i][4] // close
                    ]);

                    lineClose.push([data[i][0], // the date
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
                        months: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'],
                        weekdays: ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi']
                    }
                })

                $('#highstock').highcharts('StockChart', {
                    chart: {
                        height: 230,
                        marginLeft: 20,
                        borderWidth: 1,
                        style: {
                            fontSize: '10px'
                        }

                    }, navigator: {
                        enabled: false
                    }, scrollbar: {
                        enabled: false
                    },
                    rangeSelector: {
                        selected: 1,
                        buttons: [{
                                type: 'month',
                                count: 1,
                                text: '1m'
                            }, {
                                type: 'month',
                                count: 3,
                                text: '3m'
                            }, {
                                type: 'month',
                                count: 6,
                                text: '6m'
                            }, {
                                type: 'year',
                                count: 1,
                                text: '1y'
                            }, {
                                type: 'all',
                                text: 'All'
                            }]
                    },
                    title: {
                        text: ''
                    },
                    yAxis: [{
                            title: {
                                text: 'Cours'

                            },
                            height: 150,
                            lineWidth: 1
                        }, {
                            title: {
                                text: 'Volume',
                                offset: -60,
                                rotation: 0
                            },
                            top: 150,
                            height: 50,
                            offset: 0,
                            lineWidth: 1
                        }],
                    series: [{
                            type: 'line',
                            name: 'cours',
                            data: lineClose
                        }, {
                            type: 'candlestick',
                            name: 'cours',
                            data: ohlc,
                            visible: false

                        }, {
                            type: 'column',
                            name: 'Volume',
                            data: volume,
                            yAxis: 1
                        }]
                });
            }
            
           
     
            var idMh={"idmh":ech}
            $(".ui-loader").css("display","block")
              $.ajax({
                                url: "/courbesmatif/index/format/json",
                                          data:idMh,
                                            type:"POST",
                                            dataType:"json",
                                success: function(data) {
                                      if(data.success=="error"){
                                            if(data.type=="timeout"){
                                                timeOut(data.type);
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","marches.html");
                                                return;
                                            }else{
                                                alert("Une erreur s'est produite, vous allez être redirigé.")
                                                $( ":mobile-pagecontainer" ).pagecontainer( "change","index.html");
                                            return;
                                            }
                               
                                        }
                                    $(".ui-loader").css("display","none")
                                    data["lastCall"]=new Date().getTime();
                                    localStorage.graph =JSON.stringify(data);
                                    $("#ech-marche-graph").text(libech);
                                    createCandles(data);
                                },
                                error:function(a,b,c){
                                    ajaxError(a.status,b);;
                                }
                            })

        </script>




        </div><!-- /page -->
              
           