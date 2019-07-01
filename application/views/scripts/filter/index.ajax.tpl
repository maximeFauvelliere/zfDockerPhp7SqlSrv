
   <div id="D_filter">
       
            <div id="F_ch">
                <input type="checkbox" id="ttc">tout sélectionner</input><br/>
                <input type="checkbox" id="mySel">ma selection</input><br/>
            </div>
            <div id="T_camp" class="T_F"><span>Campagnes</span></div>
            <div id="F_camp">
                <{if $this->bzfilter}>
                    <{foreach from=$this->bzfilter item=filter name=n_filter}>  
                        <{foreach from=$filter->camp item=camp name=n_camps}>
                            <input class="filterInput" type="radio" name="camp" idcamp='<{$camp.idcamp}>'  <{if $camp.checked==1}>checked='checked'<{/if}>><{$camp.idcamp}></input><br/>
                        <{/foreach}>
                    <{/foreach}>
                <{/if}>
            </div>
            <div id="T_cult" class="T_F"><span>Cultures</span></div>
            <div id="F_cult">
                 <{if $this->bzfilter}>
                    <{foreach from=$this->bzfilter item=filter name=n_filter}>  
                        <{foreach from=$filter->culture item=culture name=n_camps}>
                            <input class="filterInput" type="checkbox" name='cultures' idcu='<{$culture.clecu}>'  <{if $culture.checked==1}>checked='checked'<{/if}>><{$culture.lib}></input><br/>
                        <{/foreach}>
                    <{/foreach}>
                <{/if}>
            </div>
            <div id="T_st" class="T_F"><span>Structures</span></div>
            <div id="F_struct">
<!--                  <input class="filterInput" id='pasStructures' type="checkbox" name='structures' idti='0'>Non attribuées</input><br/>-->
                  <{if $this->bzfilter}>
                    <{foreach from=$this->bzfilter item=filter name=n_filter}>  
                        <{foreach from=$filter->structure item=structure name=n_camps}>
                            <input class="filterInput" type="checkbox" name='structures' idti='<{$structure.idti}>' <{if $structure.checked==1}>checked='checked'<{/if}>><{$structure.nom}></input><br/>
                        <{/foreach}>
                    <{/foreach}>
                <{/if}>
            </div>
            <div id="rec_filter">enregistrer ma selection</div>


        </div>
