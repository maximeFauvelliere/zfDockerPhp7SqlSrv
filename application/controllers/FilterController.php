<?php

/**
 * affichage du filtre 
 */
class FilterController extends Zend_Controller_Action {

    private $_bzfilter;
    private $_db;
    //idgrgc
    private $_idBzUser;
    private $_ip;
    private $_session;
    private $_filterParam;
    private $_camp;
    private $_cultures;
    private $_structures;
    private $_param;

    public function init() {
        
       /**
        * pas besoin de session over a ce niveau car retourne message ds filtre
        * le session over e fera par le controller a suivre 
        */

        $this->_session = Zend_Registry::get("bzSession");
        $this->_idBzUser = $this->_session->idBzUser;
        $this->_ip = $this->_session->_ip;
        $this->_db = Zend_Registry::get("db");

        $ajaxContext = $this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                    ->addActionContext('record','html')
                    ->setAutoJsonSerialization(false)
                    ->initContext();


        /**
         * 0->filtre temp
         * 1->filtre ma selection
         * 2->enregistrement selection
         */
        $this->_filterParam = $this->getRequest()->getParam("filter");
        
        /**
         *@todo voir traitement erreur si camp n'existe pas 
         */
        $this->_camp = $this->getRequest()->getParam("camp");
        
        //Zend_Debug::dump($this->_filterParam,"param send");
        //Zend_Debug::dump($this->_camp,"camp");


      
    }

    public function indexAction() {
          try {
            $stmt = $this->_db->prepare("execute ps_ExtWFilterGet @idgrgc=$this->_idBzUser,@param='$this->_filterParam',@campselec=$this->_camp,@ip='$this->_ip'");
            //$this->_helper->LogPs("FilterController :ps_ExtWFilterGet @idgrgc,@param,@campselec,@ip");
            $stmt->execute();

            $result = $stmt->fetchAll();

            $data = $result[0][""];

            $this->_bzfilter = new SimpleXMLElement($data);
            //Zend_Debug::dump($result,"bzFilter xml");
            
        }catch (Exception $e) {
            
            //Zend_Debug::dump($result,"retour base");
            
        }
        
        $this->view->bzfilter = $this->_bzfilter;
        
    }
    
    public function recordAction(){
        
        
        
        
        $this->_filter=$this->getRequest()->getParam("filter")?$this->getRequest()->getParam("filter"):null;
        
        
        
        
        
        if(!$this->_filter){
           /**
            *triatement de cette erreur si appel acc sans filtre retourner filtre initial
            * a prtir de la session
            * donc enregistrer le filtre initial en session 
            */ 
            
            
        }
        
        $this->_camp=$this->_filter["camp"];
        $this->_cultures=$this->_filter["cultures"];
        $this->_structures=$this->_filter["structures"];
        
        
        
        
         try {
            $stmt = $this->_db->prepare("execute ps_ExtWFilterSet @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=2,@ip='$this->_ip'");
            //$this->_helper->LogPs("FilterController :ps_ExtWFilterSet @idgrgc,@camp,@cultures,@structures,@param,@ip");
            $stmt->execute();

            $result = $stmt->fetchAll();

            $data = $result[0][""];
            
            $this->view->isRecording=$data;
            return;
            
            //Zend_Debug::dump($this->_bzfilter,"bzFilter xml");
        } catch (Exception $e) {
            
        }
        
        $this->view->isRecording=false;
        
    }

}

?>
