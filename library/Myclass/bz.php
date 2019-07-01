<?php

require_once '/Actions/Helpers/LogPs.php';

/**
 * adaptater pour zend auth
 */
class bz implements Zend_Auth_Adapter_Interface
{
    protected $_identifiant;
    protected $_pwd;
    private   $db;
    private   $_session;
    private   $_ip;
    private   $_device;
    private $_isDirect;
    /**
     *
     * @param type $identifiant
     * @param type $pwd
     * @param type $db 
     */
    public function __construct($identifiant,$pwd,$db,$ip,$device="desktop",$isDirect=false)
    {
        $this->_session=Zend_Registry::get("bzSession");
        $this->_identifiant=$identifiant;
        $this->_pwd=$pwd;
        $this->db=$db;
        $this->_ip=$ip;
        $this->_device=$device;
        $this->_isDirect=$isDirect;
        
        
        
    }
    
    
    public function authenticate(){
        
            /*$this->_logger = new Zend_Log();
            $redacteur = new Zend_Log_Writer_Stream('./../application/logs/errorlog.log');
            $this->_logger->addWriter($redacteur);
            
            $t=array("id"=>$this->_identifiant,"pwd"=>$this->_pwd,"ip"=>$this->_ip,"device"=>$this->_device);
            
            $this->_logger->debug(print_r($t,true));
        */
        
     if($this->_device=="desktop"){  
             try{

                   $stmt = $this->db->prepare("execute ps_ExtWConnect @login='$this->_identifiant',@pwd='$this->_pwd',@ip='$this->_ip'");
                   $log=new Myclass_Actions_Helpers_LogPs();
                   $log->setPsLog("ps_ExtWConnect @login,@pwd,@ip");
                   $stmt->execute();



                    foreach( $stmt->fetchAll() as $key=>$v)
                    {

                        if($v['erreur']!=0){
                            //Zend_Auth_Result($code, $identity, $messages)
                            //return new Zend_Auth_Result(Zend_Auth_Result::FAILURE,$this->_identifiant,array('message'=>$v['msgerreur']));


                            return new Zend_Auth_Result(Zend_Auth_Result::FAILURE,'anonyme',array('message'=>$v['msgerreur']));

                        }

                        if($v['erreur']==0){

                            $this->_session->dateLastConn=$v['datlastcon'];
                            $this->_session->idBzUser=$v['idgrgc'];
                            $this->_session->nomUser=$v['nom'];
                            $this->_session->prenomUser=$v['prenom'];
                            $this->_session->bzUser=$this->_identifiant;

                            //Zend_Auth_Result($code, $identity, $messages)
                            return new Zend_Auth_Result(Zend_Auth_Result::SUCCESS,'bzUser',array('message'=>$v['msgerreur']));

                        }



                    }


                }catch (Execption $msg){

                    return new Zend_Auth_Result(Zend_Auth_Result::FAILURE,'anonyme',"erreur de connexion a la base de donnée");
               }
        
     }else{
         // device mobiles
         if(!$this->_isDirect){
                try{

                   $stmt = $this->db->prepare("execute ps_ExtWConnectM @login='$this->_identifiant',@pwd='$this->_pwd',@ip='$this->_ip'");
                   $log=new Myclass_Actions_Helpers_LogPs();
                   $log->setPsLog("ps_ExtWConnectM @login,@pwd,@ip");
                   $stmt->execute();



                    foreach( $stmt->fetchAll() as $key=>$v)
                    {

                        if($v['erreur']!=0){
          
                            return new Zend_Auth_Result(Zend_Auth_Result::FAILURE,'anonyme',array('message'=>$v['msgerreur']));

                        }

                        if($v['erreur']==0){

                            $this->_session->dateLastConn=$v['datlastcon'];
                            $this->_session->idBzUser=$v['idgrgc'];
                            $this->_session->nomUser=$v['nom'];
                            $this->_session->prenomUser=$v['prenom'];
                            $this->_session->bzUser=$this->_identifiant;
 
                           $arrayAcc = json_encode((array)simplexml_load_string($v['accueil']));
                            $this->_session->mAcc=$arrayAcc;
         
                            $arrayFilter = json_encode((array)simplexml_load_string($v['filtre']));
                            $this->_session->mFilter=$arrayFilter;
         
                            $arrayMenu = json_encode((array)simplexml_load_string($v['menu']));
                            $this->_session->mMenu=$arrayMenu;
                            
                            //print_r($_SESSION['bzSession']);

                            //Zend_Auth_Result($code, $identity, $messages)
                            return new Zend_Auth_Result(Zend_Auth_Result::SUCCESS,'bzUser',array('message'=>$v['msgerreur']));

                        }



                    }


                }catch (Execption $msg){

                    return new Zend_Auth_Result(Zend_Auth_Result::FAILURE,'anonyme',"erreur de connexion a la base de donnée");
               }
         }else{
             try{

                   $stmt = $this->db->prepare("execute ps_ExtWConnect @login='$this->_identifiant',@pwd='$this->_pwd',@ip='$this->_ip'");
                   $stmt->execute();

                    foreach( $stmt->fetchAll() as $key=>$v)
                    {

                        if($v['erreur']!=0){
          
                            return new Zend_Auth_Result(Zend_Auth_Result::FAILURE,'anonyme',array('message'=>$v['msgerreur']));

                        }

                        if($v['erreur']==0){

                            $this->_session->dateLastConn=$v['datlastcon'];
                            $this->_session->idBzUser=$v['idgrgc'];
                            $this->_session->nomUser=$v['nom'];
                            $this->_session->prenomUser=$v['prenom'];
                            $this->_session->bzUser=$this->_identifiant;
 
                            return new Zend_Auth_Result(Zend_Auth_Result::SUCCESS,'bzUser',array('message'=>$v['msgerreur']));

                        }



                    }


                }catch (Execption $msg){

                    return new Zend_Auth_Result(Zend_Auth_Result::FAILURE,'anonyme',"erreur de connexion a la base de donnée");
               }
         }    
             
     }
        
    }
}


