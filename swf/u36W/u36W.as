/**
 * Copyright phi16 ( http://wonderfl.net/user/phi16 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/u36W
 */

package {
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.ui.Keyboard;
    public class MazeSolver extends Sprite{
        private var q:int = 465;
        private var bmp:BitmapData = new BitmapData(q,q,false,0);//Base Maze
        private var col:BitmapData = new BitmapData(q,q,false,0xffffff);//Color layer
        private var rbd:BitmapData = new BitmapData(q,q,false,0x7f7f7f);//Route starting from Mouse
        private var stp:BitmapData = new BitmapData(q,q,false,0x7f7f7f);//Route starting from sPos
        private var bsp:BitmapData = new BitmapData(q,q,false,0x7f7f7f);//Adjustment
        private var bg:Sprite = new Sprite();
        private var cls:Sprite = new Sprite();
        private var rou:Sprite = new Sprite();
        private var sti:Sprite = new Sprite();
        private var bas:Sprite = new Sprite();
        private var i:uint,j:uint;
        private var edge:Array=[];
        private var tree:Array=[];
        private var sPos:uint=((q-1)/2+1)*(1+q);//center    
        private var state:Boolean=true;
        public function MazeSolver(){
            setMaze();
            sti.graphics.beginBitmapFill(bsp);
            sti.graphics.drawRect(0,0,q,q);
            sti.graphics.endFill();
            bas.graphics.beginBitmapFill(bsp);
            bas.graphics.drawRect(0,0,q,q);
            bas.graphics.endFill();
            cls.blendMode="darken";
            rou.blendMode="overlay";
            sti.blendMode="difference";
            bas.blendMode="add";
            rou.addChild(sti);
            rou.addChild(bas);
            addChild(bg);
            addChild(cls);
            addChild(rou);
            addEventListener(MouseEvent.CLICK, onClick);
            addEventListener(Event.ENTER_FRAME, onFrame);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            changeState(false);
        }
        private function setMaze():void{
            bmp.fillRect(new Rectangle(0,0,q,q),0);
            col.fillRect(new Rectangle(0,0,q,q),0xffffff);
            generateMaze()
            bg.graphics.beginBitmapFill(bmp);
            bg.graphics.drawRect(0,0,q,q);
            bg.graphics.endFill();
            cls.graphics.beginBitmapFill(col);
            cls.graphics.drawRect(0,0,q,q);
            cls.graphics.endFill();
            drawStartRoute();
        }
        private function generateMaze():void{
            edge=[];
            for(i=1;i<q-1;i++){
                for(j=1;j<q-1;j++){
                    if(i%2==1 && j%2==1)bmp.setPixel(i,j,i+j*q);
                    else if(i%2==1 || j%2==1)edge.push(i+j*q);
                }
            }
            var e:int=edge.length;
            i=e;
            while(i--){
                j=Math.floor(Math.random()*(i+1));
                var tm:uint=edge[i];
                edge[i]=edge[j];
                edge[j]=tm;
            }
            for(i=0;i<e;i++)runKruskal(i);
            for(i=1;i<q-1;i+=2){
                for(j=1;j<q-1;j+=2){
                    bmp.setPixel(i,j,0xffffff);
                }
            }
            generateTree(sPos,0,0);//from Center
        }
        private function runKruskal(idx:uint):void{
            if(idx >= edge.length)return;
            else{
                var e:uint=edge[idx];
                var a:uint,b:uint;
                if((e%q)%2==1){//Vertical
                    a=e-q;
                    b=e+q;
                }else{
                    a=e-1;
                    b=e+1;
                }
                if(find(a)!=find(b)){
                    bmp.setPixel(e%q,e/q,0xffffff);
                    unite(a,b);
                }
            }
        }
        private function unite(a:uint, b:uint):void{
            var x:uint=find(a);
            var y:uint=find(b);
            bmp.setPixel(x%q,x/q,y);
        }
        private function find(x:uint):uint{
            var p:uint=bmp.getPixel(x%q,x/q);
            if(p == x)return p;
            var r:uint=find(p);
            bmp.setPixel(x%q,x/q,r);
            return r;
        }
        private function generateTree(p:uint,par:uint,dist:int):void{
            var t:Tree=tree[p]=new Tree(p,par);
            col.setPixel(p%q,p/q,getColor(dist));
            dist++;
            if(bmp.getPixel(p%q,p/q-1) && p-2*q!=par)col.setPixel(p%q,p/q-1,getColor(dist)),generateTree(p-2*q,p,dist),t.child.push(p-2*q);
            if(bmp.getPixel(p%q,p/q+1) && p+2*q!=par)col.setPixel(p%q,p/q+1,getColor(dist)),generateTree(p+2*q,p,dist),t.child.push(p+2*q);
            if(bmp.getPixel(p%q-1,p/q) && p-2!=par)col.setPixel(p%q-1,p/q,getColor(dist)),generateTree(p-2,p,dist),t.child.push(p-2);
            if(bmp.getPixel(p%q+1,p/q) && p+2!=par)col.setPixel(p%q+1,p/q,getColor(dist)),generateTree(p+2,p,dist),t.child.push(p+2);
        }
        private function getPos():uint{
            var x:uint=mouseX;
            var y:uint=mouseY;
            x=uint(x/2)*2+1;
            y=uint(y/2)*2+1;
            if(x<1)x=1;
            if(y<1)y=1;
            if(x>q-2)x=q-2;
            if(y>q-2)y=q-2;
            return x+y*q;
        }
        public function getColor(i:Number):int{
            var colr:int,colg:int,colb:int;
            var c:Number=0;
            var num:int=q*1.5;
            colr=(Math.sin((i*360/num+c)*Math.PI/180)+1)*255/4;
            colg=(Math.sin((i*360/num+120+c)*Math.PI/180)+1)*255/4;
            colb=(Math.sin((i*360/num-120+c)*Math.PI/180)+1)*255/4;
            return colr*256*256+colg*256+colb;
        }
        
        private function drawStartRoute():void{
            stp.fillRect(new Rectangle(0,0,q,q),state?0x7f7f7f:0);
            var t:Tree=tree[sPos];
            while(t!=null){
                stp.setPixel(t.p%q,t.p/q,state?0xffffff:0x00ffff);
                var y:uint=(t.p+t.par)/2;
                stp.setPixel(y%q,y/q,state?0xffffff:0x00ffff);
                t=tree[t.par];
            }
            sti.graphics.clear();
            sti.graphics.beginBitmapFill(stp);
            sti.graphics.drawRect(0,0,q,q);
            sti.graphics.endFill();
        }

        private function onClick(e:MouseEvent):void{
            sPos=getPos();
            drawStartRoute();
        }
        private function onFrame(e:Event):void{
            rbd.fillRect(new Rectangle(0,0,q,q),state?0x7f7f7f:0);
            var t:Tree=tree[getPos()];
            while(t!=null){
                rbd.setPixel(t.p%q,t.p/q,state?0xffffff:0x00ffff);
                var y:uint=(t.p+t.par)/2;
                rbd.setPixel(y%q,y/q,state?0xffffff:0x00ffff);
                t=tree[t.par];
            }
            rou.graphics.clear();
            rou.graphics.beginBitmapFill(rbd);
            rou.graphics.drawRect(0,0,q,q);
            rou.graphics.endFill();
        }
        private function onKeyDown(e:KeyboardEvent):void{
            if(e.keyCode == Keyboard.ENTER)changeState(!state);
            if(e.keyCode == Keyboard.SPACE)setMaze();
        }
        private function changeState(b:Boolean):void{
            state=b;
            if(state){
                cls.alpha=1;
                rou.blendMode="overlay";
                bas.blendMode="add";
            }else{
                cls.alpha=0;
                rou.blendMode="multiply";
                bas.blendMode="invert";
            }
            drawStartRoute();
        }
    }
}

class Tree{
    public var p:uint;
    public var par:uint;
    public var child:Array=[];//uint
    public function Tree(p_:uint, par_:uint){
        p=p_,par=par_;
    }
}
