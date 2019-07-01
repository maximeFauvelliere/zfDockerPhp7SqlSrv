/**
 * objet optimize
 **/
function Optimise(objR,cellule,data){
    
    /*console.log(objR)
    console.log(cellule);
    console.log(data);*/
    //return;
    
    
    // objet graphique raphael
    this.objR=objR;
    //objet graphique cellule
    this.cellule=cellule;
    //data optimise
    this.optData=data;
    //startx
    this.startX=cellule.attr("x");
    //posY
    this.posY=cellule.attr("y")-25;
    //this.delaX
    this.deltaX;
    
    // opitmise
    this.optimise;
    
    
    
    
    this.setOptimise=function(deltaX){
        
        this.optimise=objR.rect(this.startX,this.posY,20,20);  
        
        if(deltaX){
          
            this.optimise.attr("x",deltaX);
        }
      
        this.optimise.attr("fill","red");
      
        delatX=this.optimise.attr("width")+this.optimise.attr("x");
      
        return delatX;
    }
    
   
    
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
    this.minHeight=15;
    //text inside
    this.hasTxt=true;
    //text caracteristique
    this.textFeature={};
    
    //delta Y
    this.deltaYCult;
    
    //met l'objet en arriere
    this.toBack=false;
    
    this.paddingSide=paddingSide?paddingSide:0;
    
    this.paddingBottom=paddingBottom?paddingBottom:0;
    
    
 
    
    this.createCulture=function(toback,deltaY){
        
        

        this.toBack=toback?toback=toback:toback=this.toBack;
       
        this.posX=this.cellule.attr("x")+this.paddingSide;
        
        
       
        this.wCult=this.cellule.attr("width")-(this.paddingSide*2);

        /*
         *calcul hauteur
         *check hauteur mini
         */
        if(this.hCult<this.minHeight){
            
            /*
             *@todo laissé de cote pour l'instant prefernce a l'affichage réel.
             */
            // this.hCult=this.minHeight;
           
            //pas de  zone de text
            this.hasTxt=false;
        }
        
        /*
         *empilement cultures
         *
         */
       
       
        
        if(deltaY){
            ("deltaY : "+deltaY+" hcult: "+this.hCult);
            this.posY=deltaY-this.hCult;
            
        }else{
            ("pas de deltaY : "+deltaY+" hcult: "+this.hCult);
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
        
        console.log("shape width",shapeWidth);
        
        
        if(this.hasTxt){
            
            var zoneTxt=this.objR.set();

            //positionne le premier text
            var txtNom=this.objR.text(textX,textY,this.nomCult+"\n"+this.qt+" t").attr(this.textFeature);

            
            
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
       
        ("shapeY: "+shapeY);
        ("shapeHeight: "+shapeHeight);
        
        (this.idCult);
        
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
    //optimise
    this.hasOptimise=false;
    //securise
    this.hasSecurise=false;
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
    
    

    this.createCellule=function(idCell,x,y,w,h,faceLeft,data,isFront,hasClick,hasCellDetail){
        
        ("cellule",data);
        
     
        
        this.x=x?x:this.xcell;
        this.y=y?y:this.yCell;
        this.w=w?w:this.wCell;
        this.h=h?h:this.hCell;
        this.idCell=idCell.toString();
        this.cellData=data;
        this.hasCellDetail=hasCellDetail;
        this.taux=0.48;
        
        
        (this.cellData)  ;
        
        isFront?this.isFront=isFront:false;
        hasClick?this.hasClick=hasClick:false;
        
        //remplissage cellule bidon pour transparence
        this.fcolorCell="#000";
        
        //rectangle
        var deltaHeightCell=(this.w-(this.w*this.taux));
        this.cellule= this.paper.rect(this.x,this.y,this.w,this.h);
        
        
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
        
        ("cell width",this.cellule.attr("width"));
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
        if(faceLeft===true && this.idCell==0){
            
            
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
        ("title celle data",this.cellData['@attributes'].titre);
        
       
        if(this.cellData['@attributes'].titre)
        {
            var title=this.cellData['@attributes'].titre;
            var img=this.cellData['@attributes'].img;
               
            
               
            (pattern.test(title));

            if(img){

                try{
                    var c = this.paper.image("/images/metier/"+img, this.cellule.attr("x")+20,this.cellule.attr("y")+10, 50, 20);

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
        
        
        
        
        ("les cultures ",lesCultures);

        if(lesCultures){
              
               
              
            if(!$.isArray(lesCultures.culture)){
                    
                lesCultures.culture=[lesCultures.culture];
                    
            ("culture is not an array",lesCultures.culture);
            }

            for(var c in lesCultures.culture ){
                    
                ("une culture ",lesCultures.culture);
                // @todo vois ce +c si accicdent
                Culture.call(this,this.paper,this.cellule,this.idCell+"_"+c,this.paddingBottom,this.paddingSide);

                this.nomCult=lesCultures.culture[c]['@attributes'].nom;
                //quantite
                this.qt=lesCultures.culture[c]['@attributes'].valeur;

                // hauteur du block culture proportionellement
                var pHeight1=this.cellule.attr("height")-this.paddingBottom;
                this.hCult=(pHeight1*lesCultures.culture[c]['@attributes'].ratio)/100;

                //affectation couleur de la culture
                this.fcolorCult=lesCultures.culture[c]['@attributes'].color;

                //plusieurs culture dans meme cellule
                if(c>0){
                        
                    var deltaY=this.createCulture(true,deltaY);

                }else{

                    var deltaY=this.createCulture(true);

                }

            }
        }
    }
    
    //ajout le global a la cellule
    this.setGlobal=function(){
       
        // console.log("global cellule :",this.cellData);
       
        
        
        var cellule=this.cellData;
        

        
        if(cellule.global){
            //for(var c in cellule.global['@attributes'] ){
            for(var c in cellule.global){

                Culture.call(this,this.paper,this.cellule,this.idCell+"_idCult",this.paddingBottom,this.paddingSide);
                    
                    
                //pour un global pas de nom
                this.nomCult="Global";
                //quantite
                this.qt=cellule.global['@attributes'].valeur;

                // hauteur du block culture proportionellement
                var pHeight1=this.cellule.attr("height")-this.paddingBottom;
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
        
        alert("setContrat");
    }
    
    //ajoute les offre commerciales
    this.setOffreCom=function(data){
        
        
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
          
        //regle proble si un objet, non reprsenter en tableau
        if(!$.isArray(data.culture)){
              
            data.culture=[data.culture];
              
        }
          
          
          
        var culture=data.culture;
         
         
        ("getcellDetail @attr",culture[0]['@attributes'].valeur);
        
          
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




function Silo(paper,hasRoof){
    
    this.paper=paper;
    this.nbCellules;
    this.setSilo = this.paper.set();
    
    this.siloWidth=null;
    this.heightRoof=25;
    
    this.startX=50;
    this.startY=50;
    this.hasRoof=hasRoof;
    
    this.cellHeigh=null;
    this.cellWidth=null;
    
    
    
    this.hasRoof=true;
    //this.siloRoof=null;
    this.roofStrokeWidth=1;
    this.roofStroke="#C7C1B8";

    /**
     * creer  les cellules du "silo" et les ordonnent
     */
    this.addCellule=function(startX,y,w,h,myObject,methode,callBackCelluleClick,isFront,data){
        
        this.cellHeigh=h;
        this.cellWidth=w;
        this.startY=y;
        
        
        
        /**
         * ajoute les cellules au silo et creez le decalage en x
         */
        //initialise startX
        startX?startX=startX:startX=this.startX;
        
        
        
        ("addcellule  data[0]:",data);
            
            
        try{
            desCellules=data[0].cellules.cellule;
        }catch(e){
            (data[0].cultures);
            desCellules=[data[0]];
        }  
                
            

        ("des cellules ",desCellules);
           
        (desCellules.length);
           
        (($.isArray(desCellules)));
           
           
        if(!$.isArray(desCellules)){
            
            desCellules=[desCellules];
        }
        
        ("cellules length : ",desCellules.length);

        //boucle sur les cellule
        for(i=0; i<=desCellules.length-1;i++){


            /**
             * draw only cellule
             */
            
            (data[i]);
            // call construct
            Cellule.call(this,this.paper,true);
            
                var padding=7;
                this.setPaddingBottom(padding);
                this.setPaddingSide(padding);
           

            
            //condition pour la derniere cellule ajouté (permet de finir la perspective)
            if(i==desCellules.length-1){
                
                if(this.setSilo.length>0){
                   
                    var x=startX+(this.setSilo[0].attr("width")*(i))
                }
                
                
                // ajoute la cellule au set
                //function(idCell,x,y,w,h,faceRight,data,isFront,hasClick,hasCellDetail)
                this.setSilo.push(this.createCellule(i,x,y,w,h,true,desCellules[i],isFront,callBackCelluleClick,"culture"));

                //remplis la cellule
                if(myObject && methode){
                    
                    myObject[methode]();
                }
                
                //roof for last cell
                //last side
                var lastX=x;
                var deltaX=(this.cellWidth-(this.cellWidth*0.48));
                var deltaY=deltaX;
                
                
              ("lastX+this.cellWidth",lastX+this.cellWidth);
              ("this.startY",this.startY);
              ("-(this.cellWidth)+deltaX",-(this.cellWidth)+deltaX);
              ("-deltaY",-deltaY);
              ("deltaX/2",deltaX/2);
              
              
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
                this.setSilo.push(this.createCellule(i,x,y,w,h,false,desCellules[i],true,callBackCelluleClick,"culture"));
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
    
  
}

 


