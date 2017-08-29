/**
 * Copyright phi16 ( http://wonderfl.net/user/phi16 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/h7n1
 */

package {
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    public class Render extends Sprite {
        private var bmp:BitmapData;
        private var ps:Vector.<uint>;
        private const fail:Sample = new Sample(false);
        private const white:Vec = new Vec(0.740063,0.742313,0.733934);
        private const green:Vec = new Vec(0.162928,0.4080903,0.0833759);
        private const red:Vec = new Vec(0.366046,0.0371827,0.0416385);
        
        private const pls:Array = [
            [new Vec(1,0,0),new Vec(-1,0,0),white],
            [new Vec(-1,0,0),new Vec(1,0,0),white],
            [new Vec(0,-1,0),new Vec(0,1,0),red],
            [new Vec(0,1,0),new Vec(0,-1,0),green],
            [new Vec(0,0,1),new Vec(0,0,-1),white],
        ];
        private const cam:Vec = new Vec(0,0,-3);
        private const camD:Vec = new Vec(0,0,1);
        private const lgh:Vec = new Vec(-0.99,0,0);
        private var sR:Array = [], sG:Array = [], sB:Array = [];
        private var sC:Array = [], sS:Array = [];
        private var path:Array = [], befL:Array = [];
        private var id:int = 0;
        public function Render() {
            bmp = new BitmapData(465,465,false,0);
            var bm:Bitmap = new Bitmap(bmp);
            addChild(bm);
            id=0;
            for(var i:int=0;i<465;i++){
                for(var j:int=0;j<465;j++){
                    id++;
                    sR[id]=sG[id]=sB[id]=sC[id]=0;
                    sS[id]=getSample(i,j);
                    path[id]=new Array();
                    befL[id]=new Vec(lumi(sS[id],0,0),lumi(sS[id],0,1),lumi(sS[id],0,2));
                }
            }
            addEventListener(Event.ENTER_FRAME,draw);
        }
        public function draw(e:Event):void{
            var c:int = 2000;
            ps = bmp.getVector(bmp.rect);
            while(c --> 0){
                var i:int = Math.floor(Math.random()*465);
                var j:int = Math.floor(Math.random()*465);
                id=i*465+j;
                ps[id] = getColor(id);
            }
            bmp.setVector(bmp.rect,ps);
        }
        public function plane(n:Vec,s:Vec,p:Vec,v:Vec,emi:Number,col:Vec):Sample{
            var b:Vec = s.sub(p);
            var c:Number = b.dot(n);
            var e:Number = v.dot(n);
            if(c*e <= 0)return fail;
            return (new Sample(true)).on(p.add(v.mul(c/e)),n.mul(e<0?1:-1),col,emi,c/e);
        }
        public function collide(p:Vec,v:Vec):Sample{
            var a:Sample = new Sample(false);
            for(var i:int=0;i<pls.length;i++){
                a.or(plane(pls[i][1],pls[i][0],p,v,0,pls[i][2]));
            }
            return a;
        }
        public function lumi(a:Sample,idx:int,x:int):Number{//The integrated color with emission
            var v:Vec;
            var ne:Number = 0;
            var g:Number = 0;
            if(path[id].length == idx){
                v = lgh.sub(a.p);
                var l2:Number = v.lengthSq();
                if(l2<1)l2=1;
                v.normalize();
                ne = 1.0;
                g = a.n.dot(v)*1/l2;
            }else{
                v = path[id][idx];
                v.normalize();
                var s:Sample = collide(a.p,v);
                if(s.b){
                    ne = lumi(s,idx+1,x);
                }
                g = -v.dot(a.n)*v.dot(s.n);
            }
            var brdf:Number = a.c.e(x)/Math.PI;
            var prob:Number = 1/Math.PI/2;
            return a.e + ne*brdf*g/prob;
        }
        public function G(p1:Vec,n1:Vec,p2:Vec,n2:Vec):Number{
            var v:Vec = p1.sub(p2);
            var r2:Number = v.lengthSq();
            return -v.dot(n1)*v.dot(n2)/r2;
        }
        public function hemiRandom(n:Vec):Vec{
            var u1:Number = Math.random()*2-1;
            var u2:Number = Math.random();
            var r:Number = Math.sqrt(1-u1*u1);
            var phi:Number = 2*Math.PI*u2;
            var v:Vec = new Vec(Math.cos(phi)*r, Math.sin(phi)*r, u1);
            if(v.dot(n)<0)v.mul(-1);
            v.normalize();
            return v;
        }
        public function getSample(x:int,y:int):Sample{
            var p:Vec = cam;
            var v:Vec = new Vec(x/465*2-1,y/465*2-1,2);
            v.normalize();
            return collide(p,v);
        }
        public function reSample(q:Sample,i:int):Vec{
            var p:Array = path[i];
            /*path[i] = [];
            var m:Sample = q;
            while(Math.random() < 0){
                var r:Vec = hemiRandom(m.n);
                path[i].push(r);
                m = collide(m.p,r);
                if(!m.b)break;
            }*/
            var d:Number = 0;//0.5;//1/Math.PI/2;
            if(Math.random() < d){
                path[i] = [];
            }else{
                path[i] = [hemiRandom(q.n)];
                d = 1-d;
            }
            var e:Vec = new Vec(lumi(q,0,0),lumi(q,0,1),lumi(q,0,2));
            /*if(e.val() / befL[i].val() <= Math.random()){ //Dispose
                e = befL[i];
                path[i] = p;
            }
            befL[i] = e;*/
            return e.mul(d);
        }
        public function getColor(i:int):uint{
            var q:Sample = sS[i];
            var u:Vec = reSample(q,i);
            sR[i]+=Math.max(u.x,0);
            sG[i]+=Math.max(u.y,0);
            sB[i]+=Math.max(u.z,0);
            sC[i]++;
            return cons(sR[i]/sC[i],sG[i]/sC[i],sB[i]/sC[i]);
        }
        public function cons(r:Number,g:Number,b:Number):uint{
            var rr:Number = Math.pow(Math.min(r,1),1/2.2)*255;
            var gg:Number = Math.pow(Math.min(g,1),1/2.2)*255;
            var bb:Number = Math.pow(Math.min(b,1),1/2.2)*255;
            return (Math.floor(rr)*256+Math.floor(gg))*256+Math.floor(bb);
        }
    }
}

