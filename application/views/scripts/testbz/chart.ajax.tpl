<div id="wijbarchart" class="ui-widget ui-widget-content ui-corner-all" style="width: 400px;height: 300px">
</div>
<script>
setTimeout(function () {
            $("#wijbarchart").wijbarchart({
                axis: {
                    y: {
                        text: "Total Hardware"
                    },
                    x: {
                        text: ""
                    }
                },
                hint: {
                    content: function () {
                        return this.data.label + '\n ' + this.y + '';
                    }
                },
                header: {
                    text: "Console Wars"
                },
                seriesList: [{
                    label: "US",
                    legendEntry: true,
                    data: { x: ['PS3', 'XBOX360', 'Wii'], y: [12.35, 21.50, 30.56] }
                }],
                seriesStyles: [{
                    fill: "#8ede43", stroke: "#7fc73c", opacity: 0.8
                }],
                seriesHoverStyles: [{ "stroke-width": "1.5", opacity: 1
                }]
            });
        },50);    
	
</script>