/**
 * Copyright phi16 ( http://wonderfl.net/user/phi16 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/wgf9
 */

package {
    import flash.display.Sprite;
    import flash.events.*;
    import flash.text.*;
    public class FlashTest extends Sprite {
        private var spr:Sprite = new Sprite();
        private var cir:Array = new Array;
        private var score:Number = 0;
        private var centerX:Number = 0;
        private var centerY:Number = 0;
        private var cmx:Number = 0, cmy:Number = 0;
        private const num:int= 15;
        private var temp:Number = 100;
        private var tf:TextField = new TextField();
        public function FlashTest() {
            addChild(spr);
            addChild(tf);
            addEventListener(Event.ENTER_FRAME,loop);
            for(var i:int = 0;i<num;i++){
                cir.push({x:Math.random()*465,y:Math.random()*465,r:Math.random()*100+20});
            }
            score = calcScore();
        }
        public function loop(e:Event):void{
            spr.graphics.clear();
            spr.graphics.beginFill(0);
            for(var i:int = 0;i<num;i++){
                spr.graphics.drawCircle(cir[i].x-centerX+465/2,cir[i].y-centerY+465/2,cir[i].r);
            }
            spr.graphics.endFill();
            cmx += (centerX - cmx)/4.0;
            cmy += (centerY - cmy)/4.0;
            for(i=0;i<100;i++)select();
            temp *= 0.99;
            tf.text = String(score)+"\n"+String(temp);
        }
        public function calcScore():Number{
            var par:Array = new Array();
            for(var i:int = 0;i<num;i++)par.push(-1);
            do{
                var update:Boolean = false;
                for(i=0;i<num;i++){
                    for(var u:int = 0;u<num;u++){
                        if(par[i] == par[u]){
                            var le:Number = Math.sqrt(Math.pow(cir[i].x-cir[u].x,2)+Math.pow(cir[i].y-cir[u].y,2));
                            if(le+cir[u].r < cir[i].r){
                                par[u] = i;
                                update = true;
                            }
                        }
                    }
                }
            }while(update);//needless?
            var e:Array = new Array();
            centerX = centerY = 0;
            for(i=0;i<num;i++){
                centerX += cir[i].x, centerY += cir[i].y;
                for(var j:int = i+1;j<num;j++){
                    if(par[i] != j && par[j] != i && par[i] != par[j])continue;
                    var len:Number = Math.sqrt(Math.pow(cir[i].x-cir[j].x,2)+Math.pow(cir[i].y-cir[j].y,2));
                    if(len+cir[i].r < cir[j].r)len = cir[j].r - len - cir[i].r;
                    else if(len+cir[j].r < cir[i].r)len = cir[i].r - len - cir[j].r;
                    else len = len - cir[i].r - cir[j].r;
                    e.push(len);
                }
            }
            centerX /= num, centerY /= num;
            var a:Number = 0;
            for(i=0;i<e.length;i++){
                a += e[i];
            }
            a/=e.length;
            a = 15;
            var s:Number = 0;
            for(i=0;i<e.length;i++){
                s += Math.abs(e[i]-a); 
            }
            s /= e.length;
            return s + Math.pow(a-15,2);
        }
        public function select():void{
            var i:int = Math.floor(Math.random()*num);
            var x:Number = cir[i].x;
            var y:Number = cir[i].y;
            var r:Number = cir[i].r;
            var cx:Number = centerX, cy:Number = centerY;
            cir[i].x = Math.random()*465;
            cir[i].y = Math.random()*465;
            cir[i].r = Math.random()*100+20;
            var s:Number = calcScore();
            var p:Number = 0;
            if(s < score)p = 1;
            else p = Math.exp((score - s)/temp);
            if(Math.random() > p)cir[i].r = r, cir[i].x = x, cir[i].y = y, centerX = cx, centerY = cy;
            else score = s;
        }
    }
}