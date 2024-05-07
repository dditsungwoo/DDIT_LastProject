
(function(w, $) {
    
    "use strict";
    
    function SignPad(option={}) {
        
        this.canvas = option.canvas;
        // canvas context
        this.ctx = this.canvas.getContext('2d');
        
        
        // draw 상태 값
        this.ctx.isDraw = false;
        // erase 상태 값
        this.ctx.isErase = false;
        // erase mode 여부 
        this.ctx.isEraseMode = false;

        // erase width, height, cursor, wrapper
        this.ctx.erase = {
            width:10, 
            height:10, 
            // display:none;z-index:-1;
            cursor: $(`<div class="sign-pad-erase-cursor" style="width:10px; height:10px; border:1px solid #000; position: absolute;cursor:none;display:none;z-index:-1"></div>`), 
            wrapper: `<div class="sign-pad-erase-wrapper" style="overflow:hidden;position:relative;display:inline-block;"></div>`,
        };
        
        // history 관련 
        this.history = [];
        this.history.currentId = null;
        this.history.currentIndex = null;
        this.history.autoSave = true;
        if(this.history.autoSave) this.save();
        
        // event 
        $(this.canvas).on('mouseover mousedown mousemove mouseup mouseout', {_this: this}, event);
        $(this.canvas).on('touchstart touchend touchmove touchcancel', {_this: this}, event);
        $(this.canvas).css('cursor', 'crosshair');

        $('body').on('mousedown mouseup touchstart touchend', {_this: this}, function(e) {
            let {_this} = e.data;
            let {ctx} = e.data._this;
            switch(e.type) {
                case 'mousedown': case 'touchstart':
                    if(ctx.isEraseMode) {
                        ctx.isErase = true; 
                    } else {
                        ctx.isDraw = true;
                    }
                    break;
                case 'mouseup': case 'touchend':
                    if(ctx.isEraseMode) {
                        ctx.isErase = false; 
                    } else {
                        ctx.isDraw = false;
                    }
                    break;
            }
        });
        
        // canvas context 초기화 
        this.ctx.lineJoin = 'round';
        this.ctx.lineCap = 'round';
        
        // 캔버스 html 프로퍼티로 SignPad 추가 ($.getSignPad 용)
        this.canvas.SignPad = this;
    }
    
    function event(e) {
        let {_this} = e.data;
        let {ctx} = e.data._this;
        
        switch(e.type) {
            case 'mouseover':
                if(ctx.isDraw) {
                    ctx.beginPath();
                    ctx.moveTo(getPosition(e).x, getPosition(e).y);
                }
                break;
            case 'mousedown': case 'touchstart':
                $('span.sign-pad-txt').css('display', 'none');
                if(ctx.isEraseMode) {
                    //ctx.isErase = true;   
                    //ctx.clearRect(getPosition(e).x, getPosition(e).y, ctx.erase.width, ctx.erase.height);
                    ctx.clearRect(getPosition(e).x - getCursorOffset(e).x, getPosition(e).y - getCursorOffset(e).y, ctx.erase.width, ctx.erase.height);
                } else {
                    //ctx.isDraw = true;   
                    ctx.beginPath();
                    ctx.moveTo(getPosition(e).x, getPosition(e).y);
                    //
                    ctx.lineTo(getPosition(e).x, getPosition(e).y);
                    ctx.stroke();
                }
                break;
            case 'touchmove':
                // 스크롤 이동등 이벤트 중지..
                e.preventDefault();
            case 'mousemove': 
                if(ctx.isDraw) {
                    ctx.lineTo(getPosition(e).x, getPosition(e).y);
                    ctx.stroke();
                } 
                else if(ctx.isEraseMode && ctx.isErase) {
                    //ctx.clearRect(getPosition(e).x, getPosition(e).y, ctx.erase.width, ctx.erase.height);
                    ctx.clearRect(getPosition(e).x - getCursorOffset(e).x, getPosition(e).y - getCursorOffset(e).y, ctx.erase.width, ctx.erase.height);
                }
                break;
            case 'mouseup': case 'touchend':
                if(ctx.isEraseMode) {
                    //ctx.isErase = false;   
                } else {
                    //ctx.isDraw = false;   
                    ctx.closePath();
                }
                // 저장 
                _this.save();
                break;
            case 'mouseout': 
                if(ctx.isEraseMode) {
                    //ctx.isErase = false;   
                } else {
                    //ctx.isDraw = false;   
                    //ctx.closePath();
                }
                // 저장 
                if(ctx.isDraw || ctx.isErase) _this.save();
                break;
            case 'touchcancel': 
//                ctx.isDraw = false;
//                ctx.closePath();
                break;
        }
    }
    
    function eraserCursorEvent(e) {
        let cursor = e.data._this.ctx.erase.cursor;
        switch(e.type) {
            case 'mouseover': case 'touchstart':
                cursor.show();
                //cursor.css('visibility', 'visible');
            case 'mousemove': case 'touchmove':
                //cursor.css({left: getPosition().x, top: getPosition().y});
                cursor.css({left: getPosition(e).x - getCursorOffset(e).x, top: getPosition(e).y - getCursorOffset(e).y});
                break;
            case 'mouseout': case 'touchend':
                cursor.hide();
                //cursor.css('visibility', 'hidden');
                break;
        }
    }
    
    function getPosition(e) {
        if(e.originalEvent instanceof MouseEvent) {
            return {
                //x: e.pageX - e.currentTarget.offsetLeft,
                //y: e.pageY - e.currentTarget.offsetTop,
                x: e.originalEvent.offsetX,
                y: e.originalEvent.offsetY,
            }
        }
        else if(e.originalEvent instanceof TouchEvent) {
            return {
                //x: e.originalEvent.changedTouches[0].pageX - e.currentTarget.offsetLeft,
                //y: e.originalEvent.changedTouches[0].pageY - e.currentTarget.offsetTop,
                x: e.originalEvent.changedTouches[0].clientX - e.target.getBoundingClientRect().x,
                y: e.originalEvent.changedTouches[0].clientY - e.target.getBoundingClientRect().y,
            }
        }
    }
        
    function getCursorOffset(e) {
        return {
            x: e.data._this.ctx.erase.width / 2,
            y: e.data._this.ctx.erase.height / 2,
        }
    }
    
    function numberCheck(n, d) {
        n = Number(n);
        n = isNaN(n) ? d : n;
        return n;
    }
    
    // ctx.restore, ctx.save는 이전 설정값 (lineWidth, strokeStyle..)을 저장 및 되돌리기 하는 기능 임
    
    // canvas width 설정 (canvas 속성 수정 할 경우, context 초기화, canvas 초기화 됨)
    SignPad.prototype.setCanvasWidth = function(w=100) {
        // 기존 context 설정 저장 
        let {strokeStyle, lineJoin, lineCap, lineWidth, globalAlpha} = this.ctx;
        
        this.canvas.width = numberCheck(w, 100);
        
        // 기존 context 설정 재설정 
        this.ctx.strokeStyle = strokeStyle;
        this.ctx.lineJoin = lineJoin;
        this.ctx.lineCap = lineCap;
        this.ctx.lineWidth = lineWidth;
        this.ctx.globalAlpha = globalAlpha;
        
        // 기존 그려진 상태 초기화
        this.restoreById();
        
        return this;
    }
    // canvas height 설정 (canvas 속성 수정 할 경우, context 초기화됨, canvas 초기화 됨)
    SignPad.prototype.setCanvasHeight = function(h=100) {
        // 기존 context 설정 저장 
        let {strokeStyle, lineJoin, lineCap, lineWidth, globalAlpha} = this.ctx;
        
        this.canvas.height = numberCheck(h, 100);
        
        // 기존 context 설정 재설정 
        this.ctx.strokeStyle = strokeStyle;
        this.ctx.lineJoin = lineJoin;
        this.ctx.lineCap = lineCap;
        this.ctx.lineWidth = lineWidth;
        this.ctx.globalAlpha = globalAlpha;
        
        // 기존 그려진 상태 초기화
        this.restoreById();
        
        return this;
    }
    
    // 선 색
    SignPad.prototype.setLineColor = function(a='black') {
        this.ctx.strokeStyle = typeof a === 'string' ? a : 'black';
        return this;
    }
    // 선 모양
    SignPad.prototype.setLineJoin = function(a='round') {
        // bevel, round, miter
        this.ctx.lineJoin = ['miter', 'round', 'bevel'].includes(a) ? a : 'round';
        return this;
    }
    // 선 끝 모양
    SignPad.prototype.setLineCap = function(a='round') {
        // butt, round, square
        this.ctx.lineCap = ['butt', 'round', 'square'].includes(a) ? a : 'round';
        return this;
    }
    // 선 굵기 
    SignPad.prototype.setLineWidth = function(w=1) {
        this.ctx.lineWidth = numberCheck(w, 1);
        return this;
    }
    // 선 투명도 
    SignPad.prototype.setLineOpacity = function(o=1) {
        this.ctx.globalAlpha = numberCheck(o, 1);
        return this;
    }
    
    // 캔버스 초기화 
    SignPad.prototype.eraseAll = function() {
        // reset은 ctx 설정 값(설정 값) 까지 초기화 됨 
        //this.ctx.reset();
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        $('span.sign-pad-txt').css('display', '');
        
        // 저장
        if(this.history.autoSave) this.save();
        return this;
    }
    // 지우개 모드 on
    SignPad.prototype.onEraseMode = function() {
        // erase mode 여부 체크
        if(this.ctx.isEraseMode) return this;
        // erase mode 활성화
        this.ctx.isEraseMode = true;
        // 커스텀 커서, 크기 조절 안됨 
        //$(this.canvas).css({'cursor': 'url(./cursor.cur), auto'});
        // 커서 변경 
        $(this.canvas).css('cursor', 'none');
        // wrapper 감싸기 
        $(this.canvas).wrap(this.ctx.erase.wrapper);
        // 커서 추가 
        $(this.canvas).after(this.ctx.erase.cursor);
        // 커서 이벤트 추가 
        $(this.canvas).on('mouseover mousemove mouseout', {_this: this}, eraserCursorEvent);
        $(this.canvas).on('touchstart touchmove touchend', {_this: this}, eraserCursorEvent);
        
        return this;
    }
    // 지우개 모드 off
    SignPad.prototype.offEraseMode = function() {
        // erase mode 여부 체크
        if(!this.ctx.isEraseMode) return this;
        // erase mode 해제 
        this.ctx.isEraseMode = false;
        // 커서 변경 
        $(this.canvas).css('cursor', 'crosshair');
        // wrapper 풀기
        $(this.canvas).unwrap();
        // 커서 이벤트 삭제
        $(this.canvas).unbind('mouseover mousemove mouseout', eraserCursorEvent);
        // 커서 삭제 
        this.ctx.erase.cursor.remove();
        return this;
    }
    // 지우개 사이즈 설정
    SignPad.prototype.setEraseSize = function(s=10) {
        s = numberCheck(s, 10);
        this.ctx.erase.cursor.css({width:s, height:s});
        this.ctx.erase.width = s;
        this.ctx.erase.height = s;
        return this; 
    }
    
    
    
    // 이미지 다운로드
    SignPad.prototype.download = function(name='sign', extension='png') {
        if(['png', 'jpg', 'gif'].includes(extension)) {
            let a = document.createElement('a');
            //a.href = this.canvas.toDataURL(`image/${extension}`);
            a.href = this.getDataURL(extension);
            a.download = `${name}.${extension}`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);    
        }
        return this;
    }
    // 이미지 데이터로 변환  
    SignPad.prototype.getImageData = function(x, y, w, h) {
        // x,y: 시작 좌표 값, w: 넓이, h: 높이
        x = numberCheck(x, 0);
        y = numberCheck(y, 0);
        w = numberCheck(w, this.canvas.width);
        h = numberCheck(h, this.canvas.height);
        return this.ctx.getImageData(x, y, w, h);
    }
    // 이미지 데이터(canvas의 getImageData로 얻은 객체) 로 그리기 
    SignPad.prototype.setImageData = function(data, x=0, y=0) {
        this.ctx.putImageData(data, numberCheck(x, 0), numberCheck(y, 0));
        // 저장
        if(this.history.autoSave) this.save();
        return this;
    }
    // DataURL (data:image/png;base64,$data) 데이터로 변환 
    SignPad.prototype.getDataURL = function(extension='png', quality=1) {
        let type = {png: 'image/png', jpg: 'image/jpg', jpeg: 'image/jpg', gif: 'image/gif'};
        return this.canvas.toDataURL(type[extension] || type.png, numberCheck(quality, 1));
    }
    // DataURL, blob(URL.createObjectURL 사용) 데이터로 그리기 
    SignPad.prototype.setDataURL = function(data, x=0, y=0) {
        // Image 객체 = img 태그 
        let image = new Image();
        image.src = data;
        this.ctx.drawImage(image, numberCheck(x, 0), numberCheck(y, 0), this.canvas.width, this.canvas.height);
        // 저장
        if(this.history.autoSave) this.save();
        return this;
    }
    // base64 데이터로 변환 
    SignPad.prototype.getBase64Data = function(extension='png', quality=1) {
        let dataURL = this.getDataURL(extension, quality);
        return dataURL.split(',')[1];
    }
    
    
    // 이미지 파일, 파일 경로로 그리기 
//    SignPad.prototype.setImageFile = function(file, x=0, y=0) {
//        let image = new Image();
//        image.src = URL.createObjectURL(file);
//        
//        let {canvas, ctx} = this;
//        image.onload = function(e) {
//            ctx.drawImage(image, numberCheck(x, 0), numberCheck(y, 0), canvas.width, canvas.height);
//        }
//        return this;
//    }
    SignPad.prototype.setImageFile = async function(file, x=0, y=0) {
        let _this = this;
        let {canvas, ctx} = this;
        await new Promise((resolve, reject) => {
            let image = new Image();
            image.onload = function(e) {
                resolve(this);
            }
            if(typeof file === 'string') image.src = file;
            else if(file instanceof File) image.src = URL.createObjectURL(file);
        }).then((image) => {
            ctx.drawImage(image, numberCheck(x, 0), numberCheck(y, 0), canvas.width, canvas.height);   
            // 저장
            if(_this.history.autoSave) _this.save();
        });
        return this;
    }
    // File 객체로 변환 
    SignPad.prototype.getFile = function(filename='sign', extension='png', quality=1) {
        
        let type = {png: 'image/png', jpg: 'image/jpg', jpeg: 'image/jpg', gif: 'image/gif'};
        type = type[extension] || type.png;
        
        if(!(typeof filename === 'string' || typeof filename === 'number')) filename = 'sign';
        
        let base64 = this.getBase64Data(extension, numberCheck(quality,1));
        
        let byteString = atob(base64);
        let ab = new ArrayBuffer(byteString.length);
        let ua = new Uint8Array(ab);
        
        for(let i = 0; i < byteString.length; i++) {
            ua[i] = byteString.charCodeAt(i);
        }
        
        let blob = new Blob([ab], {type: type});
        let fd = new FormData();
        fd.append('file', blob, `${filename}.${type.replaceAll('image/', '')}`);
        return fd.get('file');
    }
    
    // img 태그에 미러링
    SignPad.prototype.mirroringImgTag = function(target, extension='png', quality=1) {
        if($(target).is('img')) {
            $(target).prop('src', this.getDataURL(extension, quality));
        }
        return this;
    }
    // history 자동 저장 설정 
    SignPad.prototype.setAutoSave = function(b=true) {
        if(typeof b === 'boolean') this.history.autoSave = b;
        return this;
    }
    // history 자동 저장 설정 값 조회 
    SignPad.prototype.getAutoSave = function() {
        return this.history.autoSave;
    }
    // 현재 상태 저장 
    SignPad.prototype.save = function(id) {
        // id 생성 
        id = id || new Date().getTime();
        // image data 생성
        let data = this.getImageData();
        // id 찾기 
        let i = this.history.findIndex((e) => e.id === id);
        // 중복 일 경우 덮어쓰기 
        if(i > -1) {
            this.history[i] = {id:id, data:data};
            this.history.currentIndex = i;
        }
        // 아닐경우 저장
        else {
            this.history.push({id:id, data:data});
            this.history.currentIndex = this.history.length - 1;
        }
        this.history.currentId = id;
        return this;
    }
    // id 값으로 특정 상태 되돌리기 
    SignPad.prototype.restoreById = function(id) {
        // index 찾기
        let i = this.history.findIndex((e) => e.id === id);
        if(i === -1) i = this.history.currentIndex;
        return this.restoreByIndex(i);
    }
    // index 값으로 특정 상태 되돌리기 
    SignPad.prototype.restoreByIndex = function(i) {
        if(typeof i === 'number' && i > -1 && i % 1 === 0 && this.history[i]) {
            let {id, data} = this.history[i];
            
            // 캔버스 초기화 
            //this.eraseAll();
            this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

            let compositeOperation = this.ctx.globalCompositeOperation;
            this.ctx.globalCompositeOperation = 'destination-over';

            // 데이터 적용 
            //this.setImageData(data, 0, 0);
            this.ctx.putImageData(data, 0, 0);
            

            this.ctx.globalCompositeOperation = compositeOperation;    
            
            // index, id 저장 
            this.history.currentIndex = i;
            this.history.currentId = id;
        } else {
            
        }
        return this;    
    }
    // 이전 상태로 되돌리기
    SignPad.prototype.prev = function() {
        return this.restoreByIndex(this.history.currentIndex-1);
    }
    // 다음 상태로 되돌리기 
    SignPad.prototype.next = function() {
        return this.restoreByIndex(this.history.currentIndex+1);
    }
    // 캔버스가 백지인지 여부 체크
    SignPad.prototype.isEmpty = function() {
        return !this.getImageData().data.some((pixel) => pixel !== 0);
    }
    
    w.SignPad = SignPad;
    
    
    // 
    $.fn.getSignPad = function() {
    	if(this.length > 0) 
    		return this.last().prop('SignPad');
    }
})(window, jQuery);