//首先使用document.addEventListener(),加载cordova 'deviceready'事件
$(function () {
    document.addEventListener("deviceready", onDeviceReady, false);
});



// ************************************程序启动后 **************************************
var onDeviceReady = function () {
	try{
    if (typeof (QRScanner) != 'undefined') {
        //初始化检测，申请摄像头等权限
    	
        QRScanner.prepare(onDone); // show the prompt
    } else {
        alert('插件加载失败');
    }
    function onDone(err, status) {
        if (err) {
            console.error(err);
        }
        if (status.authorized) {
            //绑定扫描监听
            // `QRScanner.cancelScan()` is called.
            QRScanner.scan(displayContents);
            function displayContents(err, text) {
                if (err) {
                    // an error occurred, or the scan was canceled (error code `6`)
                    alert('启动扫描出错：' + JSON.stringify(err));
                } else {
                    // The scan completed, display the contents of the QR code:
                    alert(text);
                }
            }
            //开始扫描，需要将页面的背景设置成透明
            QRScanner.show();
 
        } else if (status.denied) {
            // The video preview will remain black, and scanning is disabled. We can
            // try to ask the user to change their mind, but we'll have to send them
            // to their device settings with `QRScanner.openSettings()`.
            alert('用户拒绝访问摄像头');
        } else {
            // we didn't get permission, but we didn't get permanently denied. (On
            // Android, a denial isn't permanent unless the user checks the "Don't
            // ask again" box.) We can ask again at the next relevant opportunity.
        }
    }
  //切换开启手电筒
    var light = false;
    $('#btn1').click(function () {
        if (light) {
            QRScanner.enableLight();
            alert('enableLight');
        } else {
            QRScanner.disableLight();
        }
        light = !light;
    });
     
    //切换前后摄像头
    var frontCamera = false;
    $('#btn2').click(function () {
        if (frontCamera) {
            QRScanner.useFrontCamera();
            alert('useFrontCamera');
        } else {
            QRScanner.useBackCamera();
        }
        frontCamera = !frontCamera;
    });
	}
	catch(ex){
		alter(ex.toString());
	}
};
