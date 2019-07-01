<?php


class MindexController extends Zend_Controller_Action
{
    
    
    private $_session;
    private $_db;
    
    public function init(){   
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                    ->addActionContext('index','json')
                    ->addActionContext('mpo','json')
                    ->setAutoJsonSerialization(false)
                    ->initContext();
        //session 
        $this->_session=Zend_Registry::get("bzSession");
        //db
        $this->_db=  Zend_Registry::get("db");
        
        // l'utilisateur a t'il dejà une session , s'est t'il deja connecté?
        // oui => alors il est redirigé vers sa page accueil personnel
        $aut=  Zend_Auth::getInstance();

        if($aut->hasIdentity() && $aut->getIdentity()=="bzUser" ){

           
            //$this->_helper->redirector("index","maccueil",null,array("format"=>"json"));
             
        }

        //recupere zend db
        $db=Zend_Registry::get('db');

        switch ($this->getRequest()->getParam("format")) {
            case "html":
                //Zend_Debug::dump("html case");
                    $this->_helper->layout->setLayout('errorajax');
                break;
            case "json":
                //Zend_Debug::dump("json case");
                   //echo json_encode(array("error"=>"Votre session n'est plus active.Veuillez vous connecter à nouveau."));
                    //$this->_helper->layout->setLayout('merrorjson');
                break;

            default:
                //Zend_Debug::dump("default case");
                    $this->_helper->layout->setLayout('mlogin');
                break;
        }
        
        
        $lay = Zend_Layout::getMvcInstance();
         //Zend_Debug::dump($lay->getLayout(),"layout");
        
    }

    public function indexAction()
    {
        //echo phpinfo();
       $db=Zend_Registry::get("db");
 
       //$this->_helper->layout->setLayout('mlogin');

    }
    /**
     *  acces interne
     * @return type
     */
    public function accesinterneAction(){
        return;
         $aut=  Zend_Auth::getInstance();
        
        if($aut->hasIdentity() && $aut->getIdentity()=="bzUser" ){
            
            $this->_helper->redirector("index","accueil");
        }
        
        
    }
    
    
    public function mpoAction(){

        $login=$this->getRequest()->getParam("login");

        $stmt = $this->_db->prepare("execute ps_ExtWMailLite @login='$login'");
                   $this->_helper->LogPs("compte :ps_ExtWMailLite  @login='$login'");
                   try{
                        $stmt->execute();
                        $result=$stmt->fetchAll();
                       }catch(Zend_Exception $e){
                           /**
                            * traitement des erreures
                            */
                        echo $e->getMessage();
                      }

                        
                        //Zend_Debug::dump($result,"ps_ExtWMailLite");
        
        
        if(!$result[0]['erreur']){
            
            $result=$result[0]["url"];
            $from="commercial@beuzelin.fr";
            $to=$login;
            $to="bruno.rotrou@gmail.com";
            $subject=utf8_decode("Demande modification de votre mot de passe");
            $message=utf8_decode("Bonjour,<br/> Vous avez demandé la modification de votre mot de passe.\nVeuillez cliquer sur le lien ci-dessous, pour accéder a la page de modification\n").utf8_decode($result).utf8_decode("\nSi vous n'etes pas a l'origine de cette demande veuillez ne pas cliquer sur le lien et contacter un commercial.");
            
            $message='
       <p>
       Bonjour,<br/> Vous avez demandé la modification de votre mot de passe.<br/>
       Veuillez cliquer sur le lien ci-dessous, pour accéder à la page de modification.<br/>
       </p>
       
          <a href="'.utf8_decode($result).'"> '. utf8_decode($result).'</a><br/>
      
        
       <p>
           Si vous n\'êtes pas à l\'origine de cette demande veuillez ne pas cliquer sur le lien et contacter un commercial.<br/>
       </p>
       <p>
        Cordialement
       </p>
       <table>
           <tbody>
               <tr>
                   <td><img src="http://www.e-bzgrains.com/images/metier/logoBz.png" height="93px" width="71px"/></td>
                   <td style="padding-left:15px;">Service commercial SAS Beuzelin</br> <a href="mailto:commercial@beuzelin.fr">commercial@beuzelin.fr</a></br>02 32 67 20 60</td>
               </tr>
           </tbody>
       </table>
      ';
            
            
        }else{
            $this->_helper->json(array("message"=>"Une erreur s'est produite, l'email n'a pas été envoyé."));
        }
        
         $header = "From: ".$from." <".$from.">\r\n";
         $header .= "Reply-To: ".$from."\r\n";
         $header .= "MIME-Version: 1.0\r\n";
         $header .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
            
        if(mail($to,$subject,  utf8_decode($message),$header)){
            $this->_helper->json(array("message"=>"Un email à été correctement envoyé, consultez votre messagerie, puis cliquez sur le lien."));
        }else{
            $this->_helper->json(array("message"=>"Une erreur s'est produite, l'email n'a pas été envoyé."));
        }
        
    }



}

