<?php

/**
 * 
 * log pour ps utilisées
 *
 * @author bruno
 * @return menu html
 */
class Myclass_Actions_Helpers_LogPs extends Zend_Controller_Action_Helper_Abstract {

    
    private $activelog=false;
    
    public function __construct() {
        /**
         * @todo voir comment recuperer le bzinit dans plugin
         */
        // get application.ini data bz
        /*$fc = Zend_Controller_Front::getInstance();

        $arrOptions = $fc->getParam("bootstrap")->getOptions();

        $bzinit=$arrOptions['bzinit'];

        $this->activelog=$bzinit['logps'];*/
    }

    public function init() {
        
    }

    public function setPsLog($text,$enable=true) {
        
        if(!$this->activelog) return;
        
        if(!$enable) return;
        $filename = '../public/logps.txt';
        $somecontent = $text." \n";
//echo file_exists($filename);
//return;
// Assurons nous que le fichier est accessible en écriture
        if (is_writable($filename)) {

            // Dans notre exemple, nous ouvrons le fichier $filename en mode d'ajout
            // Le pointeur de fichier est placé à la fin du fichier
            // c'est là que $somecontent sera placé
            if (!$handle = fopen($filename, 'a')) {
                echo "Impossible d'ouvrir le fichier ($filename)";
                exit;
            }

            // Ecrivons quelque chose dans notre fichier.
            if (fwrite($handle, $somecontent) === FALSE) {
                echo "Impossible d'écrire dans le fichier ($filename)";
                exit;
            }

            

            fclose($handle);
        } else {
            echo "Le fichier $filename n'est pas accessible en écriture.";
        }
    }

    public function direct($text,$enable=true) {
        
        if(!$this->activelog) return;
        return $this->setPsLog($text,$enable);
    }

}

?>
