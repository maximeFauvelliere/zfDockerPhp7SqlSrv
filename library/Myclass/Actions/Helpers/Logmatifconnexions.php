<?php

/**
 * log les connexions au marché
 * permet de voir le nb pages vues
 *
 * @author bruno
 * @return menu html
 */
class Myclass_Actions_Helpers_Logmatifconnexions extends Zend_Controller_Action_Helper_Abstract {

    
    
    public function __construct() {
        
    }

    public function init() {
        
    }
    

    public function logmatifconnexions($params){
        
        //exclusion ip beuzelin du log conexion marchés
        $tab=array("62.160.11.246","84.55.165.16");
        
        if(in_array($_SERVER['REMOTE_ADDR'], $tab)) return;

        
         // si log n'existe pas on le creer'
        if(!file_exists('./../application/logs/matifconnexions.log')){
            $fileName = "./../application/logs/matifconnexions.log";
            $fileHandle = fopen($fileName, 'w') or die("can't open file");
            fclose($fileHandle);
        }
        
       // Zend_Debug::dump(file_exists('../application/logs/errorlog.log'),"file exist");
        
            $this->_loggerMatif = new Zend_Log();
            $redacteur = new Zend_Log_Writer_Stream('./../application/logs/matifconnexions.log');
            $this->_loggerMatif->addWriter($redacteur);
        

          
            foreach ($params as $key => $value) {

                if($key=="infos")$paramToString=$value;

            }
            
            $level=$params['level'];
            
            switch ($level){
                // notice erreur  level 5
                case 'notice':
                        $this->_loggerMatif->notice($paramToString);

                    break;
                // alert erreur level 1 a corriger immediatement ou a prendre en considération
                case 'alert':
                        $this->_loggerMatif->alert($paramToString);

                    break;
                //info
                default:
                        $this->_loggerMatif->info($paramToString);
                    break;
            }

        
   }

    public function direct($params) {
        
       
        return $this->logmatifconnexions($params);
    }

}

?>
