<?php



/**
 * Description of bzFilter
 *
 * @author bruno
 * @deprecated remplacé par controller filter;
 */
class Zend_View_Helper_BzFilter extends Zend_View_Helper_Abstract {
    
    
    
    private $_bzfilter;
    
    private $_db;
    //idgrgc
    private $_idBzUser;
    
    private $_ip;
    
    private $_session;
    
    private $_filterParam;
 
    
    public function __construct() {
        
        $this->_db=  Zend_Registry::get("db");

        $this->_session=  Zend_Registry::get("bzSession");
        
        $this->_ip=$this->_session->_ip;
        
        $this->_idBzUser=$this->_session->idBzUser;
        
        
        /**
         *get filterparam 
         */
        $this->_filterParam=0;
        
        
        /**
         * requete pour filtre
         */
        
        try{
            $stmt = $this->_db->prepare("execute ps_ExtWFilterGet @idgrgc=$this->_idBzUser,@param='$this->_filterParam',@ip='$this->_ip'");

            $stmt->execute();

            $result= $stmt->fetchAll();

            $data=$result[0][""];
            
            $this->_bzfilter=new SimpleXMLElement($data);
            
        }catch (Exception $e){
            
        
        }   
           
       
        
        
        
//        $filter='<filter>
//                    <camps>
//                        <camp  idcamp="11"></camp>
//                        <camp  checked="1" idcamp="12"></camp>
//                        <camp  idcamp="13"></camp>
//                    </camps>
//                    <cultures>
//                            <culture idcult="300" nom="blé" checked="1"></culture>
//                            <culture idcult="301" nom="colza" checked="1"></culture>
//                            <culture idcult="302" nom="orge" checked="1"></culture>
//                    </cultures>
//                    <structures>
//                        <structure  idti="200" checked="1" nom="earl 1"></structure>
//                        <structure  idti="201" checked="1" nom="earl 2"></structure>
//                        <structure  idti="202" checked="0" nom="earl 3"></structure>
//                    </structures>
//
//                </filter>';

       
        
        
        //Zend_Debug::dump($this->_bzfilter);
   
    }
 
    
    public function bzfilter(){

        return $this->_bzfilter;
  
    }
    
    
}

?>
