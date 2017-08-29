/**
 * Copyright phi16 ( http://wonderfl.net/user/phi16 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/lBXR
 */

package {
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.display.AVM1Movie;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    public class Recv extends Sprite {
        public var spr:Sprite=new Sprite();
        private var rad:Number=0;
        private var vertexslist:Array=new Array();
        private var count:int=1;
        private var clicking:Boolean=false;
        private var stmx:Number,stmy:Number;
        public function Recv(){
            spr.x=spr.y=465/2;
            vertexslist[0]=new Trig();
            vertexslist[0].r=465/2-1;
            this.addChild(spr);
            this.addEventListener(MouseEvent.MOUSE_DOWN,this.onClkDn);
            this.addEventListener(MouseEvent.MOUSE_UP,this.onClkUp);
            this.addEventListener(Event.ENTER_FRAME,this.Draw);
        }
        private function Draw(e:Event):void{
            spr.graphics.clear();
            spr.graphics.beginFill(0x000000);
            spr.graphics.drawRect(-465/2,-465/2,465,465);
            spr.graphics.endFill();
            var colr:int,colg:int,colb:int;
            colr=(Math.sin((rad)*Math.PI/180)+1)*255/2;
            colg=(Math.sin((120+rad)*Math.PI/180)+1)*255/2;
            colb=(Math.sin((-120+rad)*Math.PI/180)+1)*255/2;
            spr.graphics.lineStyle(2,colr*256*256+colg*256+colb);
            if(clicking){
                var x:Number=stmx-465/2,y:Number=stmy-465/2;
                var mx:Number=this.mouseX-465/2,my:Number=this.mouseY-465/2;
                vertexslist[count-1].x=x*Math.cos(-rad*Math.PI/180)-y*Math.sin(-rad*Math.PI/180);
                vertexslist[count-1].y=x*Math.sin(-rad*Math.PI/180)+y*Math.cos(-rad*Math.PI/180);
                vertexslist[count-1].r=Math.sqrt((x-mx)*(x-mx)+(y-my)*(y-my));
                vertexslist[count-1].d=(my-y!=0 && mx-x!=0?Math.atan2(my-y,mx-x)*180/Math.PI-rad:-rad);
            }
            Recursive(0,0,465/2-1,rad);
            spr.graphics.endFill();
            if(!clicking)rad+=2;
        }
        private function onClkDn(e:MouseEvent):void{
            clicking=true;
            stmx=this.mouseX;
            stmy=this.mouseY;
            vertexslist[count]=new Trig();
            count++;
        }
        private function onClkUp(e:MouseEvent):void{
            clicking=false;
        }
        private function Recursive(x:Number,y:Number,r:Number,d:Number):void{
            for(var i:int=0;i<count;i++){
                var tr:Trig=new Trig();
                tr.x=x+(Math.cos(d*Math.PI/180)*vertexslist[i].x-Math.sin(d*Math.PI/180)*vertexslist[i].y)*r/(465/2-1);
                tr.y=y+(Math.sin(d*Math.PI/180)*vertexslist[i].x+Math.cos(d*Math.PI/180)*vertexslist[i].y)*r/(465/2-1);
                tr.r=r*vertexslist[i].r/(465/2-1);
                tr.d=d+vertexslist[i].d;
                if(tr.r<5 || tr.r>465/2-1)continue;
                drawTriangle(tr.x,tr.y,tr.r,tr.d);
                if(i==0)continue;
                Recursive(tr.x,tr.y,tr.r,tr.d);
            }
        }
        private function drawTriangle(x:Number,y:Number,r:Number,d:Number):void{
            spr.graphics.moveTo(x+r*Math.cos(d*Math.PI/180),y+r*Math.sin(d*Math.PI/180));
            spr.graphics.lineTo(x+r*Math.cos((d+120)*Math.PI/180),y+r*Math.sin((d+120)*Math.PI/180));
            spr.graphics.lineTo(x+r*Math.cos((d-120)*Math.PI/180),y+r*Math.sin((d-120)*Math.PI/180));
            spr.graphics.lineTo(x+r*Math.cos(d*Math.PI/180),y+r*Math.sin(d*Math.PI/180));
        }
    }
}

class Trig{
    public var x:Number,y:Number,r:Number,d:Number;
    public function Trig(){
        x=y=r=d=0;
    }
}