/**
 * Copyright phi16 ( http://wonderfl.net/user/phi16 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/mI1c
 */

package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    public class Hourglass extends Sprite {
        public var spr:Sprite=new Sprite();
        public var sand1:Sand;
        public var sand2:Sand;
        public var time:int=0;
        public var mox:Number,moy:Number;
        public var va:int=0;
        public function Hourglass(){
            this.addChild(spr);
            sand1=new Sand(4,0,0);
            sand2=new Sand(4,0,0);
            sand2.state=5;
            this.addEventListener(Event.ENTER_FRAME,frame);
            spr.rotation=45;
        }
        public function frame(e:Event):void{
            spr.graphics.clear();
            spr.graphics.beginFill(0);
            spr.graphics.drawRect(0,-340,680,680);
            spr.graphics.endFill();
            if(va==0){
                sand1.draw(spr.graphics,465/1.414*3/4,-465/1.414/4,8);
                sand2.draw(spr.graphics,465/1.414*5/4,465/1.414*1/4,8);
                time++;
                if(time%2==0){
                    var p:Particle=sand1.drop();
                    if(p.data){
                        sand2.px=-Math.pow(2.1,4)*1.1/2-1;
                        sand2.py=-Math.pow(2.1,4)*1.1/2-1;                    
                        sand2.pEnable=true; 
                    }
                }
                if(time%1==0)sand2.fill();
                sand1.step();
                sand2.step();
                if(sand2.state==0){
                    mox=5;
                    moy=1;
                    time=0;
                    va=1;
                }
            }else{
                sand2.draw(spr.graphics,465/1.414/4*mox,465/1.414/4*moy,8);
                mox+=(3-mox)/2.0;
                moy+=(-1-moy)/2.0;
                time++;
                if(time>10){
                    sand1=new Sand(4,0,0);
                    sand2=new Sand(4,0,0);
                    sand2.state=5;
                    time=0;
                    va=0;
                }
            }
        }
    }
}
import flash.display.Graphics;

class Particle {
    public var x:Number,y:Number;
    public var tx:Number,ty:Number;
    public var enable:Boolean,motion:Boolean;
    public var data:Boolean;
    public function Particle(){
        enable=true;
        motion=false;
        data=false;
    }
}

function noParticle():Particle{
    var p:Particle=new Particle();
    p.enable=false;
    return p;
}

function motParticle():Particle{
    var p:Particle=new Particle();
    p.motion=true;
    return p;
}

var lx:Array=[-1,1,-1,1];
var ly:Array=[-1,-1,1,1];

