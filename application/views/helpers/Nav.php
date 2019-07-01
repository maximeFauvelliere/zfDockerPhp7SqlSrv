<?php
/**
 * Description of NAV
 *
 * @author bruno
 */
class Zend_View_Helper_Nav extends Zend_View_Helper_Abstract {
    
    
    
    private $_bzMenu;
    
    private $_db;
    //idgrgc
    private $_idBzUser;
    
    private $_ip;
    
    private $_session;
 
    
    public function __construct() {
        
        $this->_db=  Zend_Registry::get("db");

        $this->_session=  Zend_Registry::get("bzSession");
        
        $this->_ip=$this->_session->_ip;
        
        $this->_idBzUser=$this->_session->idBzUser;
        
         
        $this->_bzMenu=  $this->_session->_bzMenu;
        
        $front = Zend_Controller_Front::getInstance();
        $controllerName=$front->getRequest()->getControllerName();
        
        //$controllerName="transaction";
        
        //$menuXml = simplexml_load_string($this->_session->_bzMenu);
        
       
        
        //$menuXml=simplexml_load_string($this->_bzMenu);
        
        
        
       //Zend_Debug::dump($this->_bzMenu);
        //echo "-----------------------------------";
       // Zend_Debug::dump($menuXml->menu[1]["nom"]);
        
//         $test='<bzmenu>
//            <rubriques nom="Prospection" code="prospection" checked="1">
//                    <subrubrique nom="Stock Dépot" code="depot" checked="0"/>
//                    <subrubrique nom="Stock Ferme" code="ferme" checked="1"/>
//                    <subrubrique nom="Analyses en attentes" code="analyses" checked="1"/>
//                    <subrubrique nom="Ajout Stock Ferme" code="stock" checked="1"/>
//                       
//                    <menu nom="Informations" code="informations" checked="1">
//                        <submenu nom="info de marché" code="complete" checked="0"/>    
//                    </menu>
//            </rubriques>       
//             <rubriques nom="Administration" code="administration" checked="1">
//                    <subrubrique nom="Historique" code="historique" checked="1"/>
//                    <subrubrique nom="Encours" code="encours" checked="1"/>
//                    <subrubrique nom="previsionnel" code="previsionnel" checked="1"/>
// 
//                    <menu nom="Informations" code="informations" checked="0">
//                        <submenu nom="info de marché" code="complete" checked="1"/>
//                    </menu>
//            </rubriques>
//            <rubriques nom="Transactions" code="transaction" checked="1">
//                    <subrubrique nom="transaction 1" code="transaction1" checked="1"/>
//                    <subrubrique nom="transaction 2" code="transaction2" checked="1"/>
//                    
//                    <menu nom="Simulation" code="simulation" checked="1">
//                        <submenu nom="info de marché" code="complete" checked="1"/>
//                        <submenu nom="Gamme commerciale" code="gamme" checked="0"/>
//                        <submenu nom="Offres commerciales" code="offres" checked="1"/>
//                    </menu>
// 
//                    <menu nom="Informations" code="informations" checked="1">
//                        <submenu nom="info de marché" code="complete" checked="1"/>
//                    </menu>
//                    
//                    <menu nom="Actions" code="actions" checked="1">
//                        <submenu nom="action 1" code="action1" checked="1"/>
//                    </menu>
//            </rubriques> 
//            <rubriques nom="Execution" code="execution" checked="1">
//                    <subrubrique nom="exec1" code="exec1" checked="1"/>
//                    <subrubrique nom="exec2" code="exec2" checked="1"/>
//                    
//                    <menu nom="Informations" code="informations" checked="1">
//                        <submenu nom="info de marché" code="complete" checked="1"/>
//                    </menu>
//            </rubriques>
//                </bzmenu>';

      
      
       // $this->bzMenu=new SimpleXMLElement($test);
       // $this->bzMenu=$menuXml;
       
         
         
        $this->_bzMenu=new SimpleXMLElement($this->_bzMenu);
        
        /**
         * pass le xml pour la rubrique selectionnée (function du controller)
         *  check si la rubrique est autorisé sinon renvois menu null
         */
        foreach ($this->_bzMenu->rubriques as  $value) {
            
           if(strtolower((string)$value["code"])==$controllerName && (int)$value["checked"]){
             
              $this->_bzMenu=$value->menu;
              return;
           }else{
              
               $this->_bzMenu=null;                
           }
        }
        
   
    }
 
    
    public function nav(){
       //Zend_Debug::dump($this->_bzMenu);
        return $this->_bzMenu;
  
    }
    
    
}

?>
