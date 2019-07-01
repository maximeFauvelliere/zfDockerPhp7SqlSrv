<?php

class AideController extends Zend_Controller_Action
{
    
    
    public function init()
    {
        
        //session timeover
        $this->_helper->Timeover($this->getRequest());

        $this->_session=  Zend_Registry::get("bzSession");

        $this->view->controller="aide";
       
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                    ->setAutoJsonSerialization(false)
                    ->initContext();
        
       
        
    }

    public function indexAction()
    {
            // get application.ini data bz
            $fc = Zend_Controller_Front::getInstance();
            $arrOptions = $fc->getParam("bootstrap")->getOptions();
            
            $bzinit=$arrOptions['bzinit'];
            
            $this->view->urlAide=$bzinit['url_aide'];

            
    }
    
   

}

