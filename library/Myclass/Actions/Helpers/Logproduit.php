<?php

/**
 * enregistre les action sur les produits
 * pour le suivi
 *
 * @author bruno
 * @return log
 */
class Myclass_Actions_Helpers_LogProduit extends Zend_Controller_Action_Helper_Abstract {

    
    
    public function __construct() {
        
    }

    public function init() {
        
    }
    

    public function logProduit($params){
        
         // si log n'existe pas on le creer'
        if(!file_exists('./../application/logs/errorlogProduit.log')){
            $fileName = "./../application/logs/errorlogProduit.log";
            $fileHandle = fopen($fileName, 'w') or die("can't open file");
            fclose($fileHandle);
        }
        
       // Zend_Debug::dump(file_exists('../application/logs/errorlog.log'),"file exist");
        
            $this->_loggerProduit = new Zend_Log();
            $redacteur = new Zend_Log_Writer_Stream('./../application/logs/errorlogProduit.log');
            $this->_loggerProduit->addWriter($redacteur);
        
           
        
            
        
            $paramToString="";
        
            foreach ($params as $key => $value) {

                
                if($key=="format") continue;

                $paramToString.="-".$key.":".$value;


            }
            
            $level=$params['level'];
            
            switch ($level){
                // notice erreur  level 5
                case 'notice':
                        $this->_loggerProduit->notice($paramToString);

                    break;
                // alert erreur level 1 a corriger immediatement ou a prendre en considération
                case 'alert':
                        $this->_loggerProduit->alert($paramToString);

                    break;
                //info
                default:
                        $this->_loggerProduit->info($paramToString);
                    break;
            }

        
   }

    public function direct($params) {
        
       
        return $this->logProduit($params);
    }

}

?>
