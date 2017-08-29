/**
 * Copyright phi16 ( http://wonderfl.net/user/phi16 )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/pKIy
 */

package {
    import flash.text.TextFormat;
    import flash.display.Sprite;
    import flash.ui.Keyboard;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.events.*;
    public class Fourier extends Sprite {
        private var spr:Sprite = new Sprite();
        private var sz:Number = 465;
        private var wz:Number = 400;
        private var bs:Number = 20;
        private var hei:Number = wz/Math.PI;
        private var cy:Number = (hei/2-bs+sz-hei-bs)/2;
        private var das:Array = new Array();
        private var dir:Array = new Array();
        private var i:int;
        private var click:Boolean = false;
        private var mt:int,my:Number;
        private var tim:Number=0;
        private var rads:Array = new Array();
        private var iads:Array = new Array();
        private var pss:Array = new Array();
        private var dS:int = 256;
        private var fS:int = 32;
        private var func:String = "";
        private var tf:TextField=new TextField();
        private var txtIn:Boolean = false;
        private var tick:int = 0;
        private var parF:String = "";
        public function Fourier() {
            addChild(spr);
            addEventListener(Event.ENTER_FRAME,step);
            for(i=0;i<dS;i++){
                das[i]=0;
                dir[i]=Math.sin(i*2*Math.PI/dS);
                if(i<fS){
                    rads[i]=iads[i]=0;
                }
                pss[i]=0;
            }
            tf.defaultTextFormat = new TextFormat("Tahoma",30,0x7f7f7f);
            tf.x=10.0;
            tf.y=0.0;
            tf.height=0.0;
            tf.antiAliasType = "advanced";
            tf.text = "y = sin x";
            tf.autoSize = TextFieldAutoSize.LEFT;
            addChild(tf);
            dft();
            addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
            addEventListener(MouseEvent.MOUSE_UP,mouseUp);
            addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown);
        }
        public function step(e:Event):void{
            spr.graphics.clear();
            spr.graphics.beginFill(0);
            spr.graphics.drawRect(0,0,sz,sz);
            spr.graphics.endFill();
            spr.graphics.lineStyle(2,0xffffff,0.5);
            spr.graphics.moveTo(0,sz-hei-bs);
            spr.graphics.lineTo(sz,sz-hei-bs);
            spr.graphics.moveTo(0,sz-bs);
            spr.graphics.lineTo(sz,sz-bs);
            spr.graphics.moveTo(0,hei/2-bs);
            spr.graphics.lineTo(sz,hei/2-bs);
            spr.graphics.lineStyle(2,0xffffff,0.2);
            spr.graphics.moveTo(sz/2-wz/2,sz-hei-bs);
            spr.graphics.lineTo(sz/2-wz/2,sz-bs);
            spr.graphics.moveTo(sz/2+wz/2,sz-hei-bs);
            spr.graphics.lineTo(sz/2+wz/2,sz-bs);
            spr.graphics.lineStyle(1,0xffffff,0.1);
            spr.graphics.moveTo(sz/2-wz/4,sz-hei-bs);
            spr.graphics.lineTo(sz/2-wz/4,sz-bs);
            spr.graphics.moveTo(sz/2+wz/4,sz-hei-bs);
            spr.graphics.lineTo(sz/2+wz/4,sz-bs);
            spr.graphics.lineStyle(2,0xffffff,0.2);
            spr.graphics.moveTo(sz/2,sz-hei-bs);
            spr.graphics.lineTo(sz/2,sz-bs);
            spr.graphics.moveTo(0,sz-hei/2-bs);
            spr.graphics.lineTo(sz,sz-hei/2-bs);
            spr.graphics.lineStyle(2,0xffffff,0.2);
            spr.graphics.moveTo(sz/2,cy-hei/2);
            spr.graphics.lineTo(sz,cy-hei/2);
            spr.graphics.moveTo(sz/2,cy+hei/2);
            spr.graphics.lineTo(sz,cy+hei/2);
            spr.graphics.lineStyle(2,0xffffff,0.1);
            spr.graphics.moveTo(hei*3/5,cy);
            spr.graphics.lineTo(sz,cy);
            spr.graphics.lineStyle(3,0x7fff7f,1);
            spr.graphics.moveTo(-10,sz-hei/2-bs);
            for(i=-30;i<dS+30;i++){
                var t:int=(i+dS)%dS;
                spr.graphics.lineTo(i*wz/dS+sz/2-wz/2,sz-hei/2-das[t]*hei/2-bs);
                if(t>=0 && t<dS)das[i]+=(dir[i]-das[i])/2.0;
            }
            var px:Number = hei*3/5, py:Number = cy, pr:Number = hei/2;
            var dx:Number = 0, dy:Number = 0;
            spr.graphics.lineStyle(1,0xffffff,0.2);
            spr.graphics.drawCircle(px,py,pr);
            for(i=0;i<fS;i++){
                spr.graphics.lineStyle(2,0xffffff,0.2);
                spr.graphics.drawCircle(px+dx*pr,py-dy*pr,rads[i]*pr);
                spr.graphics.lineStyle(2,0xffffff,0.5);
                spr.graphics.moveTo(px+dx*pr,py-dy*pr);
                dy += Math.cos(-2*Math.PI*i*tim/dS)*rads[i];
                dx += Math.sin(-2*Math.PI*i*tim/dS)*rads[i];
                spr.graphics.lineTo(px+dx*pr,py-dy*pr);

                spr.graphics.lineStyle(2,0xffffff,0.2);
                spr.graphics.drawCircle(px+dx*pr,py-dy*pr,iads[i]*pr);
                spr.graphics.lineStyle(2,0xffffff,0.5);
                spr.graphics.moveTo(px+dx*pr,py-dy*pr);
                dy -= Math.sin(-2*Math.PI*i*tim/dS)*iads[i];
                dx += Math.cos(-2*Math.PI*i*tim/dS)*iads[i];
                spr.graphics.lineTo(px+dx*pr,py-dy*pr);
            }
            spr.graphics.endFill();
            spr.graphics.beginFill(0x00ff00,1);
            spr.graphics.drawCircle(px+dx*pr,py-dy*pr,4);
            spr.graphics.drawCircle(sz/2,py-dy*pr,2);
            spr.graphics.endFill();
            spr.graphics.lineStyle(3,0x00ff00,0.5);
            pss.unshift(dy);
            pss.pop();
            spr.graphics.moveTo(px+dx*pr,py-dy*pr);
            for(i=0;i<dS;i++){
                spr.graphics.lineTo(sz/2+i/dS*sz/2,py-pss[i]*pr);
            }
            
            spr.graphics.lineStyle(1,0xffffff,1);
            if(txtIn && tick % 30 < 15){
                spr.graphics.moveTo(tf.width + tf.x, 5);
                spr.graphics.lineTo(tf.width + tf.x, hei/2-bs-5);
            }
            if(txtIn)tick++;
            else tick = 0;
            tim+=1.6;
        }
        public function mouseDown(e:MouseEvent):void{
            if(mouseY < hei/2-bs){
                txtIn = true;
                tf.textColor = 0xcfcfcf;
                func = tf.text.substr(4);
                return;
            }else if(mouseY < sz-hei-bs)return;
            tf.textColor = 0x7f7f7f;
            txtIn = false;
            click=true;
            rewrite((mouseX-(sz/2-wz/2))/wz, -(mouseY+bs-(sz-hei/2))/(hei/2));
            tf.text = "y = f(x)";
        }
        public function mouseMove(e:MouseEvent):void{
            if(click){
                rewriteLine((mouseX-(sz/2-wz/2))/wz, -(mouseY+bs-(sz-hei/2))/(hei/2));
                tf.text = "y = f(x)";
            }
        }
        public function mouseUp(e:MouseEvent):void{
            click=false;
        }
        public function rewrite(x:Number,y:Number):void{
            y=Math.min(Math.max(y,-1),1);
            var t:int=(int)(x*dS)+dS;
            dir[t%dS]=y;
            mt=t,my=y;
            dft();
        }
        public function rewriteLine(x:Number,y:Number):void{
            y=Math.min(Math.max(y,-1),1);
            var t:int=(int)(x*dS)+dS;
            var fi:int,en:int;
            if(mt == t){
                rewrite(x,y);
                return;
            }else if(mt<t)fi=mt+1,en=t;
            else if(mt>t)fi=t,en=mt-1;
            for(var j:int=fi;j<=en;j++){
                var a:Number = (j-mt)/(t-mt);
                dir[(j+dS)%dS]=a*y+(1-a)*my;
            }
            mt=t,my=y;
            dft();
        }
        public function dft():void{ //dir[] -> rads[], iads[]
            var ds:Array = new Array(), es:Array = new Array();
            for(i=0;i<dS;i++)ds[i]=dir[dS-i-1], es[i]=0;
            DFT(ds,es,dS);
            for(i=0;i<fS;i++){
                rads[i]=ds[i]/dS*2;
                iads[i]=es[i]/dS*2;
            }
            rads[0]/=2;
            iads[0]/=2;
        }
        public function DFT(x:Array, y:Array, n:int):void{
            if(n==1)return;
            var x0:Array = new Array(), y0:Array = new Array();
            var x1:Array = new Array(), y1:Array = new Array();
            var j:int=0;
            for(j=0;j<n/2;j++){
                x0[j]=x[2*j];
                y0[j]=y[2*j];
                x1[j]=x[2*j+1];
                y1[j]=y[2*j+1];
            }
            DFT(x0,y0,n/2);
            DFT(x1,y1,n/2);
            for(j=0;j<n;j++){
                var zR:Number = Math.cos(2*Math.PI*j/n), zI:Number = Math.sin(2*Math.PI*j/n);
                x[j] = x0[j%(n/2)] + zR * x1[j%(n/2)] - zI * y1[j%(n/2)];
                y[j] = y0[j%(n/2)] + zR * y1[j%(n/2)] + zI * x1[j%(n/2)];
            }
            return;
        }
        public function keyDown(e:KeyboardEvent):void{
            if(!txtIn)return;
            var c:int = e.keyCode;
            if(c == Keyboard.BACKSPACE && func.length!=0)func=func.slice(0,func.length-1);
            else if(c == Keyboard.ENTER){
                runParse();
                return;
            }else if(c == Keyboard.SPACE)func=func+" ";
            else if(c == Keyboard.ESCAPE)func="";
            else if(c == 186 && e.shiftKey)func=func+"*";
            else if(c == 189 && !e.shiftKey)func=func+"-";
            else if(c == 187 && e.shiftKey)func=func+"+";
            else if(c == 191 && !e.shiftKey)func=func+"/";
            else if(c == 222 && !e.shiftKey)func=func+"^";
            else if(c == 190 && !e.shiftKey)func=func+".";
            else if(48<=c && c<=57 && !e.shiftKey)func=func+String.fromCharCode(c);
            else if(c == 53 && e.shiftKey)func=func+"%";
            else if(c == 56 && e.shiftKey)func=func+"(";
            else if(c == 57 && e.shiftKey)func=func+")";
            else if(c == 83 && e.shiftKey)func=func+"sin ";
            else if(c == 67 && e.shiftKey)func=func+"cos ";
            else if(c == 84 && e.shiftKey)func=func+"tan ";
            else if(c == 69 && e.shiftKey)func=func+"exp ";
            else if(c == 76 && e.shiftKey)func=func+"log ";
            else if(65<=c && c<=90)func=func+String.fromCharCode(c + 32);
            tf.textColor=0xffffff;
            tf.text = "y = " + func;
        }
        public function runParse():void{
            var psr:Parser = new Parser(func);
            var ast:Object = psr.expr();
            if(!psr.done())ast.ope=-1;
            if(ast.ope!=-1){
                var dn:Array = new Array();
                for(i=0;i<dS;i++){
                    dn[i] = Math.min(Math.max(eval(i*2*Math.PI/dS,ast),-1),1);
                    if(isNaN(dn[i]))dn[i]=0;
                }
                dir=dn;
                dft();
                tf.textColor=0x7f7f7f;
            }else{
                tf.textColor=0xff7f7f;
            }

        }
        public function eval(x:Number, ast:Object):Number{
            switch(ast.ope){
                case 0:{
                    return eval(x,ast.l)+eval(x,ast.r);
                }break;
                case 1:{
                    return eval(x,ast.l)-eval(x,ast.r);
                }break;
                case 2:{
                    return eval(x,ast.l)*eval(x,ast.r);
                }break;
                case 3:{
                    return eval(x,ast.l)/eval(x,ast.r);
                }break;
                case 4:{
                    return Math.pow(eval(x,ast.l),eval(x,ast.r));
                }break;
                case 8:{
                    return eval(x,ast.l)%eval(x,ast.r);
                }break;
                case 5:{
                    return ast.v;
                }break;
                case 6:{
                    return x;
                }break;
                case 7:{
                    switch(ast.o){
                        case "sin":{
                            return Math.sin(eval(x,ast.v));
                        }break;
                        case "cos":{
                            return Math.cos(eval(x,ast.v));
                        }break;
                        case "tan":{
                            return Math.tan(eval(x,ast.v));
                        }break;
                        case "exp":{
                            return Math.exp(eval(x,ast.v));
                        }break;
                        case "log":{
                            return Math.log(eval(x,ast.v));
                        }break;
                        case "abs":{
                            return Math.abs(eval(x,ast.v));
                        }break;
                        case "sgn":{
                            var y:Number = eval(x,ast.v);
                            if(y<0)return -1;
                            else if(y>0)return 1;
                            else return 0;
                        }break;
                        case "sqrt":{
                            return Math.sqrt(eval(x,ast.v));
                        }break;
                        case "f":{
                            return dir[(int)((eval(x,ast.v)*dS/2/Math.PI)%dS+dS)%dS];
                        }
                    }
                }break;
            }
            return 0;
        }
    }
}

