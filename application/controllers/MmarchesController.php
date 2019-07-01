<?php


class MmarchesController extends Zend_Controller_Action
{
    // idgrgc
    private $_idBzUser;
    //acl
    private $_acl;
    private $_role;
    // identifiant 
    private $_bzUser;
    private $_session;
    private $_ip;
    private $_db;
    
    private $_data;
    
    private $_filter;
    private $_camp;
    private $_cultures;
    private $_structures;
    
    

    public function init()
    {
       
        //session timeover
        $this->_helper->Timeover($this->getRequest());
      
        $this->_session=  Zend_Registry::get("bzSession");
        $this->_idBzUser=$this->_session->idBzUser;
        $this->_ip=$this->_session->_ip;
        $this->_bzUser=$this->_session->bzUser;
        $this->_db=  Zend_Registry::get("db");
        
        
 
        
        /*
        //acl
        $this->_acl=$this->_session->_acl;
        $this->_role=  $this->_session->_role;
        */
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                            ->addActionContext('index','json')
                            ->addActionContext('note','json')
                            ->addActionContext('graph','html')
                            ->addActionContext('graph','json')
                            ->setAutoJsonSerialization(false)
                            ->initContext();
     

        
    }
    
    public function indexAction(){
        
       if($this->getRequest()->getParam("format")=="json"){
            $this->_filter=$this->getRequest()->getParam("filter")?$this->getRequest()->getParam("filter"):null;
            $this->_camp=$this->_filter["camp"];
            $this->_cultures=$this->_filter["cultures"];
            $this->_structures=$this->_filter["structures"];
            $this->_param=  $this->_filter["modify"]?0:2;
            
            $stmt = $this->_db->prepare("execute ps_ExtWMatifReadM @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");

                   try{
                        $stmt->execute();
                        $result=$stmt->fetchAll();
                       }catch(Zend_Exception $e){

                      }

                    if(!$result[0]["XML"]){
                  
                    }

                    //Zend_Debug::dump($result,"xml from sql");

                    try{
                        $array = (array)simplexml_load_string($result[0]["XML"]);
                        $this->_helper->json($array);

                    }catch(Zend_Exception $e){

                    }

        }
    }
    
    public function noteAction(){
         if($this->getRequest()->getParam("format")=="json"){
            
             $stmt = $this->_db->prepare("execute ps_ExtWInfMarcheM @idgrgc='$this->_idBzUser',@ip='$this->_ip'");

                   try{
                        $stmt->execute();
                        $result=$stmt->fetchAll();
                       }catch(Zend_Exception $e){

                      }

                    if(!$result[0]["XML"]){
                  
                    }

                    //Zend_Debug::dump($result,"xml from sql");

                    try{
                        $array = (array)simplexml_load_string($result[0][""]);
                        $this->_helper->json($array);

                    }catch(Zend_Exception $e){

                    }

        }
        
    }
    
    public function graphAction(){
        
    }
    
    public function eurocbotAction(){
        
         //if($this->getRequest()->getParam("format")=="json"){
            
             $stmt = $this->_db->prepare("execute ps_ExtWInfMarcheCEDM @idgrgc='$this->_idBzUser',@ip='$this->_ip'");

                   try{
                        $stmt->execute();
                        $result=$stmt->fetchAll();
                       }catch(Zend_Exception $e){

                      }

                    if(!$result[0]){
                  
                    }

                    //Zend_Debug::dump($result[0][""],"xml from sql");
                   // $xml="<root><eurodollar><nom>Euro/Dollar</nom><valeur>1.38688</valeur></eurodollar><petrole><nom>Pétrole WTI Jun 2014</nom><valeur>99.48 $/b</valeur></petrole><chicago><echeances><echeance>BlÃ© May 2014</echeance><valeur>721.25</valeur><variation>13.25</variation></echeances><echeances><echeance>MaÃ¯s May 2014</echeance><valeur>503.25</valeur><variation>-12.50</variation></echeances><echeances><echeance>Soja May 2014</echeance><valeur>1472.00</valeur><variation>-52.00</variation></echeances></chicago></root>";

                    try{
                        $array = (array)simplexml_load_string($result[0][""]);
                        //$array = (array)simplexml_load_string($xml);
                        $this->_helper->json($array);
                        //echo json_encode($array);
                        //exit();

                    }catch(Zend_Exception $e){
                        $this->_helper->json($e);
                    }

        //}
        
        
    }
    
    
    

}

