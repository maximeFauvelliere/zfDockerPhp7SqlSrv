<?php

/**
 * recupere les notifications
 * pas le content juste l'information de nouvelles notifications
 *
 * @author bruno
 * @return menu html
 */
require_once 'LogPs.php';

class Myclass_Actions_Helpers_Push extends Zend_Controller_Action_Helper_Abstract {
    

    private $_role;
    private $_acl;
    private $_session;
    private $_allowedPrimaryControllers;
    private $_db;
    private $_idBzUser;
    private $_ip;
    private $_data;
    private $_notifications;
    
    public function __construct() {
        
        $this->_session=  Zend_Registry::get("bzSession");
        $this->_idBzUser=$this->_session->idBzUser;
        $this->_ip=$this->_session->_ip;
        $this->_db=Zend_Registry::get("db");
        
        $this->_acl=$this->_session->_acl;
        $this->_role=  $this->_session->_role;
        
//        $this->_allowedPrimaryControllers=array(
//            "prospection"=>  $this->_acl->isAllowed($this->_role,"prospection","index")?"M_active":"M_desactive",
//            "transaction"=>$this->_acl->isAllowed($this->_role,"transaction","index")?"M_active":"M_desactive",
//            "administration"=>$this->_acl->isAllowed($this->_role,"administration","index")?"M_active":"M_desactive",
//            "execution"=>$this->_acl->isAllowed($this->_role,"execution","index")?"M_active":"M_desactive"
//            );
        
        
        
    }
    
    public function init() {
        //call ps notifications
        
       // $stmt = $this->_db->prepare("execute ps_ExtWNotifyView @idgrgc='$this->_idBzUser',@ip='$this->_ip'");
       $stmt = $this->_db->prepare("execute ps_ExtWNotifyCount @idgrgc='$this->_idBzUser',@ip='$this->_ip'");

       //log ps 
       $log=new Myclass_Actions_Helpers_LogPs();
       $log->setPsLog("push:ps_ExtWNotifyCount @idgrgc,@ip",false);
       
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
        
            
              if(count($result)<=0){
                 
                  $this->_notifications=null;
                  return;
              }
              $tab=array();
             
              foreach ($result as $key => $messagesCount) {
                  
                  foreach ($messagesCount as $k => $value) {
                      
                    $k=="compte"? $nb=$value:null;
                    $k=="notify"? $notify=$value:null;
                    
                  }
                  
                  $tab[$notify]=$nb;
                  
              }
              //Zend_Debug::dump($tab,"tab1");
              //check all presence notifications
              
              !array_key_exists("messages",$tab)?$tab["messages"]=0:null;
              !array_key_exists("taches",$tab)?$tab["taches"]=0:null;
              !array_key_exists("documents",$tab)?$tab["documents"]=0:null;
              
//              Zend_Debug::dump(array_key_exists("documents",$tab),"result is array documents");
//              Zend_Debug::dump(array_key_exists("messages",$tab),"result is array messages");
//              Zend_Debug::dump(array_key_exists("taches",$tab),"result is array taches");
//              Zend_Debug::dump($tab,"tab2");
              
              $this->_notifications=$tab;
              
              return;
             /*----------------------------------old  to delete-------------*/ 
            //Zend_Debug::dump(count($result),"result is array");
            //Zend_Debug::dump($result,"result from sql");
            //Zend_Debug::dump($tab,"result tab");
            
            return;
           
           /**
            *@todo faire tres attention car se base sur nom du xml comme une chaine vide 
            * il serait bien de regler se problème, pour etre sur que cela ne pose pas
            * de soucis pour le suite. 
            */
            $this->_data=$result[0][""];
            
           // Zend_Debug::dump($this->_data,"data brutes");
            
            try{
                if($this->_data!=null){
                    $this->_notifications=new SimpleXMLElement($this->_data);
                }else{
                    $this->_notifications=new SimpleXMLElement('<notifications></notifications>');
                    
                }
            }  catch (ErrorException $e){
               /**
                * @todo gere les erreurs
                */
                //Zend_Debug::dump($result);
                //Zend_Debug::dump($e);
               
            }
     return;
        $xml='<notifications>
                    <notification code="messages">
                        <message id="1" type="message" label="Messages"  nom="bienvenue" lu="1" pjointe="1" date="20/01/18"/>
                        <message id="2" type="taches" label="Taches" nom="Facture envoyée" lu="0" pjointe="0"/>
                        <message id="3" type="taches" label="Taches" nom="Contacter le service administratif" lu="1" pjointe="0"/>
                        <message id="4" type="actu" label="Actualités"  nom="fongicides"  pjointe="1"/>
                        <message id="5" type="message" label="Messages"  nom="B base nouveux prix" lu="0" pjointe="1" date="20/05/18"/>
                        <message id="6" type="taches" label="Taches" nom="logistique deux camoins" pjointe="1"/>
                        <message id="7" type="taches" label="Taches" nom="facturation moission refact" lu="1" pjointe="0"/>
                        
                    </notification>
                    <notification code="taches">
                        
                    </notification>
                    <notification code="documents">
                        <document id="1" nom="bon de voyage"/>
                        <document id="2" nom="facture"/>  
                    </notification>
               </notifications>
                
                
                    ';
        
            $this->_notifications=new SimpleXMLElement($xml);
            
            
        
    }
    
    public function push(){

            return $this->_notifications;
        
    }

    
    
    public function direct(){

        return $this->push();
    }
}

?>
