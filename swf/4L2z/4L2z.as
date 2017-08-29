/**
 * Copyright phi16 ( http://wonderfl.net/user/phi16 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/4L2z
 */

package {
    import flash.display.Sprite;
    import flash.events.*;
    public class Poyo extends Sprite {
        private var spr:Sprite = new Sprite();
        private var R:Render = new Render();
        private var time:int = 0;
        private var period:int = 16;
        private var cenX:Number = 0;
        private var cenY:Number = 0;
        private var motX:Number = 0;
        private var motY:Number = 0;
        private var cellX:Array = [3,2,1,0,-1,-2];
        private var cellY:Array = [0,0,0,0,0,0];
        private var dep:Array = [-1,-1,-1,-1,-1,-1];
        private var procSeq:Array = [];
        private var curFree:Boolean = true;
        private var curFreeWait:Boolean = false;
        private var curMove:int = 0;
        private var curDir:int = 1;
        private var vX:Array = [1,0,-1,0];
        private var vY:Array = [0,1,0,-1];
        private var toCellX:int = 3;
        private var toCellY:int = 0;
        private var axisCellX:Number = 0;
        private var axisCellY:Number = 0;
        private var cornerRot:Boolean = false;
        private var face:Poly = new Poly();
        private var clicking:Boolean = false;
        private var clickTime:int = 0;
        private var clearOnce:Boolean = false;
        private var clearCount:int = 0;
        private var clearedPattern:Array = [];
        private var pattern:Array = ["7222","3622","3262","3226","2722","2362","11322","1722","1362","1326","1364"];
        private var badColor:Number = 0.0;
        public function Poyo() {
            stage.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
            stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
            addEventListener(Event.ENTER_FRAME,step);
            addChild(spr);
            face.add(new V(-1,0,-1));
            face.add(new V(1,0,-1));
            face.add(new V(1,0,1));
            face.add(new V(-1,0,1));
            updateShape();
            motX=cenX,motY=cenY;
            update();
        }
        public function updateShape():void{
            var c:int=0;
            cenX=cenY=0;
            for(var i:int=0;i<6;i++){
                if(curFree || curMove!=i)cenX+=cellX[i],cenY+=cellY[i],c++;
            }
            cenX/=c,cenY/=c;
        }
        public function exists(x:int,y:int):Boolean{
            for(var i:int=0;i<6;i++){
                if((curFree || i!=curMove) && cellX[i]==x && cellY[i]==y)return true;
            }
            return false;
        }
        public function one(x:int,y:int):Boolean{
            return Math.abs(Math.abs(x)+Math.abs(y)-1)<0.01;
        }
        public function adj(x:int,y:int):Boolean{
            for(var i:int=0;i<6;i++){
                if((curFree || i!=curMove) && one(cellX[i]-x,cellY[i]-y))return true;
            }
            return false;
        }
        public function update():void{
            var px:int = cellX[curMove],py:int = cellY[curMove];
            px+=vX[curDir],py+=vY[curDir];
            while(exists(px,py)){
                px-=vX[curDir],py-=vY[curDir];
                curDir--;
                if(curDir<0)curDir+=4;
                px+=vX[curDir],py+=vY[curDir];
            }
            if(!adj(px,py)){
                curDir++;
                if(curDir>3)curDir-=4;
                px+=vX[curDir],py+=vY[curDir];
            }
            toCellX=px;
            toCellY=py;
            if(one(cellX[curMove]-toCellX,cellY[curMove]-toCellY)){
                axisCellX = (cellX[curMove]+toCellX)/2;
                axisCellY = (cellY[curMove]+toCellY)/2;
                axisCellX += vX[(curDir+1)%4]/2;
                axisCellY += vY[(curDir+1)%4]/2;
                cornerRot = false;
            }else{
                axisCellX = (cellX[curMove]+toCellX)/2;
                axisCellY = (cellY[curMove]+toCellY)/2;
                cornerRot = true;
            }
        }
        public function fit():void{
            cellX[curMove]=toCellX;
            cellY[curMove]=toCellY;
        }
        public function movePos(t:Number):Object{
            if(t>=1)return {x:toCellX,y:toCellY};
            var dx:Number = cellX[curMove]-axisCellX,dy:Number = cellY[curMove]-axisCellY;
            var r:Number = cornerRot?Math.PI*3/2:Math.PI/2;
            var rx:Number = dx*Math.cos(t*r)-dy*Math.sin(t*r);
            var ry:Number = dx*Math.sin(t*r)+dy*Math.cos(t*r);
            return {x:axisCellX+rx,y:axisCellY+ry};
        }
        public function freeable():Boolean{
            var c:int = 0;
            for(var j:int=0;j<6;j++){
                if(curMove==j)continue;
                if(one(cellX[curMove]-cellX[j],cellY[curMove]-cellY[j]))c++;
            }
            return c==1;
        }
        public function randomSelect():void{
            curFree=false;
            var e:Array = [];
            for(var i:int=0;i<6;i++){
                if(i==curMove)continue;
                var c:int = 0;
                for(var j:int=0;j<6;j++){
                    if(i==j)continue;
                    if(one(cellX[i]-cellX[j],cellY[i]-cellY[j]))c++;
                }
                if(c==1)e.push(i);
            }
            if(e.length!=0){
                curMove = e[Math.floor(Math.random()*e.length)];                
            }
            for(i=0;i<4;i++){
                if(exists(cellX[curMove]+vX[i],cellY[curMove]+vY[i]))curDir=(i+3)%4;
            }
            updateShape();
            update();
        }
        public function step(e:Event):void{
            var i:int;
            if(clickTime<period/4){
                for(i=0;i<6;i++){
                    if(!curFree && i==curMove)continue;
                    var p:Poly = face.clone();
                    if(clearCount==11)p.col=rgb(1,0.5,0);
                    p.translate(new V(cellX[i]*2-motX*2,0,cellY[i]*2-motY*2));
                    R.add(p);
                }
                if(!curFree){
                    var q:Poly = face.clone();
                    q.col = 0xff7f00;
                    var tt:Number = Math.pow((time%period)/period*2,3);
                    var r:Object = movePos(tt);
                    var rr:Number = cornerRot?Math.PI*3/2:Math.PI/2;
                    if(time%period<period/2)q.rotate(Q.rot(V.yAxis(),-tt*rr));
                    q.translate(new V(r.x*2-motX*2,0,r.y*2-motY*2));
                    R.add(q);
                }
            }else{
                var ti:Number = Math.pow((clickTime-period/4)/period/2,3);
                if(ti>1)ti=1;
                var pos:Array=[];
                var qs:Array=[];
                for(var j:int=0;j<6;j++){
                    i = procSeq[j];
                    var fp:Poly = face.clone();
                    fp.col = rgb(badColor,0,0);
                    if(clearCount==11)fp.col=rgb(1,0.5,0);
                    if(dep[i]==i){
                        fp.translate(new V(cellX[i]*2-motX*2,0,cellY[i]*2-motY*2));
                        R.add(fp);
                        pos[i]=new V(cellX[i]*2-motX*2,0,cellY[i]*2-motY*2);
                        qs[i]=Q.e();
                    }else{
                        var qi:Q,d:V;
                        for(var k:int=0;k<4;k++){
                            if(cellX[dep[i]]+vX[k]==cellX[i] && cellY[dep[i]]+vY[k]==cellY[i]){
                                qi = Q.rot(new V(vX[(k+3)%4],0,vY[(k+3)%4]),Math.PI/2*ti);
                                d = new V(vX[k]*2,0,vY[k]*2);
                            }
                        }
                        fp.translate(d.scale(0.5));
                        fp.rotate(qi);
                        fp.translate(d.scale(0.5));
                        fp.rotate(qs[dep[i]]);
                        fp.translate(pos[dep[i]]);
                        R.add(fp);
                        pos[i]=fp.centroid();
                        qs[i]=qs[dep[i]].mul(qi);
                    }
                }
            }
            motX += (cenX-motX)/4.0;
            motY += (cenY-motY)/4.0;
            badColor-=0.05;
            if(badColor<0)badColor=0;
            var rotQ:Q = Q.rot(V.yAxis(),time*Math.PI/90);
            R.camPos = rotQ.rotate(new V(0,-8,-10));
            R.camRot = rotQ.mul(Q.rot(V.xAxis(),-Math.PI*0.2));
            R.render(spr.graphics);
            time++;
            if(time%period==0){
                if(!curFree)update();
                else if(clickTime==0 && !clicking && clearCount<11)randomSelect();
            }else if(!curFree && time%period==period/2){
                fit();
                if(curFreeWait)curFree=freeable(),curFreeWait=false;
            }
            if(clicking && freeable()){
                if(time%period>=period/2){
                    if(clickTime<period/4)clearOnce=false;
                    curFree=true;
                    curFreeWait=false;
                }else curFreeWait=true;
            }
            if(curFree && clicking)clickTime++;
            else{
                if(clickTime==0)curFreeWait=false;
                else if((clickTime-period/4)/period/2>=1)clickTime=period/4+period*2-1;
                else clickTime--;
            }
            if(clickTime==period/4){
                makeBones();
            }
            if((clickTime-period/4)/period/2>=1 && !clearOnce){
                if(validAnswer()){
                    clearCount++;
                    clearOnce=true;
                }else{
                    clearCount=0;
                    clearOnce=true;
                    badColor=1.0;
                    clearedPattern=[];
                }
            }
            for(i=0;i<11;i++){
                if(i<clearCount){
                    spr.graphics.lineStyle(2,0xff7f00,1);
                    spr.graphics.beginFill(0xff7f00,0.3);
                }else{
                    spr.graphics.lineStyle(2,rgb(badColor*1.0,0,0),1);
                    spr.graphics.beginFill(rgb(badColor*1.0,0,0),0.3);
                }
                spr.graphics.drawCircle(465*(i+1)/12,430,5);
                spr.graphics.endFill();
            }
        }
        public function validAnswer():Boolean{
            var lB:int=0,rB:int=0,uB:int=0,bB:int=0;
            for(var i:int=0;i<6;i++){
                if(i==0 || lB>cellX[i])lB=cellX[i];
                if(i==0 || rB<cellX[i])rB=cellX[i];
                if(i==0 || uB>cellY[i])uB=cellY[i];
                if(i==0 || bB<cellY[i])bB=cellY[i];
            }
            var w:int = rB-lB+1,h:int = bB-uB+1;
            if(w*h!=12 && w*h!=10)return false;
            var ar:Array = [];
            var j:int=0;
            if(w>h){
                for(i=0;i<w;i++){
                    ar.push([]);
                    for(j=0;j<h;j++)ar[i].push(false);
                }
                for(i=0;i<6;i++){
                    ar[cellX[i]-lB][cellY[i]-uB]=true;
                }
            }else{
                for(i=0;i<h;i++){
                    ar.push([]);
                    for(j=0;j<w;j++)ar[i].push(false);
                }
                for(i=0;i<6;i++){
                    ar[cellY[i]-uB][cellX[i]-lB]=true;
                }
                j=w;
                w=h;
                h=j;
            }
            var ori:String="",rev:String="",oriF:String,revF:String;
            for(i=0;i<w;i++){
                var e:int=0;
                for(j=0;j<h;j++)e*=2,e+=ar[i][j]?1:0;
                ori+=String(e);
                e=0;
                for(j=h-1;j>-1;j--)e*=2,e+=ar[i][j]?1:0;
                rev+=String(e);
            }
            oriF=ori.split("").reverse().join("");
            revF=rev.split("").reverse().join("");
            for(i=0;i<11;i++){
                if(pattern[i]==ori || pattern[i]==rev || pattern[i]==oriF || pattern[i]==revF){
                    if(clearedPattern.indexOf(i)==-1){
                        clearedPattern.push(i);
                        return true;
                    }else return false;
                }
            }
            return false;
        }
        public function rgb(r:Number,g:Number,b:Number):uint{
            var rs:int = r*255;
            var gs:int = g*255;
            var bs:int = b*255;
            return (rs<<16)+(gs<<8)+bs; 
        }
        public function makeBones():void{
            var ix:int=0;
            var le:Number=0;
            for(var i:int=0;i<6;i++){
                var e:Number = Math.pow(cellX[i]-cenX,2)+Math.pow(cellY[i]-cenY,2);
                if(i==0 || le>e)ix=i,le=e;
            }
            for(i=0;i<6;i++){
                dep[i]=-1;
            }
            dep[ix]=ix;
            procSeq=[ix];
            for(var k:int=0;k<6;k++){
                for(i=0;i<6;i++){
                    if(dep[i]==-1){
                        for(var j:int=0;j<6;j++){
                            if(dep[j]!=-1 && one(cellX[i]-cellX[j],cellY[i]-cellY[j])){
                                dep[i]=j;
                                procSeq.push(i);
                                break;
                            }
                        }
                    }
                }
            }
            cenX=cellX[ix],cenY=cellY[ix];
        }
        public function onDown(e:MouseEvent):void{
            clicking=true;
        }
        public function onUp(e:MouseEvent):void{
            clicking=false;
        }
    }
}