class Parser{
    public var str:String;
    public function Parser(s:String){
        str = s;
    }
    public function done():Boolean{
        skipSpace();
        return str.length == 0;
    }
    public function expr():Object{
        var e:Object = term();
        var f:Object, p:Object;
        if(e.ope == -1)return e;
        while(!done() && (str.charAt(0)=='+' || str.charAt(0)=="-")){
            if(str.charAt(0)=='+'){
                next();
                f = term();
                if(f.ope == -1)return f;
                p = new Object();
                p.ope = 0;
                p.l = e;
                p.r = f;
            }else{
                next();
                f = term();
                if(f.ope == -1)return f;
                p = new Object();
                p.ope = 1;
                p.l = e;
                p.r = f;
            }
            e = p;
        }
        return e;
    }
    public function term():Object{
        var e:Object = mult();
        var f:Object, p:Object;
        if(e.ope == -1)return e;
        while(!done() && (str.charAt(0)=='*' || str.charAt(0)=="/" || str.charAt(0)=="%")){
            if(str.charAt(0)=='*'){
                next();
                f = mult();
                if(f.ope == -1)return f;
                p = new Object();
                p.ope = 2;
                p.l = e;
                p.r = f;
            }else if(str.charAt(0)=='/'){
                next();
                f = mult();
                if(f.ope == -1)return f;
                p = new Object();
                p.ope = 3;
                p.l = e;
                p.r = f;
            }else{
                next();
                f = mult();
                if(f.ope == -1)return f;
                p = new Object();
                p.ope = 8;//%
                p.l = e;
                p.r = f;
            }
            e = p;
        }
        return e;
    }
    public function mult():Object{
        var e:Object = powf();
        if(e.ope == -1)return e;
        var fl:Boolean = false;
        if(str.charAt(0)==' ')fl=true;
        skipSpace();
        while(!done() && str.charAt(0)!='-'){
            var s:String = str;
            var f:Object = powf();
            if(f.ope == -1 || f.ope==5 && !fl){
                str = s;
                return e;
            }
            var p:Object = new Object();
            p.ope = 2;
            p.l = e;
            p.r = f;
            e = p;
            if(str.charAt(0)==' ')fl=true;
        }
        return e;
    }
    public function powf():Object{
        var e:Object = fact();
        if(e.ope == -1)return e;
        if(!done() && str.charAt(0) == '^'){
          next();
          var f:Object = powf();
          if(f.ope == -1)return f;
          var p:Object = new Object();
          p.ope = 4;
          p.l = e;
          p.r = f;
          e = p;
        }
        return e;
    }
    public function fact():Object{
        if(done()){
            var q:Object = new Object();
            q.ope = -1;
            return q;
        }
        var c:int = str.charCodeAt(0);
        var e:Object, r:Object, u:Object;
        if(str.charAt(0) == '-'){
            next();
            e = fact();
            if(e.ope==-1)return e;
            r = new Object();
            r.ope = 1;
            r.l = {ope:5, v:0};
            r.r = e;
            return r;
        }else if(48<=c && c<=57){
            if(!done()){
                var n:Number=0;
                c = str.charCodeAt(0);
                while(str.length!=0 && 48<=c && c<=57){
                    n*=10;
                    n+=c-48;
                    adj();
                    if(str.length!=0)c = str.charCodeAt(0);
                }
                if(str.length!=0 && c == 46){// .
                    adj();
                    var p:int = 1;
                    c = str.charCodeAt(0);
                    while(str.length!=0 && 48<=c && c<=57){
                        n+=Math.pow(10,-p)*(c-48);
                        adj();
                        if(str.length!=0)c = str.charCodeAt(0);
                    }
                }
                r = new Object();
                r.ope = 5;
                r.v = n;
                return r;
            }else{
                u = new Object();
                u.ope = -1;
                return u;
            }
        }else if(c == 40){// (
            next();
            e = expr();
            if(e.ope==-1)return e;
            skipSpace();
            if(done() || str.charAt(0) != ')'){
                u = new Object();
                u.ope = -1;
                return u;
            }
            next();
            return e;
        }else if(c == 120){ // x
            next();
            r = new Object();
            r.ope = 6;
            return r;
        }else if(str.substr(0,2)=="pi"){
            next();next();
            r = new Object();
            r.ope = 5;
            r.v=Math.PI;
            return r;
        }else if(str.substr(0,2)=="e"){
            next();next();
            r = new Object();
            r.ope = 5;
            r.v=Math.E;
            return r;
        }else if(str.substr(0,2)=="phi"){
            next();next();
            r = new Object();
            r.ope = 5;
            r.v=(Math.sqrt(5)+1)/2;
            return r;
        }
        var fn:String = str.substr(0,3);
        var b:Object = new Object();
        b.ope = 7;
        if(fn == "sin"){
           next();next();next();
           e = mult();
           if(e.ope==-1)return e;
           b.o = "sin";
           b.v = e;
        }else if(fn == "cos"){
           next();next();next();
           e = mult();
           if(e.ope==-1)return e;
           b.o = "cos";
           b.v = e;
        }else if(fn == "tan"){
           next();next();next();
           e = mult();
           if(e.ope==-1)return e;
           b.o = "tan";
           b.v = e;
        }else if(fn == "exp"){
           next();next();next();
           e = mult();
           if(e.ope==-1)return e;
           b.o = "exp";
           b.v = e;
        }else if(fn == "log"){
           next();next();next();
           e = mult();
           if(e.ope==-1)return e;
           b.o = "log";
           b.v = e;
        }else if(fn == "abs"){
           next();next();next();
           e = mult();
           if(e.ope==-1)return e;
           b.o = "abs";
           b.v = e;
        }else if(fn == "sgn"){
           next();next();next();
           e = mult();
           if(e.ope==-1)return e;
           b.o = "sgn";
           b.v = e;
        }else if(str.substr(0,4) == "sqrt"){
           next();next();next();next();
           e = mult();
           if(e.ope==-1)return e;
           b.o = "sqrt";
           b.v = e;
        }else if(str.charAt(0) == "f"){
            next();
            e = fact();
            if(e.ope==-1)return e;
            b.o = "f";
            b.v = e;
        }else{
            u = new Object();
            u.ope = -1;
            return u;
        }
        return b;
    }
    public function adj():void{
        if(str.length > 0)str=str.substr(1);
    }
    public function next():void{
        if(str.length > 0){
            str=str.substr(1);
            skipSpace();
        }
    }
    public function skipSpace():void{
        while(str.length > 0 && str.charAt(0)==' ')str=str.substr(1);
    }
}
