/**
 * objet optimize
 **/
/**
 *attention avec call le premier parametre n'apparait pas c'est l'objet appelant
 */
function Optimise(objR,cellule,data,global){
    
    ("cellule data",cellule.data("dataCell")['@attributes'].titre);
     ("this.cellule",cellule);
     ("opti data",data);
     ("isGlobal",this.isGlobal);
     ("paper",objR);
   // ("data",d);
    //return;
    
    
    
    
   
    //data optimise
    var dataOpt=data;
    //startx
    var startXOpt=cellule.attrs.x;
    //posY
    var posYOpt=cellule.attrs.y-20;
    
    //contrat lié a l'optimise
    var contrat=cellule.data("dataCell")['@attributes'].titre.toLowerCase();
    
    // opitmise
    this.optimise;
    
    ("dataOpt",dataOpt);
    
   (function setOptimise(){
       
       
       ("data in cell dataCell",cellule.data("dataCell"));
       var deltaX=null;
       //create optimiz global
       if(global){
           
           ("ratio",cellule.data("dataCell").optimiz['@attributes'].ratio);
           ("color",cellule.data("dataCell").optimiz['@attributes'].color);
           ("dataOpt",dataOpt);
           var thiswidth=parseInt(cellule.attrs.width*cellule.data("dataCell").optimiz['@attributes'].ratio)/100;
           this.optimise=objR.rect(startXOpt,posYOpt,thiswidth,20);
           this.optimise.attr("fill",cellule.data("dataCell").optimiz['@attributes'].color);
           this.optimise.click(function(){
               if(typeof optimizGlobalAction == 'function'){
                   optimizGlobalAction(contrat);
               }else{
                   alert("pas de function");
               }
               
           })
           return;
       }

        // create optimiz par culture
        
        $.each(dataOpt,function(i,e){
            //("dataOpt",dataOpt[i]);
            // largeur proportionnelle
            var thiswidth=parseInt(cellule.attrs.width*dataOpt[i].ratio)/100;
            // construction graphique de l'objet optimise'
            this.optimise=objR.rect(startXOpt,posYOpt,thiswidth,20);  
            //("deltaX1",deltaX);
            if(deltaX){
                //("deltaX true")
                this.optimise.attr("x",deltaX);
            }

            this.optimise.attr("fill",dataOpt[i].color);

            deltaX=parseInt(this.optimise.attr("width"))+parseInt(this.optimise.attr("x"));
            
            //("deltaX",deltaX);
            //("myOptimize",this.optimise);
            //("opti width",this.optimise.attr("width"));
            this.optimise.click(function(e){
                // call function sur fichier ajax getdetailcontrat.ajax.tpl
                getOptimiz(contrat);
            })
            return ;
        
     
 
        })
        
        
    })();
    
    
    
   
    
   
    
}

/**
 * objet optimize
 **/
function Securise(objR,cellule,data){


    
    // objet graphique raphael
    this.objR=objR;
    //objet graphique cellule
    this.cellule=cellule;
    //data optimise
    this.secuData=data;
    //startx
    this.startX=cellule.attr("x");
    //posY
    this.posY=cellule.attr("y")+cellule.attr("height")+15;
    //this.delaX
    this.deltaX;
    
    // opitmise
    this.securise;

    this.setSecurise=function(deltaX){
        
        this.securise=objR.rect(this.startX,this.posY,20,20);  
        
        if(deltaX){
          
            this.securise.attr("x",deltaX);
        }
      
        this.securise.attr("fill","yellow");
      
        delatX=this.securise.attr("width")+this.securise.attr("x");
      
        return delatX;
    }
    
}



/**
 *  objet graphique culture
 *  @param objR raphael paper
 *  @cellule objet raphael rec cellule
 *  @idCult int id culture
 *  @cellDetail string html ul => detail de la cellule pour popUp
 *  
 */