class Sand {
    public var s:Number;
    public var x:Number,y:Number;
    public var ts:int;
    public var tx:Number,ty:Number;
    public var state:int;
    public var used:Boolean;
    public var child:Array=new Array();
    public var pEnable:Boolean;
    public var px:Number,py:Number;
    public var tpx:Number,tpy:Number;
    public function Sand(sr:int,xr:Number,yr:Number){
        ts=sr;
        s=Math.pow(2.1,ts);
        x=tx=xr;
        y=ty=yr;
        tpx=tx+lx[0]*Math.pow(2.1,ts)*1.1/2+0.6;
        tpy=ty+ly[0]*Math.pow(2.1,ts)*1.1/2+0.6;
        state=0;//0,1,[2,3,4],[5,6],[7,8],9
        used=false;
    }
    public function drop():Particle{
        var p:Particle=new Particle();
        if(ts==0){
            p.x=x,p.y=y;
            p.enable=false;
            p.data=true;
            used=true;
            return p;
        }else{
            switch(state){
                case 0:{
                    for(var i:int=0;i<4;i++){              
                        var d:Sand=new Sand(ts,tx,ty);
                        d.ts=ts-1;
                        d.tx=tx+lx[i]*Math.pow(2.1,ts-1)*1.1/2;
                        d.ty=ty+ly[i]*Math.pow(2.1,ts-1)*1.1/2;
                        child.push(d);
                    }
                    state=1;
                }break;
                case 1:{
                    p=child[3].drop();
                    if(!p.enable && !p.motion){
                        state=2;
                        child[3]=null;
                        p.enable=true;
                    }
                    return p;
                }break;
　　　　　　　　　 case 2:{
　　　　　　　　　     child[2].tx=tx+lx[3]*Math.pow(2.1,ts-1)*1.1/2;
　　　　　　　　　     child[2].ty=ty+ly[3]*Math.pow(2.1,ts-1)*1.1/2;
　　　　　　　　　     state=3;
　　　　　　　　　 }break;
　　　　　　　　　 case 3:{
　　　　　　　　　     child[0].tx=tx+lx[2]*Math.pow(2.1,ts-1)*1.1/2;
　　　　　　　　　     child[0].ty=ty+ly[2]*Math.pow(2.1,ts-1)*1.1/2;
　　　　　　　　　     state=4;
　　　　　　　　　 }break;
　　　　　　　　　 case 4:{
　　　　　　　　　     p=child[2].drop();
                    if(!p.enable){
                        state=5;
                        child[2]=null;
                        p.enable=true;
                    }
                    return p;
　　　　　　 　　 }break;
　　　　　　　　　 case 5:{
　　　　　　　　　     child[1].tx=tx+lx[3]*Math.pow(2.1,ts-1)*1.1/2;
　　　　　　　　　     child[1].ty=ty+ly[3]*Math.pow(2.1,ts-1)*1.1/2;
　　　　　　　　　     state=6;
　　　　　　　　　 }break;
　　　　　　　　　 case 6:{
　　　　　　　　　     p=child[1].drop();
                    if(!p.enable){
                        state=7;
                        child[1]=null;
                        p.enable=true;
                    }
                    return p;
　　　　　　　　　 }break;
　　　　　　　　　 case 7:{
　　　　　　　　　     child[0].tx=tx+lx[3]*Math.pow(2.1,ts-1)*1.1/2;
　　　　　　　　　     child[0].ty=ty+ly[3]*Math.pow(2.1,ts-1)*1.1/2;
　　　　　　　　　     state=8;
　　　　　　　　　 }break;
　　　　　　　　　 case 8:{
　　　　　　　　　     p=child[0].drop();
                    if(!p.enable){
                        state=9;
                        child=null;
                        p.enable=false;
                        p.data=true;
                        return p;
                    }
                    return p;
　　　　　　　　　 }break;
　　　　　　　　　 case 9:{
　　　　　　　　　     return noParticle();
　　　　　　　　　 }
            }
        }
        return motParticle();
    }
    public function fill():void{
        if(ts==0 && pEnable){
            state=0;
            tpx=tx;
            tpy=ty;
        }else if(ts!=0){
            if(state==5){
                for(var i:int=0;i<4;i++){                    
                    var d:Sand=new Sand(ts,tx,ty);
                    d.ts=ts-1;
                    d.tx=tx+lx[i]*Math.pow(2.1,ts-1)*1.1/2;
                    d.ty=ty+ly[i]*Math.pow(2.1,ts-1)*1.1/2;
                    d.state=5;
                    child.push(d);
                }
                state=4;
            }
            while(state>0 && child[state-1].state==0)state--;
            if(state>0)child[state-1].fill();
            if(state>0 && pEnable){
                child[state-1].pEnable=true;
                child[state-1].px=px;
                child[state-1].py=py;
                pEnable=false;
            }
        }
    }
    public function step():void{
        x+=(tx-x)/2.0;
        y+=(ty-y)/2.0;
        if(pEnable){
            px+=(tpx-px)/2.0;
            py+=(tpy-py)/2.0;
        }
        s+=(Math.pow(2.1,ts)-s)/2.0;
        if(child!=null)for(var i:int=0;i<4;i++){
            if(child[i]!=null){
                child[i].step();
            }
        }
    }
    public function draw(g:Graphics,bx:Number,by:Number,scale:Number):void{
        if((!pEnable || ts!=0) && state==0){
            var u:Number=s*scale;
            var ux:Number=bx+x*scale+u/2,uy:Number=by+y*scale+u/2;
            var cr:Number,cg:Number,cb:Number;
            if(ux<465/1.414){
                cr=1;
                cg=(ux-465/1.414/2*1.45)/(465/1.414/4*1.1);
                cb=(uy+465/1.414/2*0.0)/(465/1.414/4*1.1);
            }else{
                cr=cg=cb=1;
            }
            g.beginFill(Math.floor(cr*0xff)*0x10000+Math.floor(cg*0xff)*0x100+Math.floor(cb*0xff));
            g.drawRect(ux-u,uy-u,u,u);
            g.endFill();
        }else if(child!=null){
            for(var i:int=0;i<4;i++){
                if(child[i]!=null)child[i].draw(g,bx,by,scale);
            }
        }
        if(pEnable){
            g.beginFill(0xffffff);
            u=1*scale;
            g.drawRect(bx+px*scale-u/2,by+py*scale-u/2,u,u);
            g.endFill();
        }
    }
}
