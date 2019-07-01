<?php
/**
 *gestion du timeover 
 * sur l'application
 *
 */
//logs
require_once 'LogPs.php';

class Myclass_Actions_Helpers_Timeover extends Zend_Controller_Action_Helper_Abstract {
    
    
    //session
    private $_session;
    
   

    
    public function __construct() {
        
        //$this->_db=  Zend_Registry::get("db");
        
        
        $this->_session=  Zend_Registry::get("bzSession");
        
        //if($this->_session->timeOver) $this->_session->timeOver=time();
        
       
        
        
        //Zend_Debug::dump($this->_bzUzer);
        //Zend_Debug::dump($this->_ip);
        
      
        
    }
    
    public function init() {
 
    }
    
    public function over($request){
        
       
        
        $uri=$request->getRequestUri();
        //Zend_Debug::dump($uri,"uri");
        //exclus les notification du time over
        $pattern="/push\/index/i";
        
        $patternMatif="/transaction\/matif/i";
        
        $pattern2="/json/i";
        
        //$patternMobile="/^\/m/"
        
        $deviceType=$this->_session->deviceType;
        
        
        if(!preg_match($pattern, $uri)){

           //$this->_session->timeOver=time();
            //Zend_Session::namespaceUnset('bzSession');
            
            //timeover n'est pas en session , cas premiere connexion
            if(!$this->_session->timeOver) $this->_session->timeOver=time();

            if(time()-$this->_session->timeOver>1200){

                Zend_Session::namespaceUnset('bzSession');
                session_destroy ();
                //Zend_Debug::dump($this->_session);
                //ajax request
                //Zend_Debug::dump($request->isXMLHttpRequest(),"ajax");
                $redirector = new Zend_Controller_Action_Helper_Redirector();
                
                
                if($deviceType!="mobile"){
                // apel from json request
                if(preg_match($pattern2, $uri)){
                    
                    $redirector->gotoUrl('/index/index/format/json');
                    exit();
                }
                
                
                // ajax ou html request
                if($request->isXMLHttpRequest())
                {
                  
                  $redirector->gotoUrl('/index/index/format/html');
                  exit();
                 
                }else{
                    $redirector->gotoUrl('/index/index/');
                    
                }
                }else{

                    
                    // apel from json request
                        if(preg_match($pattern2, $uri)){

                            //$redirector->gotoUrl('/mindex/index/format/json');
                            $array = array("success"=>"error","type"=>"timeout");
                            echo json_encode($array);
                            exit();
            }else{
                            $redirector->gotoUrl('/mindex/index/format/html');
                            exit();
                        }
                
                }
            }else{
                
                //si c'est le flux matif qui appel seul on ne ré-initialise pas le compteur
                if(preg_match($patternMatif, $uri)) return;
                //sinon on redemarre le compteur pour nx 20mn
                $this->_session->timeOver=time();
            }
            
            //$this->_session->timeOver=time();
            
            
        }
            
          



    }
    
    
    public function direct($request){

         return $this->over($request);
    }
}

?>