function Culture(objR,cellule,idCult,paddingBottom,paddingSide){
   
    // objet graphique raphael
    this.objR=objR;
    //id culture
    this.idCult=idCult;
    //objet graphique cellule
    this.cellule=cellule;

    //quantite
    this.qt;
    //nom de la cereale
    this.nomCult;
    //position X
    this.posX;
    // posiltion y
    this.posY;
    //largeur
    this.wCult;
    //hauteur
    this.hCult;
    //stroke
    this.stroke=null;
    //couleur de remplissage
    this.fcolorCult;
    // color stroke
    this.scolor;
    
    //obj culture
    this.culture;
    
    //min height of culture 
    this.minHeight=23;
    //text inside
    this.hasTxt=true;
    //decalage text
    this.delatXText=false;
    //text caracteristique
    this.textFeature={"font-size":11,"font-family": "Abel,Arial, Helvetica, sans-serif"};
    // has a line
    this.hasLine=false;
    //delta Y
    this.deltaYCult;
    
    //met l'objet en arriere
    this.toBack=false;
    
    this.paddingSide=paddingSide?paddingSide:0;
    
    this.paddingBottom=paddingBottom?paddingBottom:0;
    
    
    this.createCulture=function(toback,deltaY,even){
        
        

        this.toBack=toback?toback=toback:toback=this.toBack;
       
        this.posX=this.cellule.attr("x")+this.paddingSide;
        
        
       
        this.wCult=this.cellule.attr("width")-(this.paddingSide*2);

        /*
         *calcul hauteur
         *check hauteur mini
         */
        if(this.hCult<this.minHeight){
            
            /*
             *@todo sert uniquement pour les decalage de texte mais pas de gestion de hauteur min
             */
             //this.hCult=this.minHeight;
           this.delatXText=true;
            //pas de  zone de text
          //  this.hasTxt=false;
        }
        
        /*
         *empilement cultures
         *
         */
        if(deltaY){
            //("deltaY : "+deltaY+" hcult: "+this.hCult);
            this.posY=deltaY-this.hCult;
            
        }else{
            
            //("pas de deltaY : "+deltaY+" hcult: "+this.hCult);
            //position y calculer apres calcul de hauteur de la culture
            this.posY=this.cellule.attr("y")+this.cellule.attr("height")-this.hCult-this.paddingBottom;
        
        }
        var culture = this.objR.set();
        
        
        
        var shape= this.objR.rect(this.posX,this.posY,this.wCult,this.hCult).attr({
            fill:this.fcolorCult,
            "stroke-width":0
            });
        
        //attribut class
        //debug class
        $(shape.node).attr("class","rvml culture");
        // title pour popup
        $(shape.node).attr("title",this.cellDetail);
        //atribut du rectangle culture
        $(shape.node).attr("id",this.idCult);
        
        
        //position le texte toujours au centre pour la hauteur 
        var shapeHeight=shape.getBBox().height;
        var shapeWidth=shape.getBBox().width;
        var shapeY=shape.getBBox().y;
        var textY=(shapeHeight/2)+shapeY;
        var textX=(shapeWidth/2)+this.posX;
        var textDetailX=false;
        
        
        
        if(this.hasTxt){
            
            
           // var zoneTxt=this.objR.set();
            
            
            var txt;
            // get type de silo <=1 silo pour les globaux >1 silo detail
            if(this.idCult.split("_")[0]<=1){
                
                 txt=this.nomCult+"\n"+this.qt+" t";
                 this.textFeature['text-anchor']="middle";
                 this.textFeature['font-size']=12;
                 
                 if(this.fcolorCult=="#000000"){
                     this.textFeature['fill']="#ffffff";
                 }
                
            }else{
                 this.hasLine=true;
                 textDetailX=true;
                 txt=this.nomCult+" "+this.qt+" t";
                 this.textFeature['text-anchor']="start";
                 
            }

            var txtNom;
            var ligne;
            var test;
            if(this.delatXText && even){
                
                if(this.hasLine){
                    ligne=this.objR.path("M {0} {1} l {2} 0 ",180,textY,25);
                    ligne.attr({'stroke':'#84B819','stroke-width':'2'});
                }
                
                textDetailX?textX=205:null;
               
                 txtNom=this.objR.text(textX,textY,txt).attr(this.textFeature);
               
                
                
            }else{
                
               if(this.hasLine){
                ligne=this.objR.path("M {0} {1} l {2} 0 ",70,textY,50);
                ligne.attr({'stroke':'#ffffff'});
               }
               
                
                 textDetailX?textX=0:null;
                //even?test=0:test+=60;
                txtNom=this.objR.text(textX,textY,txt).attr(this.textFeature);
               
               
                
            }
               
             // ("text box",txtNom.getBBox());
               
           //partie depreciée
            //positionne le premier text
            //var txtNom=this.objR.text(textX,textY,this.nomCult+"\n"+this.qt+" t").attr(this.textFeature);
            

            
            
           // var textXdiff=(txtNom.getBBox().width)/2;
            //txtNom.attr("x",this.posX+textXdiff+20);
            

            //positionne le second texte
           // var txtXdiffQt=(txtNom.getBBox().x+txtNom.getBBox().width);
           // var txtQt=this.objR.text(0,textY," - "+this.qt).attr(this.textFeature);
           // txtQt.attr("x",txtXdiffQt+(txtQt.getBBox().width)/2);

            //set txt
            //zoneTxt.push(txtNom);
            //zoneTxt.push(txtQt);
            //set culture
            //culture.push(zoneTxt);
        }
        
        //toback
        if(this.toBack){
            shape.toBack();
        }
        
        culture.push(shape);
       
        //("shapeY: "+shapeY);
        //("shapeHeight: "+shapeHeight);
        
        //(this.idCult);
        
        return this.posY;
        
        
        
        
    }
    
    
};



