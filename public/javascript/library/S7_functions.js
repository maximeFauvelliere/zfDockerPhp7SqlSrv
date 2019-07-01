//array pour tout les timers afin de pouvoir les arreter tous en meme tps
var bzTimers = new Array();


//check erreur sql 
function checkError(codeError){
    /**
     * TO delete 
     **/
    switch(codeError){
                       
        case 1:
            alert("erreur sql code:"+codeError);
            return false;    
            break; 
        case 2:
            alert("erreur sql code:"+codeError);
            return false;    
            break;
        default:              
            return true;
            break;        
                           
    }    
}
        
//check variable state
function isSet(obj){
    if(obj != null && obj != undefined){
        return false;
    }else{
        return true;
    }
}   
//-----function de test si l'objet est un tableau d'objet , sinon crée le tableau d'objet
function isArray(obj) 
{
    if(obj != null && obj != undefined)
    {
        if (obj.constructor.toString().indexOf("Array") == -1)
            return false;
        else
            return true;
    }else
    {
        return false;
    }
}
/**
         *convertie les data en array de data
         */
function convertToArray(data)
{
    if(exist(data))
    {
        if(!isArray(data))
        {
            data = [data];
        }
    }else
    {
        data = [];
    }
    return data;
}
/**
         *check si data existe
         */
function exist(data)
{
    return  data != null && data != undefined;
}
// function detial
/**
 *affiche le detail pour une cellule 
 *
 **/
/**
         * convertie les virgule en point
         */
function convertVirgule(obj){
    obj.keyup(function(o){
       
        if(o.keyCode==188){

            str=$(o.target).val();

            str= str.replace(',','.');

            $(o.target).val(str);
        }    
    })
}
                
//check if is numeric 
function IsNumeric(val) {

    if (!$.isNumeric(val)) {
        return false;
    }
    return true;
}


//check si les champs input sont bien des nombres
/**
        * @parametre objet jquery ou array
        * @parametre option accepte les null
        */
function inputIsNumeric(obj,canBeEmpty){
    /**
     *@tod verification cahmp numerique passer expression reguliere
     * prend toujour la derniere valeur de la variable
     */
    return true;
    flag=false;
    is_Numeric=true;
    is_Null=canBeEmpty;
           
    obj.each(function(i,e){
        //(e)          
        if(!IsNumeric($(e).val())){

            is_Numeric=false;
        };
                
        if(canBeEmpty){
                    
            if(!$(e).val()==""){
                is_Null=false;
            }
                    
        }
                
        if(is_Numeric + is_Null){
                    
            flag=true;
                    
        }else{
            //alert("Tous les champs doivent être numériques ");
            $(e).val("");
            $(e).focus();
                    
        }
                          
    });
    
    return flag;
}

//lenght of object or associtive array
 function ObjectLength(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
}

// ---------------------traitement ----------------------//
/**
 *call stuff for create silo
 */
 function createSilo(canvas,w,h,xCell,yCell,wCell,hCell,methode,callBackCelluleClick,data,hasCellDetail,idRoot,hasTitle,globalOpti,hasRoof){

                

                var paper= new Raphael(canvas,w,h);

                 silo = new Silo(paper,idRoot,hasRoof);
                 silo.setDetail=hasCellDetail;
                 silo.addCellule(xCell,yCell,wCell,hCell,silo,methode,callBackCelluleClick,true,data,hasTitle);
                 
                 
                 
                 // gestion opti et securise global ex produits
                 if(data[0].cellules.optimiz){
                     var hasLock=parseInt(data[0].cellules.optimiz['@attributes'].haslock);
                 }else{
                     var hasLock=false;
                 }
                 
                 if(globalOpti && hasLock){
                     //("data from create silo",data);
                     //("data from create silo2",data[0].cellules.optimiz['@attributes'].haslock);
                     //("cellWidth",silo.cellWidth);
                     //("startX",silo.startX);
                     //("nbcellule",silo.nbCellules)
                     //("cellheight",silo.cellHeigh);
                     var unlock=parseInt(data[0].cellules.optimiz['@attributes'].unlock);
                     var checked=parseInt(data[0].cellules.optimiz['@attributes'].checked);
                    
                     var siloWidth=(silo.nbCellules*silo.cellWidth);
                     //("siloWidth",siloWidth);
                     silo.addGlobalOpti(siloWidth,xCell,unlock,checked);
                 }
                 
                 
                }

