<{$this->doctype()}>
<html>
    <head>
        <{$this->headMeta()->setCharset('UTF-8')}>

        <{$this->headLink()->appendStylesheet('/styles/basic.css')
                            ->appendStylesheet('/styles/style.css')
                          ->appendStylesheet('/styles/IE8.css','all','IE 8')
                          ->appendStylesheet('https://fonts.googleapis.com/css?family=Abel')
                          ->appendStylesheet('https://fonts.googleapis.com/css?family=Ubuntu')


        }>

        <{$this->headScript()->appendFile('/javascript/library/jquery1.7.2.js')
                            ->appendFile('/javascript/library/jqUITool.js')
                            ->appendFile('/javascript/library/forcepass.js')

        }>
    </head>

<body>
    <div class="page">
        <div id="headerPC">
        </div>
        <div style="width:100%;text-align:center">
            <h1>toto error for mobile devices</h1>
            <{$this->layout()->content}>
        </div>
      
    </div>
       
</body>



</html>

                                            