/**
 * objet cellule recois 1 ou des cultures/1 ou des offre commerciales
 * 
 */
function Cellule(paper){

    // canvas raphael
    this.paper=paper;
    
    //cellule
    this.cellule=null;
    
    //id cellule
    this.idCell;

    this.color="#000";
    // les data de la cellule culture offre commerciale optimize et securise
    this.cellData;
    //detail cellule
    this.hasCellDetail=false;
    //la cellule est en front z-index max
    this.isFront=false;
    //la cellule e t'elle un click
    this.hasClick=false;
    //offre commerciale lié a cette cellule
    this.hasOffreCom;
    //isGlobal
    this.isGlobal=false;
    //optimise
    this.hasOptimiz=false;
    //securise
    this.hasSecuriz=false;
    //--------cellule---------------
    //stroke cellule
    this.strokeCell="#C7C1B8";
    // cellule stroke width
    this.wCellStroke=5;
    //-------------top face---------
    // stroke top face
    this.strokeTopface=this.strokeCell;
    // width stroke top face
    this.WTopface=3;
    //----------left face------------
    //fil left face
    this.fLeftFace="#928782";
    //stroke left face
    this.sLeftFace="#928782";
    //padding cellule
    this.paddingBottom=0;
    this.paddingSide=0;
    
    //icones cellule
    this.cellIcons={};
    
    this.hasTitle=true;
    
    //initialise position and size
    this.xcell=100;
    this.yCell=100;
    this.wCell=85;
    this.hCell=295;
    
    
    
    
    //title
    /**
     *@todo voir se this.title=true??????
     */
    //this.title=true;
    
    
    

    this.createCellule=function(idCell,x,y,w,h,faceLeft,data,isFront,hasClick,hasCellDetail,hasTitle){
        
        ("cellule 1",data);

        this.x=x?x:this.xcell;
        this.y=y?y:this.yCell;
        this.w=w?w:this.wCell;
        this.h=h?h:this.hCell;
        this.idCell=idCell.toString();
        this.cellData=data;
        this.hasCellDetail=hasCellDetail;
        this.taux=0.48;
        this.hasTitle=hasTitle?this.hasTitle:hasTitle;
        
        //(this.cellData)  ;
        //("this.hasTitle",this.hasTitle);
        isFront?this.isFront=isFront:false;
        hasClick?this.hasClick=hasClick:false;
        
        //remplissage cellule bidon pour transparence
        this.fcolorCell="#000";
        
        //rectangle
       //var deltaHeightCell=(this.w-(this.w*this.taux));
       //this.cellule= this.paper.rect(this.x,this.y,this.w,this.h+this.paddingBottom);
        this.cellule= this.paper.rect(this.x,this.y,this.w,this.h+(this.paddingBottom*2));
        
        
        
        //fill cell
        this.cellule.attr({
            fill:this.fcolorCell
            });
        this.cellule.attr({
            fill:this.fcolorCell,
            "fill-opacity":0,
            "stroke-width":this.wCellStroke,
            "stroke":this.strokeCell,
            "stroke-opacity": 1
        });

        //left face
        //top face
        var startPath1X=this.x;
        var startPath1Y=this.y;
        var pWidth1=this.cellule.attr("width");
        var pHeight1=this.cellule.attr("height");
        
        //leftFace
        //point depart - correction
        var startPath2X=this.x-2;
        var startPath2Y=this.y;
        
        //("cell width",this.cellule.attr("width"));
        //perspective
        // delta largeur de la cellule /2
                
        var deltaX=-(this.cellule.attr("width")-(this.cellule.attr("width")*this.taux));
        var deltaY=(this.cellule.attr("width")-(this.cellule.attr("width")*this.taux));
        
        this.cellule.x=this.cellule.x+deltaY;

        //draw faces
        
        //this.pathTopFace=this.paper.path("M {0} {1} l {2} {3} l {4} 0 l {5} {6} z ",startPath1X,startPath1Y,deltaX,-deltaY,pWidth1,-deltaX,deltaY);
        //new version under
        this.pathTopFace=this.paper.path("M {0} {1} l {2} {3} l {4} 0 l {5} {6} z ",startPath1X+1,startPath1Y,deltaX+1,-deltaY,pWidth1,-deltaX,deltaY);
        this.pathTopFace.attr({
            fill:"#000000",
            "fill-opacity":0,
            stroke:this.strokeTopface,
            "stroke-width":this.WTopface
            });  
        faceLeft=true;   
        
        if(faceLeft===true && idCell.split("_")[1]==0){
            
            
            this.pathRightFace=this.paper.path("M {0} {1} l {2} {3} l 0 {4} l {5} {6} z",startPath2X,startPath2Y,deltaX,-deltaY,pHeight1,-deltaX,deltaY);
            this.pathRightFace.attr({
                fill:this.fLeftFace,
                stroke:this.sLeftFace
                });
            
        }

        if(hasCellDetail){
            
            try{
                //ajoute la class  cellule active si popup au noeud rvml ajouter seulement pour bug IE8
                $(this.cellule.node).attr("class","rvml cellule active");
                
                //ajoute un attribut title au noeud svg si cellule contient culture
                $(this.cellule.node).attr("title",this.getCellDetail(this.cellData.cultures,this.cellule.node));
                
                
            }catch(error){
                
            }

        }else{
            
            //ajoute la class cellule
            $(this.cellule.node).attr("class","rvml cellule");
        }
        
        
        //title
        //("title celle data",this.cellData['@attributes'].titre);
        
       
        if(this.cellData && this.cellData['@attributes'] && this.cellData['@attributes'].titre && this.hasTitle)
        {
            //("titre",this.cellData['@attributes'].titre);
            var title=this.cellData['@attributes'].titre;
            var img=this.cellData['@attributes'].img;
               
               
            
               
            //(pattern.test(title));

            if(img){

                try{
                    var c = this.paper.image("/images/metier/"+img, this.cellule.attr("x")+5,this.cellule.attr("y")+10, 65, 47);

                }catch(error){
               
               
                }
            }else{
 
                var t = paper.text(this.x+(this.w/2), this.y+20, title);
            }
        
        }


        //ajoute l'id au noeud
        $(this.cellule.node).attr("id",this.idCell);
        
        // is front
        if(this.isFront){
            
            this.cellule.toFront();
        }
        
        
        
        //affecte les data a l'objet cell
        this.cellule.data('dataCell',this.cellData);
        ("cellData",this.cellData);
        
        
      
        //voir si besoin de creer un event onload sur la cellule
        //$(this.cellule.node).bind("myEvent",function (event){alert("bind cellule complete")});
        
          
        
        // hasClick
        if(hasClick){
           this.cellule.click(
                function(){
                    /*
                     *attention lors du passage de cette fonction , nous somme ds le scope du click
                     *la function est seulement déclarée
                     */
                    //this pour passer l'objet cellule a la fonction
                    //var detail=new Detail();
                    var detail = new Detail();
                    detail.setCellule(this);
                    detail.setIdCell($(this.node).attr("id").toString());
                    detail.getDetail();
                    
                   
                   
                }
                
            )
                
        }
        
        //socle
        if(true){
            //get svg to raphaelM 612.985,392.853 453.264,392.853 386.961,345.146 544.097,345.146 z
            //var path_a = this.paper.path("M 280,300 l-159.721,0 l-66.303,-47.707 l157.136,0 z");
            var path_a = this.paper.path("M 612.985,392.853 453.264,392.853 386.961,345.146 544.097,345.146 z");
            path_a.attr({fill: '#83B81A','stroke-width': '0','stroke-opacity': '1'}).data('id', 'path_a'); 
            var path_b = this.paper.path("M 453.447,408.594 387.28,361.063 387.3,345.189 453.479,392.778 z"); 
            path_b.attr({fill: '#5A7F12','stroke-width': '0','stroke-opacity': '1'}).data('id', 'path_b'); 
            var path_c = this.paper.path("M 453.447,424.078 387.28,376.512 387.3,360.856 453.479,408.445 z"); 
            path_c.attr({fill: '#615046','stroke-width': '0','stroke-opacity': '1'}).data('id', 'path_c'); 
            var rect_d = this.paper.rect(453.461, 392.79, 159.525, 15.667); 
            rect_d.attr({x: '453.461',y: '392.79',fill: '#75A417','stroke-width': '0','stroke-opacity': '1'}).data('id', 'rect_d'); 
            var rect_e = this.paper.rect(453.439, 408.441, 159.537, 15.666); 
            rect_e.attr({x: '453.439',y: '408.441',fill: '#7A665C','stroke-width': '0','stroke-opacity': '1'}).data('id', 'rect_e'); 
            
            
            //convert to 
            var st=this.paper.set();
            st.push(
                path_a,path_b,path_c,rect_d,rect_e
                
            );
            
            ("test path",path_c)
            ("test path",path_c.c)
                
            $.each(st,function(i,e){
                
                if(e.type=="path"){
                    
                    var path=e.attr("path");
                    console.log("path",path)
                    console.log("path test ",typeof(path));
                    
                }
                
                console.log("path",path);
            })
                var x=0;
                var y=0;
                var patht = Raphael.pathToRelative(path_a.attr("path"));
                path_a.attr("path",patht);
                st.translate(-350,-100);
                    
                    console.log("patht",patht)
            

            
        }
        //---------------------------fin socle-------------
        
        //optimize
        if(this.hasOptimiz && this.cellData.optimiz){

            var globalOpti=this.isGlobal;
            
            if(this.cellData.optimiz.contrats){
                
                var lesContrats=this.cellData.optimiz.contrats.contrat;
                
                if(!isArray(lesContrats)){
                    lesContrats=convertToArray(lesContrats);
                }
            }else{
                var lesContrats=null
                
            }
            
           
           var optimize= Optimise(this.paper,this.cellule,lesContrats,globalOpti);
           
            /**
             *voir supprimer methode et attaquer direct ds ds optimises
             **/
            
        }
        
        if(this.hasSecuriz){
            
            
        }
        
        ("cellule",this.cellule);
        return this.cellule;
 
    }
    
    
    /**
    *               add ELEMENTS A LA CELLULE
    *
    * */ 
    // ajoute les cultures a la cellule
    this.setCultures=function(){

        var cellule=this.cellData;
        
        var lesCultures=cellule.cultures;
        
        
         
        
        //("les cultures ",lesCultures);

        if(lesCultures){
              
            if(!$.isArray(lesCultures.culture)){
                    
                lesCultures.culture=[lesCultures.culture];
                    
            //("culture is not an array",lesCultures.culture);
            }
            
            
            
            for(var c in lesCultures.culture ){
             
                // test pair impair
                 var even=(c%2 == 0) ? true : false;
                             
                //("une culture ",lesCultures.culture);
                // @todo vois ce +c si accicdent
                Culture.call(this,this.paper,this.cellule,this.idCell+"_"+c,this.paddingBottom,this.paddingSide);

                this.nomCult=lesCultures.culture[c]['@attributes'].nom;
                //quantite
                this.qt=lesCultures.culture[c]['@attributes'].valeur;

                // hauteur du block culture proportionellement
                var pHeight1=this.cellule.attr("height")-(this.paddingBottom*2);
                this.hCult=(pHeight1*lesCultures.culture[c]['@attributes'].ratio)/100;

                //affectation couleur de la culture
                this.fcolorCult=lesCultures.culture[c]['@attributes'].color;

                //plusieurs culture dans meme cellule
                if(c>0){
                        
                    var deltaY=this.createCulture(true,deltaY,even);

                }else{
                    //dernière cultures
                  var deltaY=this.createCulture(true,null,even);

                }

            }
            //})
        }
    }
    
    //ajout le global a la cellule
    this.setGlobal=function(nomCult){
       
        
       
        //("nom cult1",nomCult);
        
        var cellule=this.cellData;

        
        if(this.cellData && cellule.global){
            //for(var c in cellule.global['@attributes'] ){
            for(var c in cellule.global){

                Culture.call(this,this.paper,this.cellule,this.idCell+"_idCult",this.paddingBottom,this.paddingSide);
                
                    //("nomCult",nomCult);
                //pour un global pas de nom
                //this.nomCult=nomCult?nomCult:"Global";
                this.nomCult=nomCult?nomCult:"";
                //quantite
                this.qt=cellule.global['@attributes'].valeur;
                
                
                // hauteur du block culture proportionellement
                var pHeight1=this.cellule.attr("height")-(this.paddingBottom*2);
                this.hCult=(pHeight1*cellule.global['@attributes'].ratio)/100;

                //affectation couleur de la culture
                this.fcolorCult=cellule['@attributes'].color;

                // créer la culture "global pour les page accueil de rubriques" 
                this.createCulture(true);

            }
        }
        
    }
    
    // ajoute les contrats a la cellules
    this.setContrat=function(data){
        
        // un espace est passé pour ne pas afficher de titre dans la cellule 
        this.setGlobal(" ");
        
    }
    
   
    
    //ajoute les offre commerciales
    this.setOffreCom=function(){
        
        //ajoute icone lock et info
        var cellule=this.cellData;

        //("cellule",cellule);

        // enable or disable  lock
        var isLock=parseInt(cellule['@attributes'].unlock)?false:true;
        
        
        var imgLock=isLock?"D_lock.png":"lock.png";
       
        //("imgLock",imgLock);
        //icones actions
        //check if hasLock
        if(parseInt(cellule['@attributes'].haslock)){
            
            var lock=this.paper.image("/images/metier/"+imgLock, this.cellule.attr("x")+20,this.cellule.attr("y")+20, 24, 30);
            
        }else{
            isLock=true;
        }
        var info=this.paper.image("/images/metier/info1.png", this.cellule.attr("x")+20,this.cellule.attr("y")+80, 24, 30);
        
        //var lock1=this.paper.image("/images/metier/lock1.png", this.cellule.attr("x")+20,this.cellule.attr("y")+20, 50, 50);
        //var info1=this.paper.image("/images/metier/info1.png", this.cellule.attr("x")+20,this.cellule.attr("y")+80, 50, 50);
        
        //icone offre
         if(cellule && cellule['@attributes'].img)
        {
            
            var img=this.cellData['@attributes'].img;
         

            if(img){
                
                try{
                    img=parseInt(this.cellData['@attributes'].checked)?img:"D_"+img;
                    var offre= this.paper.image("/images/metier/"+img, this.cellule.attr("x")+5,this.cellule.attr("y")+170,65,47);

                }catch(error){
               
               
                }
            }
            
        }

        var cellTitle =this.cellData['@attributes'].titre.replace(" ","");
        cellTitle=cellTitle.toLowerCase();
        ("celletitle 2",cellTitle);
        //interaction 
        if(!isLock) $(lock.node).bind("click",function(){getUnlockContrat(cellTitle)});
        
        
        if(parseInt(this.cellData['@attributes'].checked)) $(offre.node).bind("click",function(){getContratsList(cellTitle)});
        
        $(info.node).bind("click",function(){getInfo(cellule['@attributes'].info)});//cellule['@attributes'].info
    

}
    
    //setters
    this.setPaddingBottom=function(paddingBottom){
        
        this.paddingBottom=paddingBottom;
        
    }
    
    this.setPaddingSide=function(paddingSide){
        
        this.paddingSide=paddingSide;
    }
    
    
    /*
     *retourne le content de la cellule sous forme de liste
     *peut etre exploité pour un popUp
     */

    this.getCellDetail=function(data,cellObject){
          
        //secure
        if(!data.culture){
            return null;
        }
          
        //regle probleme si un objet, non representer en tableau
        if(!$.isArray(data.culture)){
              
            data.culture=[data.culture];
              
        }
          
          
          
        var culture=data.culture;
         
         
        //("getcellDetail @attr",culture[0]['@attributes'].valeur);
        
          
        //pas de cultures
        if(!culture[0]){
            $(cellObject).attr("class","rvml cellule")
            };
          
        /**
           *@todo le reotur de culture par la base n'est pas toujours un tableau
           *retounr donc undefined lorqsque le retour ne comprend qu'un seul enregistrement
           *
           **/
        try{
            var result="<ul>";
 
            //detail de la cellule ordre inversé pour la lecture
            for(var c=culture.length-1;c>=0;c--){
                    
                result+="<li>";
                result+=culture[c]['@attributes'].nom+"-"+culture[c]['@attributes'].valeur;
                result+="</li>";
            }

            // temp ordre normale de la liste ds le pop up
            /*for (var c in data.culture){
                    result+="<li>";
                    result+=data.culture[c].nom+"-"+data.culture[c].qt;
                    result+="</li>";
                }*/

            result+="</ul>";

            return result;
        }catch(err){
              
            alert("error popup getCellDetail : "+err.message);
              
        }
         
    }
   
}