/**
 *vide le content balise 'main' de la page 
 */   
function deletePagecontent(){
    
    
    $("#main").empty();
    //destroye filter
    //filter.destroy();
    
    //vide la div filtre
    //$("#D_filter").remove();
    //hide tooltip if is  showing
    $(".bztooltip").remove(); 
    //creer une div canvas
    //$("#main").append("<div id='canvas'></div>");   
}

function trashHtml(){
    
    $(".bztooltip").remove();
    $(".trash").remove();
    
}

/**
 *creer le silo left globale 
 */
function createDSilo(cellData,idRoot,hasTitle,hasClick){
   
  // ("cellData",cellData);
            var paper= new Raphael("canvas",750,410);
            var silo = new Silo(paper);
            var hasClick=hasClick?hasClick:null;
            silo.idRoot=idRoot;
            
            silo.addCellule(150,70,92.655,277,silo,"setCultures",hasClick,false,[cellData],hasTitle);
           // temp a supp silo.addCellule(xCell,yCell,wCell,hCell,silo,methode,callBackCelluleClick,true,data);
           //temp a supp createSilo("canvasCellFermes",1000,410,45,70,85,295,"setGlobal",false,[cellules]);
}

/*
 *
 */
function UrlPageRequest(base,controller,action,context,filtre){
    
    
    /*
     *base url
     */
    this.base=base;
    
    
    
    /*
     * controller : rubrique
     * example : prospection
     */
    this.controller=controller;
    
    /*
     *action : hash
     *example : stockferme
     */
    this.action=action;
    
    /*
     * ajax context
     * 
     */
    this.context=context;
    
    /*
     *filtre 
     */
    this.filtre=filtre;
    
    /*
     * setter 
     */
    
    this.setBase=function(base){
        this.base=base;
    }
    this.setController=function(controller){
         
        this.controller=controller;
        
    }
    this.setAction=function(action){
        this.action=action;
    }
   
    this.setContext=function(context){
        this.context=context;
    }
    
    this.setFiltre=function(filtre){
        
        this.filtre=filtre;
    }
    
    
    
    /*
     * url complete de la page
     */
    this.getFullPageUrl=function(){
        /**
         *require function objectLength
         */
        
        //object url+filtre
        var fullPageUrl={};

        var filtre=ObjectLength(this.filtre)?this.filtre:this.filtre=new Array();

        var context=this.context?"format/"+this.context:"";
        //var filtre=this.filtre?this.filtre:null;
        
        fullPageUrl={url:this.base+"/"+this.controller+"/"+this.action+"/"+context,filtre:filtre};
        
        return fullPageUrl;
        
    }
    
    this.getBasePageUrl=function(){
        
       var basePageUrl={};
       
       basePageUrl={url:this.base+"/"+this.controller+"/",filtre:filtre}; 
       
       return basePageUrl;
        
    }
    
    
    this.toString=function(){
        
        return {"base":this.base,"controller":this.controller,"action":this.action,"context":this.context,"filtre":this.filtre};
    }
    
    
    
}
function Detail(){
        
        /*
         *@var
         *data globale from silo défini ici pour coherence de l'objet detail
         *qui se sert des données dataSilo
         */
        this.siloData
        //init propriétés
        this.cellule=false;
        this.idCell=null;
        this.hashRequest=false;
        this.cellData=null;
        this.titleCell=null;
        
        

        //setter
        this.setCellule=function(cellule){this.cellule=cellule};
        this.setIdCell=function(idCell){this.idCell=idCell};
       //affectation des données
       //show detail
       this.getDetail =function(){
           
           //alert("detail")
            
            /**
             * @todo ne semble pas utiliser voitr to delete
             **/
            this.idcell=this.id;
            
            

            this.cellData=this.cellule.data('dataCell');
            
            //check if detail exist for this
            if(!this.cellData.cultures){
            alert("Vous n'avez pas "+this.cellData['@attributes']['titre'].split(".")[0]);
            return;   
           }

            //vide le main
            deletePagecontent();
           
            //campagne
            camp=this.cellData['@attributes']['camp'];
            
            
            //var pattern=/\.png$/i;
            this.titleCell=this.cellData['@attributes']['titre']; 

            // code corespond a l'action du controller to call
            this.code=this.cellData['@attributes']['code'];
            //("code",this.code);
            // tableau equivalence titres/controllers
            //var e={"Stock Ferme":"ferme","Stock Dépot":"depot","Historique":"historique","En cours":"encours","Prévisionnel":"previsionnel"};
            //("code cellule",this.cellData['@attributes']['code']);
            //("titre convert",this.titleCell);
            
            //this.titleCell=e[this.titleCell];

            //("titre convert",this.titleCell);
            //if(pattern.test(this.titleCell)){
               // this.titleCell=this.titleCell.split(".")[0];
            //}
            
            //("title",this.titleCell);
            
            //pageRequest=new UrlPageRequest(baseUrl,controller,"ferme","html",null);
            //(pageRequest.toString());
            //("url",controller+"_"+this.code+"/contrat/"+this.titleCell);
            if(controller=="transaction"){
                location.hash=controller+"_"+this.code+"/contrat/"+this.titleCell;
            }else{
                
                location.hash=controller+"_"+this.code;
            }
            
            //("controller in detail",controller);
                        
        }   
                   
    }//fin getdetail
       

