<?php

/**
 * affichage du filtre 
 */
class MfilterController extends Zend_Controller_Action {

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
        
       //session timeover
        $this->_helper->Timeover($this->getRequest());

        $this->_session = Zend_Registry::get("bzSession");
        $this->_idBzUser = $this->_session->idBzUser;
        $this->_ip = $this->_session->_ip;
        $this->_db = Zend_Registry::get("db");

        $ajaxContext = $this->_helper->AjaxContext;
        $ajaxContext->addActionContext('get','json')
                            ->setAutoJsonSerialization(false)
                            ->initContext();


        /**
         * 0->filtre temp
         * 1->filtre ma selection
         * 2->enregistrement selection
         */
        $this->_filterParam = $this->getRequest()->getParam("filter")?$this->getRequest()->getParam("filter"):0;
        /**
         *@todo voir traitement erreur si camp n'existe pas 
         */
        $this->_camp = $this->getRequest()->getParam("camp");
        
        //Zend_Debug::dump($this->_filterParam,"param send");
        //Zend_Debug::dump($this->_camp,"camp");


      
    }

    public function getAction() {
          try {
            $stmt = $this->_db->prepare("execute ps_ExtWFilterGetM @idgrgc=$this->_idBzUser,@param='$this->_filterParam',@campselec=$this->_camp,@ip='$this->_ip'");
            
            $stmt->execute();

            $result = $stmt->fetchAll();

             if($result[0]['erreur']!=0){
                                       
                                       switch ($result[0]['erreur']){
                                           case 2:
                                               if(preg_match('/timeout/i', $result[0]['msgerreur'])){
                                                   $array = array("success"=>"error","type"=>"timeout");
                                                   $this->_helper->json($array);
                                               }else{
                                                   $array = array("success"=>"error","type"=>"error");
                                                   $this->_helper->json($array);
                                               }
                                                       
                                           break;
                                           default:
                                                            $array =Array("success"=>"error","type"=>"error");
                                                            $this->_helper->json($array);
                                           break;
                                                   
                                       }
                                   }else{
                                                   $array = (array) simplexml_load_string($result[0][""]);
                                                   $this->_helper->json($array);
                                   }

            
            
        }catch (Exception $e) {
            
            //Zend_Debug::dump($result,"retour base");
            
        }
        
        $this->view->bzfilter = $this->_bzfilter;
        
    }
    
    
    
   

}

?>