const eps:Number = 1e-6;

class V{
    public var x:Number,y:Number,z:Number;
    public function V(x_:Number,y_:Number,z_:Number){
        x=x_,y=y_,z=z_;
    }
    public function add(r:V):V{
        return new V(x+r.x,y+r.y,z+r.z);
    }
    public function sub(r:V):V{
        return new V(x-r.x,y-r.y,z-r.z);
    }
    public function dot(r:V):Number{
        return x*r.x+y*r.y+z*r.z; 
    }
    public function cross(r:V):V{
        return new V(y*r.z-z*r.y,z*r.x-x*r.z,x*r.y-y*r.x);
    }
    public function scale(e:Number):V{
        return new V(e*x,e*y,e*z);
    }
    public function lenSq():Number{
        return x*x+y*y+z*z;
    }
    public function length():Number{
        return Math.sqrt(lenSq());
    }
    public function normalize():V{
        var d:Number = length();
        if(d<eps)return xAxis();
        else return scale(1/d);
    }
    public static function zero():V{
        return new V(0,0,0);
    }
    public static function xAxis():V{
        return new V(1,0,0);
    }
    public static function yAxis():V{
        return new V(0,1,0);
    }
    public static function zAxis():V{
        return new V(0,0,1);
    }
    public function assign(v:V):void{
        x=v.x,y=v.y,z=v.z;
    }
}

