<?php

class MexecutionController extends Zend_Controller_Action
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
        $this->_db=  Zend_Registry::get("db");
        

        
        
        //acl
        $this->_acl=$this->_session->_acl;
        $this->_role=  $this->_session->_role;
        
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                    ->addActionContext('previsionnel','json')
                    ->addActionContext('historique','json')
                    ->addActionContext('historiquedetail','html')
                    ->addActionContext('historiquedetail','json')
                    ->addActionContext('encours','json')
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
        
        // ACL
        /*if(! $this->_acl->isAllowed($this->_role,'execution','index')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }*/
        
       
    }
    
    public function indexAction(){

    }
    
    public function previsionnelAction(){
      
       /* if(! $this->_acl->isAllowed($this->_role,'execution','previsionnel')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }*/
       

        $stmt = $this->_db->prepare("execute ps_ExtWEpreviM @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
      
           
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                //echo $e->getMessage();
              }
             
               if(!$result[0][""]){
               
                 /*$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 $this->_forward("index");
                 return;*/
            }
              
           
            
             //Zend_Debug::dump($result,"result from ps_ExtWEprevi");
            
            try{
                
               $array = (array)simplexml_load_string($result[0][""]);
                $this->_helper->json($array);
                
            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas de prévisionnel."));
            }
            
         
    }
    
    public function historiqueAction(){
        
        /*if(! $this->_acl->isAllowed($this->_role,'execution','historique')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }*/
        

        $stmt = $this->_db->prepare("execute ps_ExtWEhistoriqueM @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
       
           
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                //echo $e->getMessage();
              }
              
            if(!$result[0][""]){
                //attention le retour XML peut etre null dans cas cellule
                 /*$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 $this->_forward("index");
                 return;*/
            }
              
        
            
            //Zend_Debug::dump($result,"xml from sql");
            
            try{
                $array = (array)simplexml_load_string($result[0][""]);
                $this->_helper->json($array);

            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas d'historique."));
            }
            
         
    }
    
    public function historiquedetailAction(){
        
        
        $idct=$this->getRequest()->getParam("idct");
        
        if($this->getRequest()->getParam("format")=="json"){
            
         $stmt = $this->_db->prepare("execute ps_ExtWEhistoriqueMD @idgrgc='$this->_idBzUser',@camp=$this->_camp,@idct='$idct',@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
           
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                //echo $e->getMessage();
              }
              
            if(!$result[0][""]){
                //attention le retour XML peut etre null dans cas cellule
                 /*$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 $this->_forward("index");
                 return;*/
            }
              
        
            
            //Zend_Debug::dump($result,"xml from sql");
            
            try{
                $array = (array)simplexml_load_string($result[0][""]);
                $this->_helper->json($array);
  
            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas d'historique."));
            }
            
        }else{
            $this->view->idct=$idct;
        }
           // format   = html show tpl sans data 
         
    }
    
    public function encoursAction(){
        
       /* if(! $this->_acl->isAllowed($this->_role,'execution','encours')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }*/
        
        $stmt = $this->_db->prepare("execute ps_ExtWEcoursM @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
      
           
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
        
            //Zend_Debug::dump($result,"result from ps_ExtWEcours");
             if(!$result[0][""]){
                 
            }
            
            
            try{
                $array = (array)simplexml_load_string($result[0][""]);
                $this->_helper->json($array);

            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas d'en cours."));
            }
       
    }
    

}

