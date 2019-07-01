<?php

class MdeconnexionController extends Zend_Controller_Action{
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
        
        

        $this->_session=  Zend_Registry::get("bzSession");
        Zend_Session::destroy( true );

    }

    /**
     * call with connect or loadAcc
     */
    public function indexAction(){
        $this->_helper->redirector->gotoUrl("/mindex/index");
       
    }

}