/**
 * filter
 * 
 **/             
function Filter(jqSelector,camp,cultures,structures,data){
    
    this.jqSelector=jqSelector;
    this.camp=camp;
    this.cultures=cultures;
    this.structures=structures;
    this.data=data;
    this.modify=false;
    this.selection=false;
    
    this.createFilter=function(){
        
        var selection=this.selection;
        var selector=this.jqSelector
        //ajax request
        try{
            
            var request=new UrlPageRequest(baseUrl,"filter","index","html");
            var url=request.getFullPageUrl().url;
            
            
            //traitement state filter
            if(this.selection){
                
                var state=1;
                var camp="null";
                
            }else{
                
               var state=this.modify?0:2;
               var camp="null";
               //si camp est null then state =2
               if(!this.camp){
                  state=2;
                  
               }else{
                   camp=this.camp;
                   state=3;
               }
               
               
               
            }
            
            var data = {filter:state,camp:camp}; 
            //console.log("data filter",data);
            //console.log("url filter",url);
            
            $.ajax({
                url:url,
                data:data,
                type:"POST",
                success:function(htmlFilter){
                   
                   //$(selector).wijdialog("widget").length
                   // si deja un filtre
                    if($(selector).wijdialog("widget").length){
                       $(selector).wijdialog("destroy");
                       $(selector).remove();

                    }
                    //append filter html
                    $("#filtre").append(htmlFilter);
                     
                    //show filter
                     try{
                        // creation filtre  dialog
                            $(selector).wijdialog({
                                width:105,
                                dialogClass: "D-filter",
                                draggable: true,
                                resizable: false,
                                position:{my: "center top+55",at: "center top+25%",of: "#filtre"},
                                title:"<div id='icoFilter'><span>Filtre</span></div>",
                                captionButtons: {
                                    pin: {
                                        visible: false, 
                                        click: self.pin, 
                                        iconClassOn: 'ui-icon-pin-w', 
                                        iconClassOff:'ui-icon-pin-s'
                                    },
                                    toggle: {
                                        visible: true
                                    },
                                    minimize: {
                                        visible: false
                                    },
                                    maximize: {
                                        visible: false
                                    },
                                    refresh:{
                                        visible:false
                                    },
                                    close: {
                                        visible: false
                                    }
                                },
                                create:function (){
                                    
                                    //add click to filter with stuff
                                    clickData();
                                    clickRecord();
                                    clickMySel();
                                    clickAllCult();
                                    ("this",$("#filtre").offset())
                                    //$(this).css("top",$("#filtre").offset().top);
                                    //$(this).css("left",$("#filtre").offset().left);
                                    
                                },
                                open:function(e){
                                    // fait disparaitre le bt toggle d'origine
                                    // si on le desactive part le framework la function toggle dynamic est impacté
                                     $(".D-filter .ui-dialog-titlebar .wijmo-wijdialog-titlebar-toggle").css("display","none");
                                    // replace icone toggle par custom icon
                                     var dialog=$(e.target);
                                        if(!$(".sc-bt-dialog-toggle").length){
                                             $(e.target).parent().find(".ui-dialog-titlebar").append("<span class='sc-bt-dialog-toggle' style='cursor:pointer;position:absolute;right:5px;' ></div>");
//                                                    $(".sc-bt-dialog-toggle").bind("click",function(e){
//                                                        dialog.wijdialog('close');
//                                                    })
                                        }
                                   
                                    $(window).trigger("filterOpen");
                                   
                                    //replace top position car fonctionne mal a la création
                                   // $(".D-filter").css("top","-280px");
                                    $(selector).wijdialog("toggle");
                                    
                                    //trigger filter pour large click on D_filter
      $(".D-filter .ui-dialog-titlebar").click(function(){
                                           $(selector).wijdialog("toggle");;
      })
                                 
                                      
                                 
                                }    

                            });
                            
      
                        }catch(execption){
                        /**
                        *@todo si pb filtre ??
                        */
                        }
                    
                },
                error:function(){
                    
                }
                
            })
            
          
        }catch(error){
            
            
        }
        
        
        
        
       
    }




var clickData=function(){

   
                                   //add click
                                   $(".filterInput").click(function(e){
                                       
                                        //never no selected cultures
                                      if( !$("#F_cult input:checked").length>0){
                                          
                                          $("#F_cult input:first").attr("checked","checked");
                                      }
                                       //never no selected structure
                                      if( !$("#F_struct input:checked").length>0){
                                          
                                          $("#F_struct input:first").attr("checked","checked");
                                      }
                                      
                                        // if myselect reset myselect
                                        if($("#mySel").is(':checked')){
                                            
                                            $("#mySel").attr("checked",false);
                                        }
                                      
                                       //pour sens d'appel des requetes sql
                                      if($(e.target).attr("name")!="camp"){
                                        
                                         $(window).trigger('hashchange');
                                      }
                                       
                                        filter.modify=true;
                                        
                                       if($(e.target).attr("name")=="camp"){
                                            var camp=$(e.target).attr("idcamp");
                                            //console.log("camp",camp);
                                            
                                            //destroye filter
                                            filter.destroy();
                                            //vide la div filtre
                                            $("#D_filter").remove();
                                            //build filter
                                            filter=new Filter();
                                            
                                            filter.setSelector("#D_filter");
                                            filter.modify=true;
                                            //("modify",filter.modify);
                                            filter.setCamp(camp);
                                            filter.createFilter();
  
                                       }
                                       
                                      
                                         //pour sens d'appel des requetes sql
                                         // a revoir meme condition que le precedent if ??????
                                          if($(e.target).attr("name")=="camp"){
                                              
                                              //@todo solution temporaire trouver une solution pour dispatcher evenement filtre create or open
                                              // avant d'appeller haschange
                                             // le filtre n'est pas encore creer lorsque hashchange est appelé
                                             //je place un timer de  500 ms avant d'appeller le haschange solution temporair
                                             setTimeout(function(){$(window).trigger('hashchange')},1700);
                                             // $(filter).bind("filterOpen",function(){alert("bind filteropen")})
                                            //$(window).trigger('hashchange');
                                          }
                                         
                                         
                                         //getOldChecked
                                        // var filterdata=filter.getChecked(e.target);
                                         //("filterdata",filterdata);
                                     });
                                     
            _gaq.push (['_trackEvent',"filtre","camp_culture_structure","utilisateur filtre"]);                         
    }
    
    var clickRecord=function(){
       
        $("#rec_filter").click(function(e){
           
            var url=baseUrl+"/filter/record/format/html";
            var data={filter:filter.getChecked()};
            $.ajax({
                url:url,
                data:data,
                success:function(data){
                    //("data record",data);
                    alert("Sélection correctement enregistrée.");
                    $("#mySel").attr("checked","checked");
                    
                },
                error:function(){}
            })
        })
        
        _gaq.push (['_trackEvent',"filtre","record filtre",'utilisateur utilise  l\'enregistrement d\'1 filtre perso']);
    }
    
    var clickMySel=function(){
        
        $("#mySel").click(function(e){
            
            if($(e.target).is(':checked')){
                
                //build filter
                filter=new Filter();
                filter.setSelector("#D_filter");
                filter.selection=true;
                filter.createFilter();
                //keep checkbox selected
                $(window).bind("filterOpen",function(){
                   $("#mySel").attr("checked","checked");
                   // unbind car sinon mySel reste selectionné quand 
                    $(window).unbind("filterOpen");
                })
                
                //call acc
                $(window).trigger('hashchange');
            } 
            

        })
        
        _gaq.push (['_trackEvent',"filtre","sa selection",'utilisateur recupère sa selection']);
    }
    
    var clickAllCult=function(){
       
        $("#ttc").click(function(){
            
            //("click all cult");
                // if myselect reset myselect
      
                    $("#mySel").attr("checked",false);
                    $("#pasStructures").attr("checked","checked");
               
                
                var camp=null;

                //build filter
                filter=new Filter();
                filter.setSelector("#D_filter");
                
                //get selected camp
                $("#F_camp :input").each(function(i,e){
                    if($(e.target).is(':checked')){
                        
                        camp=$(e.target).attr("idcamp");
                    }
                })
                filter.setCamp(camp);
                
                filter.createFilter();

                //call hash change
                $(window).trigger('hashchange');
            
            

        })
        
        _gaq.push (['_trackEvent',"filtre","toutes les cultures",'utilisateur utilise toutes les cultures']);
    }
    
    /*
     *détrui la dialog box et remet son content ds état initial avant wijdialog
     *
     */
    this.destroy=function(){
        $(this.jqSelector).wijdialog("destroy");
    }
    
    
    
    this.filter=function (){
        
        
        return this.data;
        
    }
    
    // setters
    this.setSelector=function(jqSelector){
        
        this.jqSelector=jqSelector;
    }
    
    this.setCamp=function(camp){
        
        this.camp=camp;
    }
    
    this.setCultures=function(cultures){
        
        this.cultures=cultures;
    }
    
    
    this.setStructures=function(structures){
        
        this.structures=structures;
    }
    
    this.setChecked=function(data){
        // data : data={camp:11,culture:"1002;1005;2365;",structures:"23;45;78;"}
        //("data",data)
       
       
      // pour eviter probleme this ds boucle s
       var selector=this.jqSelector;
       
       
         $.each(data,function(k,v){
             
             
                 
             if(k=="camp"){
                 
                $(selector+" input:checked").each(function(i,e){
                    // ("e",$(e).val());
                     if($(e).val==v){
                         
                       //  (k,$(e).attr("checked"))
                     }
                     
                     
                 })
             }else if(k=="cultures"){
                 
             }else if(k=="structures"){
                 
             }
             
             
         })
        //this.data=data;
    }
    
    
    
    //---getters
    this.getCamp=function(){
        
       return this.camp;
    }
    
    this.getCultures=function(){
        
        return this.cultures;
    }
    
    
    this.getStructures=function(){
        
        return this.structures;
    }
    
    /**
     *recupere les selection du filtre
     *si un argument est passé (object jquery:$("#input"))
     *c'est l'etat précedent le clic qui est renvoyé
     *sinon c'est l'état apres le click
     *
     **/
    this.getChecked=function(activeElement){
        
       //console.log("getcheked",activeElement);
        //switch temporairement l'etat du input cliqué.(remis dans l'etat apres traitement)'
        if(activeElement && $(activeElement).attr('name')!="camp"){
            $(activeElement).attr('checked', !$(activeElement).attr('checked'));
        }

        var data=new Object();
        
        /**
         * a revoir pour l'affectation objet pas tres propre ""
         */
        
        
        //console.log("jqselector",$(this.jqSelector+" input:checked"))
       
       // $(this.jqSelector+" input:checked").each(function(i,e){ le probleme est ici input checked return rien parfois
       $(this.jqSelector+" input:checked").each(function(i,e){
            
            //console.log("e",e)
            
            if($(e).attr('name')=="cultures"){
            
               if(!data['cultures'])
               {
                    data['cultures']=$(e).attr('idcu')+";";
               }else{
                   data['cultures']+=$(e).attr('idcu')+";";
               }
                
            }else if($(e).attr('name')=="structures"){
                
                if(!data['structures'])
               {
                    data['structures']=$(e).attr('idti')+";";
               }else{
                   data['structures']+=$(e).attr('idti')+";";
               }
               
            }else if($(e).attr('name')=="camp"){
                
                if(!data['camp'])
               {
                    data['camp']=$(e).attr('idcamp');
               }
            }
            
            
           
          // console.log("element form",e);
            
        })
        
        //remet dans  l'etat du input cliqué
        if(activeElement && $(activeElement).attr('name')!="camp"){
            $(activeElement).attr('checked', !$(activeElement).attr('checked'));
        }
        
         
        data['modify']=this.modify;
               
                 
        //console.log("data in getcheck",data);
        return data;
    }
    
    
    
    
    
}

