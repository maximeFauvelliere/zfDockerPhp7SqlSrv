<!DOCTYPE html>
<html>  
<head> 
  <title>Maison e-bz mobiles</title> 

        <meta name="viewport" content="width=device-width,initial-scale=1.0"/> 
        <meta charset="UTF-8">
        <!--<meta http-equiv="Cache-Control" content="no-cache">
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv="Expires" content="0"> -->

        <!-- jquery --->
        <link rel="stylesheet" href="/mobiles/css/themes/themeEbzMobile.min.css" />
        <link rel="stylesheet" href="/mobiles/css/themes/jquery.mobile.icons.min.css" />
        <link rel="stylesheet" href="/mobiles/js/jquery.mobile.structure-1.4.2.min.css" />

        <!--custom theme-->

             <script src="/mobiles/js/jquery-1.10.2.min.js"></script>
        <!--mustache-->
        <script src="/mobiles/js/handlebars.2.0.0.js"></script>
        <script src="/mobiles/js/bzhandlebarjsregisters.js"></script>
        <!-- custom js -->
        <script src="/mobiles/js/converttoarray.js"></script>
        <script src="/mobiles/js/jquery-ui-1.10.4.custom.min.js"></script>
        <script src="/mobiles/js/localisation-fr-datapicker.js"></script>
        <script>
            
            $(document).bind("mobileinit",function(){
                             
                             //$.support.cors=true;
                            // $.mobile.allowCrossDomainPages = true;
                             
                             $.mobile.defaultPageTransition   = 'none';
                             $.mobile.defaultDialogTransition = 'none';
                             $.mobile.buttonMarkup.hoverDelay = 0;
                             
                             $.mobile.loader.prototype.options.text = "Chargement .....";
                             $.mobile.loader.prototype.options.textVisible = true;
                             $.mobile.loader.prototype.options.theme = "b";
                             
                             $.mobile.loadMsgDelay=0;
                             
                             /*$.event.special.swipe.horizontalDistanceThreshold='80';
                             $.event.special.swipe.verticalDistanceThreshold='5';*/
                             
                   
                            
                
            })
        </script>
        <script src="/mobiles/js/jquery.mobile-1.4.2.min.js"></script>
        <!--mustache-->
        <script src="/mobiles/js/highchart/highstock.js"></script>
       
        <!--style-->
        <link rel="stylesheet" href="/mobiles/css/style-m.css" />
        <!--date pickers -->
        
        <script src="/mobiles/js/jquery-mobile-datepicker-wrapper.js"></script>
        <!--bzfunctions-->
        <script src="/mobiles/js/bzfunctions.js"></script>
         <script src="/mobiles/js/template_compiled/ebzcompile.js"></script>


                
</head> 

<body > 
   <{$this->layout()->content}>
</body>



</html>


