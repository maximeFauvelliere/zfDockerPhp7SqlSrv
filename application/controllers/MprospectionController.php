<?php

class MprospectionController extends Zend_Controller_Action
{
    // idgrgc
    private $_idBzUser;
    //acl
    private $_acl;
    private $_role;
    // identifiant 
    private $_bzUser;
    private $_session;
    private $_ip;
    private $_db;
    
    private $_data;
    
    private $_filter;
    private $_camp;
    private $_cultures;
    private $_structures;
    
    

    public function init()
    {
        
        //session timeover
        $this->_helper->Timeover($this->getRequest());

        $this->_session=  Zend_Registry::get("bzSession");
        $this->_idBzUser=$this->_session->idBzUser;
        $this->_ip=$this->_session->_ip;
        $this->_bzUser=$this->_session->bzUser;
        $this->_db=  Zend_Registry::get("db");
        
        
 
        
        /*
        //acl
        $this->_acl=$this->_session->_acl;
        $this->_role=  $this->_session->_role;
        */
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                    ->addActionContext('depots','html')
                    ->addActionContext('ferme','html')
                    ->setAutoJsonSerialization(false)
                    ->initContext();
        
        $this->_filter=$this->getRequest()->getParam("filter")?$this->getRequest()->getParam("filter"):null;
        
         // si pas de filtre en requete on utilise celui de la  session si il existe    
         if(!$this->_filter){
           
             if($this->_session->_filter){
                 $this->_filter=$this->_session->_filter;
             }else{
                 /**
                  * @todo faire traitement erreur
                  */
            }
             
        }

        $this->_camp=$this->_filter["camp"];
        $this->_cultures=$this->_filter["cultures"];
        $this->_structures=$this->_filter["structures"];
        $this->_param=  $this->_filter["modify"]?0:2;
        
  
        
    }
    
    public function indexAction(){
       
    }
    
    public function depotsAction(){

   

        $stmt = $this->_db->prepare("execute  ps_ExtWPSDepotM @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
 
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                //echo $e->getMessage();
              }
            
              
           //Zend_debug::dump($result,"ps_ExtWAcours1");
            if(!$result[0][""]){
                 //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 //$this->_forward("index");
                 //return;
            } 
            
        
$xml="<root>
   <depots>
      <structures>
         <element>
            <depot>
               <element>
                  <brut>125</brut>
                  <culture>Blé</culture>
                  <detail>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/05/14</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/05/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/04/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                  </detail>
                  <net>120</net>
               </element>
               <element>
                  <brut>125</brut>
                  <culture>orge</culture>
                  <detail>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere2</com>
                        <date>12/05/14</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere2</com>
                        <date>12/05/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere2</com>
                        <date>12/04/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                  </detail>
                  <net>120</net>
               </element>
               <element>
                  <brut>125</brut>
                  <culture>colza</culture>
                  <detail>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere3</com>
                        <date>12/05/14</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere3</com>
                        <date>12/05/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere3</com>
                        <date>12/04/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                  </detail>
                  <net>120</net>
               </element>
            </depot>
            <titre>EARL bruno 1</titre>
            <soustitre>Ct Blé n° 59991 - 643.76t</soustitre>
         </element>
         <element>
            <depot>
               <element>
                  <brut>125</brut>
                  <culture>Blé</culture>
                  <detail>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/05/14</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/05/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/04/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                  </detail>
                  <net>120</net>
               </element>
               <element>
                  <brut>125</brut>
                  <culture>orge</culture>
                  <detail>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/05/14</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/05/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/04/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                  </detail>
                  <net>120</net>
               </element>
               <element>
                  <brut>125</brut>
                  <culture>colza</culture>
                  <detail>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/05/14</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/05/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/04/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                  </detail>
                  <net>120</net>
               </element>
               <element>
                  <brut>125</brut>
                  <culture>tournesol</culture>
                  <detail>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/05/14</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/05/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/04/13</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                  </detail>
                  <net>120</net>
               </element>
               <element>
                  <brut>125</brut>
                  <culture>mais</culture>
                  <detail>
                     <element>
                        <brut>128</brut>
                        <com>H2O:14.2-PS:74.90 / dep la roussiere1</com>
                        <date>12/05/14</date>
                        <net>125</net>
                        <nvbznb>717Bz60</nvbznb>
                     </element>
                  </detail>
                  <net>120</net>
               </element>
            </depot>
            <titre>EARL bruno 2</titre>
            <soustitre>Ct orge n° 59981 - 643.76t</soustitre>
         </element>
      </structures>
   </depots>
</root>";
            try{
                
                $array = (array)simplexml_load_string($result[0][""]);
                //$array = (array)simplexml_load_string($xml);
                $this->_helper->json($array);
                
            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas de prévisionnel."));
            }
            
         
        
    }
    
    public function fermeAction(){
       
       /* if(! $this->_acl->isAllowed($this->_role,'administration','historique')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }*/

        $stmt = $this->_db->prepare("execute ps_ExtWPSFlotsM @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");

           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                //echo $e->getMessage();
              }
        
              if(!$result[0][""]){
                 //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 //$this->_forward("index");
                 //return;
            }
        
        $xml="<root>
   <ferme>
      <structures>
         <element>
             <titre>EARL bruno 1</titre>
            <lots>
               <element>
                  <culture>Blé</culture>
                  <poids>120</poids>
                  <surface>43</surface>
                  <solde>43000</solde>
                  <detail>
                     <element>
                        <nom>Blé 13</nom>
                        <com>H2O:14.2-PS:74.90</com>
                        <type>galibier</type>
                        <solde>43000</solde>
                     </element>
                  </detail>
               </element>
                <element>
                  <culture>Blé</culture>
                  <poids>120</poids>
                  <surface>45</surface>
                  <solde>43000</solde>
                   <detail>
                     <element>
                        <nom>Blé 14</nom>
                        <com>H2O:14.2-PS:75</com>
                        <type>galibier</type>
                        <solde>43000</solde>
                     </element>
                  </detail>
               </element>
               
            </lots>
            
         </element>
         <element>
             <titre>EARL bruno 2</titre>
            <lots>
               <element>
                  <culture>Blé</culture>
                  <poids>120</poids>
                  <surface>46</surface>
                  <solde>43000</solde>
                    <detail>
                     <element>
                        <nom>Blé 14</nom>
                        <com>H2O:14.2-PS:75</com>
                        <type>galibier</type>
                        <solde>43000</solde>
                     </element>
                  </detail>
               </element>
             
               
            </lots>
            
         </element>
       
      </structures>
   </ferme>
</root>";

            try{
                $array = (array)simplexml_load_string($result[0][""]);
                //$array = (array)simplexml_load_string($xml);
                $this->_helper->json($array);
 
            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas d'historique."));
            }
            
         
        
    }
    
   
    
    
    
    
    


   

}

