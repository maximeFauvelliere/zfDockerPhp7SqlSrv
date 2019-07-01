<?php

class ExecutionController extends Zend_Controller_Action
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
                    ->addActionContext('previsionnel','html')
                    ->addActionContext('accueil','html')
                    ->addActionContext('historique','html')
                    ->addActionContext('encours','html')
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
        if(! $this->_acl->isAllowed($this->_role,'execution','index')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        /**
         * @todo  faire plugin config
         */
        $this->view->pageSize=5;
        
        $this->view->controller="execution";
    }
    
    public function indexAction(){
        
        $this->view->action="index";
        // action precedente = forward  on envois un message
        if($this->getRequest()->getParam('message')){
            $this->view->message=$this->getRequest()->getParam('message');
        }
       
       
        $stmt = $this->_db->prepare("execute ps_ExtWAcc @idgrgc='$this->_idBzUser',@code='EXE',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
        
           try{
           $stmt->execute();
           $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
           
                echo $e->getMessage();
              }
        
           
            //Zend_Debug::dump($result,"result from sql");
           
           /**
             * traitement erreur retour sql
             * placer ici pour eviter d'avoir a reconstruire le tableau 
             * pour $this->data
             */
            if($result[0]['erreur']){
                $this->_data='<cellules>
                                <cellule titre="Historique" img=""></cellule>
                                <cellule titre="En cours" img=""></cellule>
                                <cellule titre="Prévisionnel" img=""></cellule>
                             </cellules>';
            }else{
                /**
                *@todo faire tres attention car se base sur nom du xml comme une chaine vide 
                * il serait bien de regler se problème, pour etre sur que cela ne pose pas
                * de soucis pour le suite. 
                */
                if(count($result)){
                    $this->_data=$result[0][""];
                }else{
                    $this->_data=null;
                }
                
                if(! $this->_acl->isAllowed($this->_role,'execution','index')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
                
            }

            //Zend_Debug::dump($this->_data,"data brutes");
            
            try{
                $this->view->data=Zend_Json::fromXml($this->_data,false);
            }  catch (ErrorException $e){
                
            }
           
          
           
           $this->renderScript("/execution/accueil.ajax.tpl");
    }
    
    public function previsionnelAction(){
      
        if(! $this->_acl->isAllowed($this->_role,'execution','previsionnel')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        $this->view->action="previsionnel";
        
        $stmt = $this->_db->prepare("execute ps_ExtWEprevi @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
           
           
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
             
               if(!$result[0][""]){
                  /**
                   * @todo revoir le cas du xml nul (pas de données), 
                   * preferer un  retour XML du <cellules><cellule></cellule></cellules>
                   */
                 /*$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 $this->_forward("index");
                 return;*/
            }
              
           if(count($result)){
                $this->_data=$result[0][""];
            }else{
                $this->_data=null;
            }
            
             //Zend_Debug::dump($result,"result from ps_ExtWEprevi");
            
            try{
                
                //$this->view->data=Zend_Json::fromXml($this->_data,false);
                $this->view->data=Zend_Json::fromXml($this->_data,false);
                
            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                $this->_forward("index",null, null, array('message'=>"Il n'y a pas de prévisionnel."));
            }
            
            
    }
    
    public function historiqueAction(){
        
        if(! $this->_acl->isAllowed($this->_role,'execution','historique')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $this->view->action="historique";
        
                
        $stmt = $this->_db->prepare("execute ps_ExtWEhistorique @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
           
           
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
              
            if(!$result[0][""]){
                //attention le retour XML peut etre null dans cas cellule
                 /*$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 $this->_forward("index");
                 return;*/
            }
              
           if(count($result)){
                $this->_data=$result[0][""];
            }else{
                $this->_data=null;
            }
            
            //Zend_Debug::dump($result,"xml from sql");
            
            try{
                
                //$this->view->data=Zend_Json::fromXml($this->_data,false);
                $this->view->data=Zend_Json::fromXml($this->_data,false);
                
            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                $this->_forward("index",null, null, array('message'=>"Il n'y a pas d'historique."));
            }
            
            
    }
    
    public function encoursAction(){
        
        if(! $this->_acl->isAllowed($this->_role,'execution','encours')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        $this->view->action="encours";
        
                
        $stmt = $this->_db->prepare("execute ps_ExtWEcours @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
           
           
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
        
            //Zend_Debug::dump($result,"result from ps_ExtWEcours");
             if(!$result[0][""]){
                 
            }
            
            if(count($result)){
                $this->_data=$result[0][""];
            }else{
                $this->_data=null;
            }
            
            try{
                
                //$this->view->data=Zend_Json::fromXml($this->_data,false);
                $this->view->data=Zend_Json::fromXml($this->_data,false);
                
            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                $this->_forward("index",null, null, array('message'=>"Il n'y a pas d'en cours."));
            }
            
    }
    

}

