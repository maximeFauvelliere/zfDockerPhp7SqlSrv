<?php
/**
 *
 *class qui charges les données globale d'une rubrique
 * surtout utiliser lors de la mise a jours avec le filtre
 * exemple : charges les data pour prospection. 
 */
//logs
require_once 'LogPs.php';

class Myclass_Actions_Helpers_Getglobal extends Zend_Controller_Action_Helper_Abstract {
    
    
    private $_GData;
    
   
    //idgrgc
    private $_idBzUser;
    
    private $_ip;
    
    private $_session;
    
    private $_db;

    
    public function __construct() {
        
        //$this->_db=  Zend_Registry::get("db");
        
        
        $this->_session=  Zend_Registry::get("bzSession");
        
        $this->_ip=$this->_session->_ip;
        
        $this->_idBzUser=$this->_session->idBzUser;
        
       
        
        
        //Zend_Debug::dump($this->_bzUzer);
        //Zend_Debug::dump($this->_ip);
        
      
        
    }
    
    public function init() {
 
    }
    
    public function getGData($db,$rubrique,$filter){
        
       
        
            $camp=$filter["camp"];
            $cultures=$filter["cultures"];
            $structures=$filter["structures"];
            $param=$filter["modify"]?0:2;
       
        // requete page accueil rubrique
            $this->_db=$db;
            $stmt = $this->_db->prepare("execute ps_ExtWAcc @idgrgc='$this->_idBzUser',@code='$rubrique',@camp=$camp,@cultures='$cultures',@structures='$structures',@param=$param,@ip='$this->_ip'");
            
            $log=new Myclass_Actions_Helpers_LogPs();
            $log->setPsLog(" helper: GetGlobal : ps_ExtWAcc @idgrgc,@code,@camp,@cultures,@structures,@param,@ip");
           
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                echo $e->getMessage();
              }
       
            $data=$result[0][""];
            
            //Zend_Debug::dump($data,"gdata XML formated");
            
            
            //test si le retour n'est pas null, attention les bloc try catch ne fonction pas sur Zend_Json::fromXml
            if($data){
               
                $this->_GData=Zend_Json::fromXml($data,false);
               // Zend_Debug::dump("gdata ok",$this->_GData);
              
            }else{
                
                $data='<cellules><cellule titre="erreur de données" img="" color="" id=""><cultures><culture nom="erreur données" valeur="" ratio="100"/></cultures><optimiz/><securiz/></cellule></cellules>';
                    
                $this->_GData=Zend_Json::fromXml($data,false);
                //Zend_Debug::dump("gdata ko",$this->_GData);
            }

            
            return $this->_GData;
            
        
    }
    
    
    public function direct($db,$rubrique,$filter){

        return $this->getGData($db,$rubrique,$filter);
    }
}

?>