class Q{
    public var w:Number,v:V;
    public function Q(w_:Number,v_:V){
        w=w_,v=v_;
    }
    public function add(q:Q):Q{
        return new Q(w+q.w,v.add(q.v));
    }
    public function sub(q:Q):Q{
        return new Q(w-q.w,v.sub(q.v));
    }
    public function mul(q:Q):Q{
        return new Q(w*q.w-v.dot(q.v),v.scale(q.w).add(q.v.scale(w)).add(v.cross(q.v)));
    }
    public function div(q:Q):Q{
        return mul(q.inv());
    }
    public function conj():Q{
        return new Q(w,v.scale(-1));
    }
    public function inv():Q{
        return conj().scale(1/lenSq());
    }
    public function lenSq():Number{
        return w*w+v.dot(v);
    }
    public function length():Number{
        return Math.sqrt(lenSq());
    }
    public function normalize():Q{
        var d:Number = length();
        if(d<eps)return e();
        else return scale(1/d);
    }
    public function scale(s:Number):Q{
        return new Q(w*s,v.scale(s));
    }
    public static function zero():Q{
        return new Q(0,new V(0,0,0));
    }
    public static function e():Q{
        return new Q(1,new V(0,0,0));
    }
    public static function rot(v:V,a:Number):Q{
        return new Q(Math.cos(a/2),v.normalize().scale(Math.sin(a/2)));
    }
    public function rotate(v:V):V{
        return mul(new Q(0,v)).mul(conj()).v;
    }
}

