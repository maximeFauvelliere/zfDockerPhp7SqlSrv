<script  type="text/javascript">
        $(document).ready(function () {
            $("#wijcompositechart").wijcompositechart({
                culture:"fr-FR",
                axis: {
                    y: [{
                        text: "Quantité"
                        },
                        //y2
                        {
                           
                           text: "Gains en euros",
                           compass: "east",     
                           annoFormatString:"C0",
                          //traits horizontaux
                            gridMajor:{
                                visible:false

                            },
                            labels:{
                                style: {
                                fill: "#000000",
                                'font-size':"8pt"

                                }

                            } 
                           
                        }
                    ],
                    x:{
                        text: ""
                    }
                },
                stacked: false,
                hint: {
                    content: function () {
                        return this.label + '\n ' + this.y + '\n index'+this.index;
                    }
                },
                header: {
                    text: "synthese commerciale"
                },
                seriesList: [{
                    type: "column",
                    label: "blé",
                    legendEntry: true,
                    data: { x: ['blé', 'orge', 'colza', 'avoine', 'toto'], y: [5, 3, 4, 7, 2] }
                }, {
                    type: "column",
                    label: "orge",
                    legendEntry: true,
                    data: { x: ['blé', 'orge', 'colza', 'avoine', 'toto'], y: [2, 2, 3, 2, 1] }
                }, {
                    type: "column",
                    label: "colza",
                    legendEntry: true,
                    data: { x: ['blé', 'orge', 'colza', 'avoine', 'toto'], y: [3, 4, 4, 2, 5] }
                },{
                    type: "column",
                    label: "avoine",
                    legendEntry: true,
                    data: { x: ['blé', 'orge', 'colza', 'avoine', 'toto'], y: [3, 4, 4, 2, 5] }
                },{
                    type: "column",
                    label: "toto",
                    legendEntry: true,
                    data: { x: ['blé', 'orge', 'colza', 'avoine', 'toto'], y: [3, 4, 4, 2, 5] }
                }
                , /*{
                    type: "pie",
                    label: "asdfdsfdsf",
                    legendEntry: true,
                    center: { x: 150, y: 150 },
                    radius: 60,
                    data: [{
                        label: "MacBook Pro",
                        legendEntry: true,
                        data: 46.78,
                        offset: 15
                    }, {
                        label: "iMac",
                        legendEntry: true,
                        data: 23.18,
                        offset: 0
                    }, {
                        label: "MacBook",
                        legendEntry: true,
                        data: 20.25,
                        offset: 0
                    }]
                }, */{
                    type: "line",
                    label: "prix",
                    legendEntry: true,
                    data: {
                        x: ['camp 2010', 'camp 2011', 'camp 2013', 'camp 2014', 'camp2015'],
                        y: [25000, 35000, 40000, 100000, 80000]
                    },
                    markers: {
                        visible: true,
                        type: "circle"
                    },
                    yAxis: 1
                }
                ]
            });
            
            
           // console.log("object composite",$("#wijcompositechart").wijcompositechart("getElement", "column", 0))
            
            
            $("#wijcompositechart").wijcompositechart({click: function(e, data) {
                
                alert("click");
                //console.log("e",e);
                //console.log("data",data);
                
        
            } })
            
             
        });
        
       
    </script>
  
    <div id="eventscalendar"></div>
  
    <div class="container">
        <div class="header">
            <h2>
                Overview</h2>
        </div>
        <div class="main demo">
            <!-- Begin demo markup -->
            <div id="wijcompositechart" class="ui-widget ui-widget-content ui-corner-all" style="width: 756px; height: 475px">
            </div>
            <!-- End demo markup -->
            <div class="demo-options">
                <!-- Begin options markup -->
                <!-- End options markup -->
            </div>
        </div>
        <div class="footer demo-description">
            <p>
                The Wijmo Composite Chart widget (wijcompositechart) allows you to draw multiple types of charts in one canvas simultaneously. 
                This sample uses a bar and line chart. The line chart emphasizes the gradual increase of visitors over time.
                </p>
        </div>
    </div>