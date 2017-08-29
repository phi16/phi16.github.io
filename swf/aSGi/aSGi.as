/**
 * Copyright phi16 ( http://wonderfl.net/user/phi16 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/aSGi
 */

package {
    import flash.utils.Proxy;
    import flash.display.InterpolationMethod;
    import flash.events.DataEvent;
    import flash.display.Sprite;
    import flash.events.Event;
    public class SplineClock extends Sprite {
        public var spr:Sprite=new Sprite();
        public var fade:Sprite=new Sprite();
        public var back:Sprite=new Sprite();
        private var rad:Number=0;
        private var dirx:Number=0,diry:Number=0;
        private var particles:Array;
        private var time:int;
        private var i:int;
        private var tpos:int;
        private var numbpos:Array=new Array(
            1,1,1, 1,0,1, 1,0,1, 1,0,1, 1,1,1,
            0,0,1, 0,0,1, 0,0,1, 0,0,1, 0,0,1,
            1,1,1, 0,0,1, 1,1,1, 1,0,0, 1,1,1,
            1,1,1, 0,0,1, 1,1,1, 0,0,1, 1,1,1,
            1,0,1, 1,0,1, 1,1,1, 0,0,1, 0,0,1,
            1,1,1, 1,0,0, 1,1,1, 0,0,1, 1,1,1,
            1,1,1, 1,0,0, 1,1,1, 1,0,1, 1,1,1,
            1,1,1, 0,0,1, 0,0,1, 0,0,1, 0,0,1,
            1,1,1, 1,0,1, 1,1,1, 1,0,1, 1,1,1,
            1,1,1, 1,0,1, 1,1,1, 0,0,1, 1,1,1,
            0,0,0, 0,1,0, 0,0,0, 0,1,0, 0,0,0);
            
        public function SplineClock() {
            this.addChild(back);
            this.addChild(fade);
            this.addChild(spr);
            back.graphics.beginFill(0x000000);
            back.graphics.drawRect(0,0,465,465);
            back.graphics.endFill();
            particles=new Array();
            for(i=0;i<100;i++){
                particles[i]=new Points();
            }
            this.addEventListener(Event.ENTER_FRAME,this.Draw);
        }
        private function Draw(e:Event):void{
            var date:Date=new Date();
            var sec:int=date.getSeconds();
            tpos=sec%60*6-90;
            rad=sec*-30;//+date.getMilliseconds()%1000*45/1000;
            var colr:int,colg:int,colb:int;
            colr=(Math.sin(rad*Math.PI/180)+1)*255/2;
            colg=(Math.sin((rad+120)*Math.PI/180)+1)*255/2;
            colb=(Math.sin((rad-120)*Math.PI/180)+1)*255/2;
            var ps:Number=date.getMilliseconds()%1000;
            if(time!=sec){
                time=sec;
                var dth:int=date.getHours(),dtm:int=date.getMinutes(),dts:int=date.getSeconds();
                dts+=2;
                if(dts>=60)dts%=60,dtm++;
                if(dtm>=60)dtm%=60,dth++;
                dth%=24;
                var setter:Array=new Array(Math.floor(dth/10),Math.floor(dth%10),10,Math.floor(dtm/10),Math.floor(dtm%10),10,Math.floor(dts/10),Math.floor(dts%10));
                var partset:Array=new Array();
                var posx:int=0;
                var partcount:int=0;
                var cx:int=0,cy:int=0;
                for(i=0;i<8;i++){
                    for(cx=0;cx<3;cx++){
                        for(cy=0;cy<5;cy++){
                            if(numbpos[setter[i]*15+cy*3+cx]){
                                partset[partcount]=new int(cx+posx+cy*28);
                                partcount++;
                            }
                        }
                    }
                    if(i==0 || i==3 || i==6)posx+=4;
                    else posx+=3;
                }
                for(i=0;i<100;i++){
                    particles[i].x0=particles[i].x1,particles[i].x1=particles[i].x2,particles[i].x2=particles[i].x3;
                    particles[i].y0=particles[i].y1,particles[i].y1=particles[i].y2,particles[i].y2=particles[i].y3;
                    if(partcount>i){
                        particles[i].x3=(465-432+16)/2+partset[i]%28*16;
                        particles[i].y3=(465-80)/2+partset[i]/28*16;
                    }else{
                        particles[i].x3=465/2+Math.cos(((i+2-partcount)*360/(100-partcount)+tpos)*Math.PI/180)*240;
                        particles[i].y3=465/2+Math.sin(((i+2-partcount)*360/(100-partcount)+tpos)*Math.PI/180)*240;
                    }
                }
                for(i=0;i<partcount;i++){
                    var j:int=Math.floor(Math.random()*partcount);
                    var p:Points=particles[i];
                    particles[i]=particles[j];
                    particles[j]=p;
                }
                fade.graphics.clear();
                fade.graphics.beginFill(colr*256*256+colg*256+colb);
                for(i=0;i<100;i++){
                    fade.graphics.drawCircle(particles[i].x1,particles[i].y1,8);
                }
                fade.graphics.endFill();
            }
            spr.graphics.clear();
            spr.graphics.beginFill(colr*256*256+colg*256+colb);
            for(i=0;i<100;i++){
                spr.graphics.drawCircle(particles[i].GetX(ps/1000),particles[i].GetY(ps/1000),8);
            }
            spr.graphics.endFill();
            fade.alpha=1-ps/1000;
            rad++;
        }
    }
}

class Points{
    public var x0:Number,x1:Number,x2:Number,x3:Number,y0:Number,y1:Number,y2:Number,y3:Number;
    public function Points(){
        x0=x1=x2=x3=235;
        y0=y1=y2=y3=235;
    }
    public function Set(x_:Number,y_:Number):void{
        x3=x_;
        y3=y_;
    }
    public function GetX(t:Number):Number{
        var v0:Number=(x2-x0)*0.5;
        var v1:Number=(x3-x1)*0.5;
        return (2*x1-2*x2+v0+v1)*t*t*t+(-3*x1+3*x2-2*v0-v1)*t*t+v0*t+x1;
    }
    public function GetY(t:Number):Number{
        var v0:Number=(y2-y0)*0.5;
        var v1:Number=(y3-y1)*0.5;
        return (2*y1-2*y2+v0+v1)*t*t*t+(-3*y1+3*y2-2*v0-v1)*t*t+v0*t+y1;
    }
}