/**
 * event hash change
 * 
 * */

eventHashChange=function(){

            $(window).hashchange(
                function(e){

                    $(".bzModale").remove();
                    
                    //clear  timer
                    // clear all timers in the array
                    for (var i = 0; i < bzTimers.length; i++)
                    {
                        clearInterval(bzTimers[i]);
                    }
                    
                    bzTimers=[];
                    hash=location.hash.replace("#",''); 
                  
                    //l'URL to call
                    if(hash!="accueil"){
                        
                            // 
                            // affiche preloader
                            $("#main").css("display","none"); 
                            $("#preloader").css("display","block"); 
                            var url;
                            var format=null;
                         try{
                             
                             // split le hass controller_action
                             var _controller=hash.split("_")[0];
                             var _action=hash.split("_")[1];
                             
                              
                             // check si une information de format est envoyé ex :format/json
                              var pattern=/\/format\/json/;
                         
                              if(_action.search(pattern)>-1){
                                   
                                   format=_action.match(pattern)[0];   
                              }
                              
                              if(!_controller){ 
                                  
                                  /**
                                   *@todo suppression erreur controller
                                   */
                                  alert("pas de controller ds hash change");
                                  alert("une erreur de navigation est survenue.Vous allez être redirigé vers l'accueil.")
                                  window.location.href="/index/";
                              }
                              pageRequest.setController(_controller);

                              
                              // sinon format par défaut format/html/
                              if(!format){
                                 _action=_action+"/format/html/";
                              }else{
                                format="";
                              }

                              url=pageRequest.getBasePageUrl().url+_action+format;
                              
                              //("url",url);
                             
                              var data={"filter":filter.getChecked()};
                              //console.log("filter",data);
                              
                              
                             
                         }catch(error){
                             alert("code 001   : une erreur de navigation est survenue.Vous allez être redirigé vers l'accueil.")
                             window.location.href="/index/";
                         }
                         
                         
                         //console.log("url",url);
                         //ajax call
                         $.ajax({
                              url:url,
                              data:data,
                              type:"POST",
                              success:function(data){
                                  //console.log("data",data)
                                  //supprime les tool tip , les dialog qui s'accumule
                                  trashHtml();
                                  
                                  deletePagecontent();
                                  
                                  $("#canvas_siloNav").css("display","block");
                                  
                                  $("#main").append(data);
                                  
                                  //build filter
//                                  filter=new Filter();
//                                  filter.setSelector("#D_filter");
//                                  filter.createFilter();
                                 
                                  $("#main").css("display","block");
//                                  if('function' == typeof(adjustFooter)){
//                                      adjustFooter();
//                                  }
                                  /**
                                   *@todo repasser makedatagrid sur chaque page
                                   **/
                                  if('function' == typeof(makeDataGrid)){makeDataGrid()};
                                  
                                   //send dom ready
                                  $(window).trigger("domReady");
                                  
                                  // hide preloaders
                                  $("#preloader").css("display","none");
                                  

                                  
                              },
                              error: function (xhr, ajaxOptions, thrownError) {
                                    alert(xhr.status);
                                    alert(thrownError);
                              }
    
                         })    
                    }else{
                        if(filter){
                            /**
                             * appel du filtre sur page acceuil request html
                             * on doit recharger la page accueil avec ajax
                             * pour mettre les données a jour
                             */
                            var data={"filter":filter.getChecked()};
                            var url="/accueil/index/format/html";
                                   $.ajax({
                              url:url,
                              data:data,
                              type:"POST",
                              success:function(data){
                         
                                  //console.log("data",data)
                                  //supprime les tool tip , les dialog qui s'accumule
                                  trashHtml();
                                  
                                  deletePagecontent();
                                  
                                  $("#canvas_siloNav").css("display","block");
                                  
                                  $("#main").append(data);
                                  
                                  //build filter
//                                  filter=new Filter();
//                                  filter.setSelector("#D_filter");
//                                  filter.createFilter();
                                 
                                  $("#main").css("display","block");
                                  if('function' == typeof(adjustFooter)){
                                      adjustFooter();
                                  }
                                  /**
                                   *@todo repasser makedatagrid sur chaque page
                                   **/
                                  if('function' == typeof(makeDataGrid)){makeDataGrid()};
                                  
                                   //send dom ready
                                  $(window).trigger("domReady");
                                  
                                  // hide preloaders
                                  $("#preloader").css("display","none");
                                  

                                  
                              },
                              error: function (xhr, ajaxOptions, thrownError) {
                                    alert(xhr.status);
                                    alert(thrownError);
                              }
    
                         }) 
                           
                            return;
                        }
                        
                    }
     
            })
            
}()
/**
 * @todo cette function ne semble pas appellée
 */      
function showcontent(){
    alert("show content a supprimmer car ne semble pas call")
    //traitement 
//create silo global   
//("silo data from ajax",siloData.cellules.cellule[1]);  
createDSilo(siloData.cellules.cellule[1]);
//call create silo detail
createSilo("canvasCellFermes",1000,300,null,null,null,null,"setGlobal",false,[cellules]);
    
    
}

// format les tableau pour centrer les dates 

function bzCenter(args) {
            var pattern=/^date|^N°/gi;
            if ((args.row.type & $.wijmo.wijgrid.rowType.dataAlt) || (args.row.type & $.wijmo.wijgrid.rowType.data)) {
                if (args.column != null) {
                        //change text color of entire column
                        if (args.column.headerText.match(pattern)) {
                                args.$cell.css("text-align", "center");
                        }
                }
            }
}

// gestion iframe errreur téléchargement

$("#ifr_download").css("display","none");
function downloadError(retour){
    //alert("reotur"+retour)
    $("#ifr_download").slideUp('slow', function() {
// Animation complete.
});
}

function showErrorMessage(){
    window.scrollTo(0,0);
    $("#showDonwloadError").slideDown("slow");
}