var eps : Number = 0.00001;

class Sample{
    public var b:Boolean;
    public var p:Vec, n:Vec;
    public var c:Vec, e:Number, d:Number;
    public function Sample(b_:Boolean){
        b=b_;
    }
    public function on(p_:Vec,n_:Vec,c_:Vec,e_:Number,d_:Number):Sample{
        p=p_,n=n_,c=c_,e=e_,d=d_;
        return this;
    }
    public function or(m:Sample):void{
        if(m.b==false)return;
        if(b==false){
            b=true,p=m.p,n=m.n,c=m.c,e=m.e,d=m.d;
        }else{
            if(d<m.d){
                return;
            }else{
                p=m.p,n=m.n,c=m.c,e=m.e,d=m.d;
            }
        }
    }
}

class Vec{
    public var x:Number,y:Number,z:Number;
    public function Vec(x_:Number,y_:Number,z_:Number){
        x=x_,y=y_,z=z_;
    }
    public function normalize():void{
        var e:Number = length();
        if(Math.abs(e)<eps)return;
        x/=e;
        y/=e;
        z/=e;
    }
    public function length():Number{
        return Math.sqrt(lengthSq());
    }
    public function lengthSq():Number{
        return x*x+y*y+z*z;
    }
    public function zero():Boolean{
        return lengthSq() < eps;
    }
    public function dot(p:Vec):Number{
        return x*p.x+y*p.y+z*p.z;
    }
    public function sub(p:Vec):Vec{
        return new Vec(x-p.x,y-p.y,z-p.z);
    }
    public function add(p:Vec):Vec{
        return new Vec(x+p.x,y+p.y,z+p.z);
    }
    public function mul(d:Number):Vec{
        return new Vec(d*x,d*y,d*z);
    }
    public function e(p:int):Number{
        if(p==0)return x;
        if(p==1)return y;
        if(p==2)return z;
        return 0;
    }
    public function val():Number{
        return 0.299*x + 0.587*y + 0.114*z;
    }
}

