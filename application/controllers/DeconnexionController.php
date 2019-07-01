<?php

class DeconnexionController extends Zend_Controller_Action
{

    public function indexAction()
    {
        $auth=Zend_Auth::getInstance();
        $auth->clearIdentity();
        
        session_destroy();
        
        Zend_Session::namespaceUnset('bzSession');
        
       
        $this->_helper->redirector('', '','default');
    }

    


}

