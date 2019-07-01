<{$this->doctype()}>
<html>
    <head>
    <{$this->headMeta()->setCharset('UTF-8')}>
    <{$this->headLink()->appendStylesheet('https://fonts.googleapis.com/css?family=Abel')
                       ->appendStylesheet('https://fonts.googleapis.com/css?family=Ubuntu')
                  
                  
                 
    }>
    <{$this->headScript()->appendFile('/javascript/library/jquery1.8.3.js')
                        
    }>

    </head>
    <body>
        <div style="overflow: hidden">
        <p style="font-size: 12pt;color:red;text-align: center">Ce document n'est pas encore téléchargeable, son traitement est en cours.</br>Veuillez essayer ultérieurement.</p>
                   <div style="width:100%;text-align:center;">
                    <input id="btRetour" type="button" value="fermer message"/>
                    </div>
        </div>
        
        <script>
                        $(document).ready(function(){
                            
                            $("#preloader").css("display","none");
                            
                             //window.top.showErrorMessage();
                            
                            $("#btRetour").click(function(){

                                //location.href="/'.$from.'";
                                window.close() ;  

                                return false;
                                

                            })
                        })

                    </script>

    </body>

</html>

