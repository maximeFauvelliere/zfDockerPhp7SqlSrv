<?php

class ErrorController extends Zend_Controller_Action
{
    private $_logger;
    
    public function init(){
         $ajaxContext=$this->_helper->AjaxContext;
         $ajaxContext->addActionContext('error','html')
                    ->setAutoJsonSerialization(false)
                    ->initContext();

        $this->_logger = new Zend_Log();
            $redacteur = new Zend_Log_Writer_Stream('../application/logs/errorlog.log');
            $this->_logger->addWriter($redacteur);
            
        $errors = $this->_getParam('error_handler');
       
        $exception = $errors->exception;
                
                $this->_logger->debug($exception->getMessage()
                          . "\n"
                          . $exception->getTraceAsString());
 
            
    }
    
    public function errorAction()
    {
        // utilise le layout login layout sans menu quasi vierge
        $this->_helper->layout->setLayout('bzerror');
        $this->_helper->redirector('index','bzerror');
       //$this->_helper->layout->setLayout('bzerror');
    }

    public function getLog()
    {
        $bootstrap = $this->getInvokeArg('bootstrap');
        if (!$bootstrap->hasResource('Log')) {
            return false;
        }
        $log = $bootstrap->getResource('Log');
        return $log;
    }


}

