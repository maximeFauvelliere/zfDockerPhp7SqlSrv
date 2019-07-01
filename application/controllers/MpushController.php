<?php

class MpushController extends Zend_Controller_Action{
    private $_idBzUser;
    private $_session;
    
    private $_db;
    
    private $_baseURL;
    
    private $_acl;
    private $_role;
    
    private $_data;
    
    private $_filter;
    private $_camp;
    private $_cultures;
    private $_structures;
    
    public function init(){
        
        //session timeover
        $this->_helper->Timeover($this->getRequest());

        $this->_session=  Zend_Registry::get("bzSession");
        //Zend_Debug::dump($_SESSION['bzSession'],"session bz");
        $this->_db=  Zend_Registry::get("db");
        
        
        $this->_idBzUser=$this->_session->idBzUser;
        $this->_ip=$this->_session->_ip;
       
       
    
        

       
        //Zend_Debug::dump($this->getFrontController()->getBaseUrl());
        // context switch change le context en ajax si ajax detecté dans request
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                            ->addActionContext('index','json')
                            ->addActionContext('notifications','json')
                            ->setAutoJsonSerialization(false)
                            ->initContext();


    }

    /**
     * call with connect or loadAcc
     */
    public function indexAction(){
        

    }
    
    public function notificationsAction(){
        
         if($this->getRequest()->getParam("format") =="json"){

                 $this->_filter=$this->getRequest()->getParam("filter")?$this->getRequest()->getParam("filter"):null;
        
             

                $this->_camp=$this->_filter["camp"];
                $this->_cultures=$this->_filter["cultures"];
                $this->_structures=$this->_filter["structures"];
                $this->_param=  $this->_filter["modify"]?0:2;
            
                $stmt = $this->_db->prepare("execute ps_ExtWnotifyM @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");

                try {
                    $stmt->execute();
                    $result = $stmt->fetchAll();
                } catch (Zend_Exception $e) {

                }


               // Zend_debug::dump( $result," ps_ExtWnotifyM");
                if (!$result[0][""]) {

                }

            /*$this->_logger = new Zend_Log();
            $redacteur = new Zend_Log_Writer_Stream('../application/logs/errorlog.log');
            $this->_logger->addWriter($redacteur);
            $this->_logger->debug("from ps_ExtWnotifyM : ".print_r($result,true));*/

                try {
                    //$array = (array) simplexml_load_string($result[0][""]);
                    $this->_helper->json($result);
                } catch (Zend_Exception $e) {
                    
                }
        
        }else{
            //$this->_helper->layout->setLayout('mmobiles');
        }
    }

}