function Silo(paper,idRoot,hasRoof){
    
    this.paper=paper;
    this.nbCellules;
    this.setSilo = this.paper.set();
    
    //definit une racine pour l'id des cellule evite les conflits id
    this.idRoot=idRoot;
    
    this.siloWidth=null;
    this.heightRoof=25;
    
    this.startX=50;
    this.startY=50;
    this.hasRoof=null;
    
    this.cellHeigh=null;
    this.cellWidth=null;
    
    this.setDetail=null;
    
    
    
    
    
    this.hasRoof=(hasRoof)?true:false;
    //this.siloRoof=null;
    this.roofStrokeWidth=1;
    this.roofStroke="#C7C1B8";
    
    //this.flagOptimiz=false;
   // this.flagSecuriz=false;

    /**
     * creer  les cellules du "silo" et les ordonnent
     */
    this.addCellule=function(startX,y,w,h,myObject,methode,callBackCelluleClick,isFront,data,hasTitle){
        
        this.cellHeigh=h;
        this.cellWidth=w;
        this.startY=y;
        
       
       
        
        /**
         * ajoute les cellules au silo et creez le decalage en x
         */
        //initialise startX
        startX?startX=startX:startX=this.startX;
        
        
        
        //("addcellule  data[0]:",data);
            
            
        try{
            desCellules=data[0].cellules.cellule;
        }catch(e){
            //(data[0].cultures);
            desCellules=[data[0]];
        }  
                
         //("des cellules 1 ",desCellules); 
        
           
        //(desCellules.length);
           
        //(($.isArray(desCellules)));
           
           
        if(!$.isArray(desCellules)){
            
            desCellules=[desCellules];
        }
        
        //("cellules length : ",desCellules.length);

        //boucle sur les cellule
        for(i=0; i<=desCellules.length-1;i++){
            
            this.nbCellules=i+1;
            //("passage index",i);
            
            /**
             * draw only cellule
             */
            
            var id=this.idRoot+i.toString();
            
            //(data[i]);
            // call construct
            Cellule.call(this,this.paper,true);
            
            //flag pour methode set global permet de diffuser la methode pour optimize et securize
            
            
                methode=="setGlobal"?this.isGlobal=true:null;
            
                var padding=7;
                this.setPaddingBottom(padding);
                this.setPaddingSide(padding);
               
                ("descellule",desCellules);
                // ("descellule",desCellules[i].optimiz);
            ("descellule[i]",desCellules[i]);
           //on verifie si la cellule contient des optimiz ou des securiz
           // on cherhce les optimiz qui se trouvent dans culture
           // conition il faut qu'il y ai des culture pour avoir des optimiz ex :pour les objet sans cultures exemple admin avec pas de encours ou offres
           if(desCellules[i].cultures){

                if(desCellules[i].optimiz && desCellules[i].optimiz.contrats){
                    ("optimiz a true");
                    this.hasOptimiz=true;
                }

                if(desCellules[i].securiz && desCellules[i].securiz.contrats){
                    ("securiz a true");
                    this.hasSecuriz=true;
                }
           }
            
           
            //condition pour la premeire cellule ajouté (permet de finir la perspective)
            if(i==desCellules.length-1){
                
                if(this.setSilo.length>0){
                   
                    var x=startX+(this.setSilo[0].attr("width")*(i))
                }
                
                
                // ajoute la cellule au set
                //function(idCell,x,y,w,h,faceRight,data,isFront,hasClick,hasCellDetail)
                this.setSilo.push(this.createCellule(id,x,y,w,h,true,desCellules[i],isFront,callBackCelluleClick,this.setDetail,hasTitle));
                
                //remplis la cellule
                if(myObject && methode){
                    
                    myObject[methode]();
                }
                
                //roof for last cell
                //last side
                var lastX=x;
                var deltaX=(this.cellWidth-(this.cellWidth*0.48));
                var deltaY=deltaX;
                
                
              //("lastX+this.cellWidth",lastX+this.cellWidth);
              //("this.startY",this.startY);
              //("-(this.cellWidth)+deltaX",-(this.cellWidth)+deltaX);
              //("-deltaY",-deltaY);
              //("deltaX/2",deltaX/2);
              
              
                if(this.hasRoof){
                    var lastSide=this.paper.path("M {0} {1} l {2} {3} l {4} {5} z ",lastX+this.cellWidth,this.startY,-(this.cellWidth)+deltaX,-deltaY,deltaX/2,-20);
                    lastSide.attr({
                        stroke:this.roofStroke,
                        "stroke-width":this.roofStrokeWidth
                        });
                    // fetage
                    var fetage=this.paper.path("M {0} {1} l {2} {3}",startX-(deltaX/2),6,(lastX-deltaX)+this.cellWidth+2,0);
                    fetage.attr({
                        stroke:this.roofStroke,
                        "stroke-width":this.roofStrokeWidth
                        });
                }
                
            }else{
                
                if(this.setSilo.length>0){
                   
                    x=startX+(this.setSilo[0].attr("width")*(i));
                   
                   
                }else{
                    x=startX;
                    
                }
                
                // ajoute la cellule au set
                this.setSilo.push(this.createCellule(id,x,y,w,h,false,desCellules[i],true,callBackCelluleClick,this.setDetail,hasTitle));
                /*
                 * remplis la cellule en appelant la methode adequate dynamiquement
                 * ex :setCulture
                 */
                if(myObject && methode){
                    
                    myObject[methode]();
                }
                
                if(this.hasRoof){
                
                    //toit filaire
                    var deltaX=(this.cellWidth-(this.cellWidth*0.48));
                    var deltaY=deltaX;
                    //face left
                    var leftSide=this.paper.path("M {0} {1} l {2} {3} l {4} {5} z ",this.startX-5,this.startY,-deltaX,-deltaY,deltaX/2,-20);
                    //var leftSide=this.paper.path("M {0} {1} l {2} {3} l {4} {5} ",this.startX-4,this.startY,-deltaX/2,-60,-deltaX+4,25);
                    //var leftSide=this.paper.path("M {0} {1} l {2} {3} L {4} {5} ",this.startX-4,this.startY,-deltaX/2,-60,-deltaX+4,25);
                    leftSide.attr({
                        stroke:this.roofStroke,
                        "stroke-width":this.roofStrokeWidth
                        });
                
                
                }
            }
            
           
            
        }

    }
    
    /**
     *optimiz pour global optimize sur offre BZ
     **/
    this.addGlobalOpti=function(siloWidth,startX,unlock){
        
        /**
         * @todo prevoir parametre pour correction hauteur
         * optiHeight hauteur de l'optimise
         * heightAdjust parametre d'ajustement hauteur
         */
        //hauteur de cellule calculée
        var optiHeight=25
        var heightAdjust=3;
        cellY=this.cellule.attrs.y-optiHeight-heightAdjust;
        
        
        //var globOpti=this.paper.rect(startX,cellY,siloWidth,optiHeight);
        //globOpti.attr("fill","red");
        
        var lockOpti=this.paper.image("/images/metier/optimiz.png",siloWidth/2,cellY-30, 65, 47);
        
        //gestion lock

            var imgLock=!unlock?"D_lock.png":"lock.png";
            
            var lockOpti=this.paper.image("/images/metier/"+imgLock, siloWidth+50,cellY, 24, 30);
            
            //interaction 
            if(unlock) $(lockOpti.node).bind("click",function(){getUnlockOpti()});
       
        
    }
    
  
}


 


