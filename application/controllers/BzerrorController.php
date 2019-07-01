<?php

class BzerrorController extends Zend_Controller_Action
{
    private $_session;
    
    private $_logger;
    
    public function init(){
        
        
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('interdit','html')
                    ->addActionContext('notice','html')
                    ->addActionContext('notice','json')
                    ->addActionContext('browsercompatibilityAction','html')
                    ->setAutoJsonSerialization(false)
                    ->initContext();

            $this->_logger = new Zend_Log();
            $redacteur = new Zend_Log_Writer_Stream('../application/logs/errorlog.log');
            $this->_logger->addWriter($redacteur);
            
            $this->_logger->debug($this->getRequest()->getParam('error'));
            $this->_logger->debug("session bzuser : ".$this->_session->idBzUser);
        
    }
    
    public function indexAction()
    {
       $param=$this->getRequest()->getParams();
        
        $paramToString="";
        
        foreach ($param as $key => $value) {
            
            if($key=="format") continue;
            
            $paramToString.="-".$key.":".$value;
            
            
        }
        
       $this->_logger->info( $paramToString);
              
       $this->view->errorMessage=$this->_helper->flashMessenger->getMessages('error');
       $this->_helper->layout->setLayout('bzerror');        
       // detruit le session implique un nouveau login
       Zend_Session::destroy( true );
    }
    
        
    /**
     * traitement erreur de niveau 3, n'implique pas une destruction de la session
     */
    public function noticeAction(){
        
        
        $param=$this->getRequest()->getParams();
        
        $paramToString="";
        
        foreach ($param as $key => $value) {
            
            if($key=="format") continue;
            
            $paramToString.="-".$key.":".$value;
            
            
        }
        //Zend_debug::dump($this->getRequest()->getParam('format'),"format");
        if($this->getRequest()->getParam('format')=="json"){
            
            $message=Zend_Json::encode(array("error"=>$param['message']));
        }else{
            $message=$param['message'];

        }
        //$this->view->errorMessage= Zend_Json::encode(array("error"=>$this->_helper->flashMessenger->getMessages('error')));
       
        $this->_logger->notice($paramToString);
        $this->view->errorMessage=$message;
        
        
      // ;
    }
    
    public function interditAction(){
        
        $this->view->errorMessage="Vous n'avez pas accès à cette ressource.";
    }
    
    public function onlylogAction(){
        
        $this->_helper->viewRenderer->setNoRender(true) ;
        
        $param=$this->getRequest()->getParams();
        
        $paramToString="";
        
        foreach ($param as $key => $value) {
            
            if($key=="format") continue;
            
            $paramToString.="-".$key.":".$value;
            
            
        }
        
        $this->_logger->notice($paramToString);
        
        
    }
    
    /**
     * traitement erreur de niveau 2, n'implique pas une destruction de la session
     * envois un email au webmaster
     */
    public function alertAction(){
         $this->_helper->viewRenderer->setNoRender(true) ;
        
        $param=$this->getRequest()->getParams();
        
        $paramToString="";
        
        foreach ($param as $key => $value) {
            
            if($key=="format") continue;
            
            $paramToString.="-".$key.":".$value;
            
            
        }
        
        $this->_logger->alert($paramToString);
    }
    
    
    public function browsercompatibilityAction(){
        
        $this->_helper->layout->setLayout('bzerror'); 
        
        $this->view->browser=$this->getRequest()->getParam("browser");
        $this->view->version=$this->getRequest()->getParam("version");
        
       // detruit le session implique un nouveau login
       Zend_Session::destroy( true );
        
        //Zend_Debug::dump($this->getRequest(),"request in bzerror");
        
    }
    
    public function browserversionAction(){
        
        $this->_helper->layout->setLayout('bzerror'); 
        
        $this->view->browser=$this->getRequest()->getParam("browser");
        $this->view->version=$this->getRequest()->getParam("version");
        $this->view->min=$this->getRequest()->getParam("min");
       // detruit le session implique un nouveau login
       Zend_Session::destroy( true );
        
        //Zend_Debug::dump($this->getRequest(),"request in bzerror");
        
    }
    
    public function mobileAction(){
        
        $this->_helper->layout->setLayout('m_bzerror'); 
         //Zend_Session::destroy( true );
        
    }
    
    
    


}

