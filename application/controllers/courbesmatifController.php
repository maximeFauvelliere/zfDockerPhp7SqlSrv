<?php

class courbesmatifController extends Zend_Controller_Action
{
    private $_idBzUser;
    private $_session;
    
    private $_db;
    
    private $_baseURL;
    
    private $_acl;
    private $_role;
    
    private $_data;
    
    private $_ip;
    
   
    
    public function init()
    {
        //session timeover
        //$this->_helper->Timeover($this->getRequest());
        

        $this->_session=  Zend_Registry::get("bzSession");
        //Zend_Debug::dump($_SESSION['bzSession'],"session bz");
        $this->_db=  Zend_Registry::get("db");
        
        
        $this->_idBzUser=$this->_session->idBzUser;
        $this->_ip=$this->_session->_ip;
       
        //$this->_baseURL=Zend_Registry::get("baseURL");
        

       
       
        
        $this->view->controller="courbesmatif";
        
       
        //Zend_Debug::dump($this->getFrontController()->getBaseUrl());
        // context switch change le context en ajax si ajax detecté dans request
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','json')
                            ->setAutoJsonSerialization(false)
                            ->initContext();

    }

    public function indexAction()
    {
       // call ps 
            $idmh=$this->getRequest()->getParam("idmh");
           // call ps 
           $stmt = $this->_db->prepare("execute ps_ExtWMatifGraph @ip='$this->_ip', @idgrgc='$this->_idBzUser',@idmh='$idmh'");
     
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
              
             
       
   /**
    * le timestamp renvoyer par la base est le timestamp * 1000 car
    * en javascript le timestamp est en milliseconde pas en seconde 
    */           
  for ($index = 0; $index < count($result); $index++) {
      //convert date to timestamp javascript
      
      //$date=new DateTime($result[$index]['date_mah']);
      //Zend_Debug::dump($date->getTimestamp()*1000);
      //$result[$index]['date_mah']=$date->getTimestamp()*1000;
      //cast les valeur du tableau en float ou int
      $result[$index]= array_map("toFloat", $result[$index]);  
      //convertie tableau associatif en index
      $result[$index]=array_values($result[$index]);
      
  }

//  //Zend_Debug::dump($result,"result");
//$toto=array();
//        for($index = 100; $index < 160; $index++){
//            
//            if($index==91) {
//                                continue;}
//            
//            $toto[$index]=$result[$index];
//        }
//        
//        $toto = array_values($toto);

        //$this->view->result=  json_encode($result);
        $this->_helper->json($result);

    }

}

function toFloat($n){
     return (float)$n;
 }
