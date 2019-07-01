<{if $this->nav()}>
   <div class="navLeftMenu unselectable">
       <table id="t_menu">
            <thead>
                    <tr>
                        <td class="thead_td"></td>
                        <td></td>
                    </tr>
            </thead>
            <tbody>   
                <{foreach from=$this->nav() item=bzmenu name=n_bzmenu}>
                
                
                    <tr class="row_menu <{if $smarty.foreach.n_bzmenu.last}> last<{/if}>">
                        <td class="main_menu <{if $smarty.foreach.n_bzmenu.first}> active<{/if}>" rubrique="<{$bzmenu.rubrique}>" action="<{$bzmenu.code}>" >
                            <ul>
                                <li><{$bzmenu.nom}>
                                    <ul class="lst_sub_menu <{if $smarty.foreach.n_bzmenu.first}> active<{/if}>">
                                        <{foreach from=$bzmenu->submenu item=submenu}>
                                            <li class="<{if $submenu.checked==1}>subMenuActive<{else}>subMenuInactive<{/if}>"><{$submenu.nom}></li>
                                        <{/foreach}>
                                    </ul>
                                </li>
                            </ul>
                        </td>        
                    </tr>
                 

                <{/foreach}>
            </tbody>
       </table> 
       <!---- les balises de scripts chargées en ajax ne semblent pas s'afficher dans firebug -->     
       <script>
      
      $("#t_menu tr td").click(function(){
            
            
            
            var _action=$(this).attr("action");
            var _rubrique=$(this).attr("rubrique");
            
            _gaq.push (['_trackEvent',_rubrique,_action,'click menu left']);
            
            // pour <th> first
            if(!_rubrique || !_action) return false;
            


            
            $(".row_menu  td").removeClass("active");
            $(this).addClass("active");

            location.hash=_rubrique+"_"+_action;
            
           
            
      })
      
      
      
       </script>  
       <script>
            //display menu
            $("#c_left").empty();
            $('.navLeftMenu').appendTo("#c_left");
            $("#c_left").css("display","block");
       </script>
    </div>
<{/if}>     
  