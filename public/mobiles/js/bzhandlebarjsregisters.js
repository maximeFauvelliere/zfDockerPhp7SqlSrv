/**
                 * register pour marche block a,b,c
                 * @type Array
                 */
                Handlebars.registerHelper("foreachmarches",function(arr,options) {
                    
                    arr=convertElementToArray(arr);
                    
                    if(options.inverse && !arr.length)
                        return options.inverse(this);
                    

                    return arr.map(function(item,index) {
                        if(index===0) item.$block="a";
                        if(index===1) item.$block="b";
                        if(index===2) item.$block="c";
                        if(item.var.match(/\+/)) {
                            item.$var="up";
                        }else if(item.var.match(/\-/)) {
                            item.$var="low";
                        }else{
                            item.$var="equal";
                        }
                         if(!item.isunlock) {
                             item.$isunlock="acc-marches-cad-tolock";
                         }
                        
                        
                        return options.fn(item);
                    }).join('');
            });
            
           
            
            Handlebars.registerHelper("foreach",function(arr,options) {
                
                    arr=convertElementToArray(arr);
                    
                    if(options.inverse && !arr.length) return options.inverse(this);
                        //console.log("this[0]",this[Object.keys(this)[0]]);
                   
                   
                    return arr.map(function(item,index) {
                         
                        if(index===0) item.$block="a";
                        if(index===1) item.$block="b";
                        if(index===2) item.$block="c";

                        return options.fn(item);
                    }).join('');
            });
         
            
            /**
            *
            *bzeach register global enfant pour boucle handlebarjs
            *
            **/
               Handlebars.registerHelper("bzeach",function(arr,options) {
       
                            //console.log("arr",arr)
                            arr=convertElementToArray(arr);
                    
                            //console.log("arr",arr);
                    
                            if(options.inverse && !arr.length) return options.inverse(this);

                            return arr.map(function(item,index) {
                                //console.log("item",item);
                                //console.log("index",index)
                                item.$index = index;
                                return options.fn(item);
                            }).join('');
                });
                
                
                 Handlebars.registerHelper('bzIf', function(v1, v2, options) {
         
                    if(v1 === v2) {
                                return options.fn(this);
                    }
                    return options.inverse(this);
                });
                
   
   Handlebars.registerHelper("eachoffre",function(arr,options) {
           
                            arr=convertElementToArray(arr);
                    
                            //console.log("arr",arr);
                    
                            if(options.inverse && !arr.length) return options.inverse(this);

                            return arr.map(function(item,index) {
                                //console.log("item",item);
                                //console.log("index",index)
                                return options.fn(item);
                            }).join('');
                });
                
                
                    Handlebars.registerHelper('ifmarches', function(variation,options) {
   
                if(variation>this.var.match(/\+/)) {
                      return options.fn(this);
                    }
                    return options.inverse(this);
                 });
                 
                
                 
              Handlebars.registerHelper('ifmarches2', function(variation,options) {

                    if(variation>this.var.match(/\-/)) {
                      return options.fn(this);
                    }
                    return options.inverse(this);
               });
               
                
                Handlebars.registerHelper('ifunlock', function(isunlock,options) {

                        if(parseInt(isunlock)) {
                          return options.fn(this);
                        }
                        return options.inverse(this);
                 });