class Poly{
    private var ps:Array = new Array();
    private var len:int = 0;
    public var col:uint = 0;
    public var fill:Boolean = true;
    public function index(i:int):V{
        return ps[i];
    }
    public function add(v:V):void{
        ps.push(v);
        len++;
    }
    public function size():int{
        return len;
    }
    public function translate(v:V):Poly{
        for each(var i:V in ps){
            i.assign(v.add(i));
        }
        return this;
    }
    public function rotate(q:Q):Poly{
        for each(var i:V in ps){
            i.assign(q.rotate(i));
        }
        return this;
    }
    public function clone():Poly{
        var p:Poly = new Poly();
        for each(var i:V in ps)p.add(new V(i.x,i.y,i.z));
        return p;
    }
    public function centroid():V{
        var c:V = V.zero();
        for each(var i:V in ps){
            c.assign(c.add(i));
        }
        return c.scale(1.0/len);
    }
    public function divZ(n:Number):void{
        for each(var i:V in ps){
            i.assign(i.scale(1/i.z*0.6));
        }
    }
}

import flash.display.Graphics;

class Render{
    private var ps:Array = new Array();
    private var len:int = 0;
    public var camPos:V = V.zero();
    public var camRot:Q = Q.e();
    public function add(p:Poly):void{
        ps.push(p);
        len++;
    }
    public function size():int{
        return len;
    }
    public function render(g:Graphics):void{
        g.clear();
        var e:Array = [];
        for each(var ip:Poly in ps){
            ip.translate(camPos.scale(-1));
            ip.rotate(camRot.inv());
            var c:V=ip.centroid();
            if(c.z>0)e.push({p:ip,c:c});
        }
        ps=[];
        var i:int = 0;
        while(e.length > 0){
            var b:Boolean = false;
            var z:Number = 0;
            var ix:int = 0;
            i=0;
            for each(var oi:Object in e){
                if(!b || oi.c.z < z){
                    z = oi.c.z;
                    ix = i;
                    b = true;
                }
                i++;
            }
            ps.push(e[ix].p);
            e.splice(ix,1);
        }
        const scale:Number=24;
        for each(var pq:Poly in ps){
            pq.divZ(0.1);
            pq.rotate(Q.e().scale(scale));
            g.lineStyle(2,pq.col,1);
            if(pq.fill){
                g.beginFill(pq.col,0.5);
            }
            g.moveTo(pq.index(0).x+465/2,pq.index(0).y+465/2);
            for(i=1;i<pq.size();i++){
                g.lineTo(pq.index(i).x+465/2,pq.index(i).y+465/2);   
            }
            g.lineTo(pq.index(0).x+465/2,pq.index(0).y+465/2);
            if(pq.fill)g.endFill();
        }
        ps=[];
        len=0;
    }
}
