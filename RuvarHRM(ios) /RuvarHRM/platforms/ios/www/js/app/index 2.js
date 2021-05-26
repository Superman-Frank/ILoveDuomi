//首先使用document.addEventListener(),加载cordova 'deviceready'事件
$(function () {
  alert(2)
    document.addEventListener("deviceready", onDeviceReady, false);
  
});


var v_token="";
//var v_token=165165;

var v_HomePage="";
var v_XGURL="";
var v_LoginPage="/mobile/login.ashx";




// ************************************程序启动后 **************************************
var onDeviceReady = function () {
    alert(4)
    //1. 获取Token
    getToken();
    //2. 获取信鸽url
//    getXGUrl();
    //3. 获取登录信息
    GetAutoLoginInfo();

    $("#chk_autoLogin").change(function(){
    	if($(this).prop('checked')){
    		$("#chk_savePwd").prop('checked',true);
    	}
    });
//    navigator.splashscreen.hide();
//    document.addEventListener("backbutton", function (e) {
//          J.confirm('提示','是否退出应用？',function(){
//                 navigator.app.exitApp();
//          });
//    }, false);

    //登录点击事件
    $("#login").click(doLogin);      // doLogin是函数名称
};

/*
//返回键
function eventBackButton(){
//confirm("再点击一次退出!");
//window.plugins.THRMstPlugin.show_short('再点击一次退出!');
//document.removeEventListener("backbutton", eventBackButton, false); //注销返回键
    //3秒后重新注册
	 document.addEventListener("backbutton", eventBackButton, false); //返回键
    var intervalID = window.setInterval(
        function() {
           window.clearInterval(intervalID);
           document.addEventListener("backbutton", eventBackButton, false); //返回键
        },
        3000
   );
	navigator.app.exitApp();
}
*/


//2. 调用插件获取信鸽的url==================插件4 =================
var getXGUrl=function(){
	cordova.exec(                       //调用java中的插件代码
        function (data) {                  //成功的回调
            v_XGURL=data[actionData.HRMPlugin.XGURL];
            document.write("打印XGURL："+data["token"]);
        },
        function (data) {                   //失败的回调
            document.write(data.toString());
        },
        action.HRMPlugin.Name,              //插件的name
        action.HRMPlugin.Action_XGUrl,      //插件连接的url
        []                                  //参数（不用携带）
	);
};


//1. 调用插件获取信鸽的token===============插件1 =================
var getToken = function () {
    cordova.exec(                        //调用java中的插件代码
	function (data) {                    //成功的回调
		v_token=data[actionData.HRMPlugin.GetToken.tokenName];
//	    document.write(data["token"]);
        console.log("v_token获取成功==="+v_token);
	},
	function (data) {                    //失败的回调
//	    document.write(data.toString());
        console.log("v_token获取失败==="+data.toString());
	},
	action.HRMPlugin.Name,               //插件的name （action.config中插件的name）
	action.HRMPlugin.Action_GetToken,    //插件连接的url（action.类名.字符串）
	[]                                   //参数（不用携带）
	);
};



//获取自动登录及保存密码相关信息===============插件3 =================已应用
var GetAutoLoginInfo=function(){
	cordova.exec(
	function (data) {
		var url=data[actionData.HRMPlugin.Login_SubmitAndRead.SysUrl].replace(/^http:\/\//i,'');
//		var url=data[actionData.HRMPlugin.Login_SubmitAndRead.SysUrl];
        console.log("获取登陆过的url==="+url);
                 
	    $("#txt_serverUrl").val(url);
	    $("#txt_LoginAccount").val(data[actionData.HRMPlugin.Login_SubmitAndRead.LoginUser]);
	    //保存密码
	    if(data[actionData.HRMPlugin.Login_SubmitAndRead.SavePwd]=="1"){
	    	$("#chk_savePwd").prop("checked",true);
	    	$("#txt_LoginPwd").val(data[actionData.HRMPlugin.Login_SubmitAndRead.LoginPwd]);
	    }
	    //自动登录
	    if(data[actionData.HRMPlugin.Login_SubmitAndRead.AutoLogin]=="1"){
	    	$("#chk_autoLogin").prop("checked",true);
	    	$("#chk_savePwd").prop("checked",true);
	    	$("#txt_LoginAccount").val(data[actionData.HRMPlugin.Login_SubmitAndRead.LoginUser]);
	    	$("#txt_LoginPwd").val(data[actionData.HRMPlugin.Login_SubmitAndRead.LoginPwd]);
	    	var datas=AutoLoginOut(actionData.HRMPlugin.AutoLOut.actMethod.read,"1");
	    	if(datas[actionData.HRMPlugin.AutoLOut.actstatus]=="0"){
	    		$("#login").click();
	    	}
	    }
	},
	function (data) {
	    document.write(data.toString());
	}
	,
	action.HRMPlugin.Name,
	action.HRMPlugin.Action_Login_Read,
	[]
	);
};


//保存登录的相关参数===============插件3 =================
var SetAutoLoginInfo=function(json){
	cordova.exec(
	function(data){},
	function(data){},
	action.HRMPlugin.Name,
	action.HRMPlugin.Action_Login_Submit,
	json	
	);
};



//获取或者设备自动登录退出状态===============插件5 =================
var AutoLoginOut=function(act,status){
	//读取
	var data;
	//调用自定义插件HRMPlugin.java
	if(act=actionData.HRMPlugin.AutoLOut.actMethod.read){
	    //执行
		cordova.exec(
			function(cdata){
				alert(data[actionData.HRMPlugin.AutoLOut]);
				data=cdata;
			},
			function(cdata){
				alert(data[actionData.HRMPlugin.AutoLOut]);
				data=cdata;
			},
			action.HRMPlugin.Name,
			action.HRMPlugin.Action_AutoLoginOut,
			[{"act":"get"}]
		);
	}
	else
	{
		cordova.exec(
			function(cdata){
				alert(data[actionData.HRMPlugin.AutoLOut]);
				data=cdata;
			},
			function(){
				alert(data[actionData.HRMPlugin.AutoLOut]);
				data=cdata;
			},
			action.HRMPlugin.Name,
			action.HRMPlugin.Action_AutoLoginOut,
			[{"act":"set"}]
		);
	}
	return data;
};















// 登录事件
var doLogin=function(){
	//获取登录相关
	var _url="http://"+$("#txt_serverUrl").val().replace(/^http:\/\//i,'');
//    var _url="http://"+$("#txt_serverUrl").val();
	console.log("js:url==="+_url);


	var jsonData="[{"+actionData.HRMPlugin.Login_SubmitAndRead.SysUrl+":\""+_url+"\""
	+","+actionData.HRMPlugin.Login_SubmitAndRead.LoginUser+":\""+$("#txt_LoginAccount").val()+"\"";
	//alert($("#chk_savePwd").prop('checked'));
	
	if($("#chk_autoLogin").prop('checked')){
		//alert('自动登录！');
		jsonData+=","+actionData.HRMPlugin.Login_SubmitAndRead.AutoLogin+":\"1\""+
		","+actionData.HRMPlugin.Login_SubmitAndRead.SavePwd+":\"1\""+
		","+actionData.HRMPlugin.Login_SubmitAndRead.LoginPwd+":\""+$("#txt_LoginPwd").val()+"\"";
	}
	else if($("#chk_savePwd").prop('checked')){
		//alert('保存密码！');
		jsonData+=","+actionData.HRMPlugin.Login_SubmitAndRead.AutoLogin+":0"+
		","+actionData.HRMPlugin.Login_SubmitAndRead.SavePwd+":\"1\""+
		","+actionData.HRMPlugin.Login_SubmitAndRead.LoginPwd+":\""+$("#txt_LoginPwd").val()+"\"";
	}
	else
	{
		jsonData+=","+actionData.HRMPlugin.Login_SubmitAndRead.AutoLogin+":\"0\""+
		","+actionData.HRMPlugin.Login_SubmitAndRead.SavePwd+":\"0\""+
		","+actionData.HRMPlugin.Login_SubmitAndRead.LoginPwd+":\""+$("#txt_LoginPwd").val()+"\"";
	}
	jsonData+="}]";
	var json=eval(jsonData);
	if(json[0][actionData.HRMPlugin.Login_SubmitAndRead.SysUrl]==null||json[0][actionData.HRMPlugin.Login_SubmitAndRead.SysUrl]==""){
		doTip('服务器地址不能为空!', 3000);
		return false;
	}
	if(json[0][actionData.HRMPlugin.Login_SubmitAndRead.LoginUser]==null||json[0][actionData.HRMPlugin.Login_SubmitAndRead.LoginUser]==""
		||json[0][actionData.HRMPlugin.Login_SubmitAndRead.LoginPwd]==null||json[0][actionData.HRMPlugin.Login_SubmitAndRead.LoginPwd]==""
			){
		doTip('账号或者密码不能为空!', 3000);
		return false;
	}

	//保存设置的相关自动登录信息
    //TODO
	SetAutoLoginInfo(json);
                                                         
	doTip("正在登录...",0);
	$("#txt_serverUrl").prop("disabled","disabled");
	$("#txt_LoginAccount").prop("disabled","disabled");
	$("#txt_LoginPwd").prop("disabled","disabled");
	$("#chk_savePwd").prop("disabled","disabled");
	$("#chk_autoLogin").prop("disabled","disabled");
	$("#login").prop("disabled","disabled");



	/* 网络访问*/
	//url
	var posturl=json[0][actionData.HRMPlugin.Login_SubmitAndRead.SysUrl].replace(/\/$/i,'')+serviceurl;
//    var posturl=_url+"/ruvarhrm/mobile/basehandle.ashx";

	//posturl+="?_t="+parseInt(Math.random()*10000000+1);
	/*var postform="<form  method=\"post\" name=\"form1\" id=\"form1\" action=\""+posturl+"\">";
	postform+="<input type=\"text\" id=\"account\" name=\"account\" value=\""+json[0][actionData.HRMPlugin.Login_SubmitAndRead.LoginUser]+"\"/>";
	postform+="<input type=\"password\" id=\"pwd\" name=\"pwd\" value=\""+json[0][actionData.HRMPlugin.Login_SubmitAndRead.LoginPwd]+"\"/>";
	postform+="<input type=\"submit\" id=\"btnsubmit\"/>";
	postform+="</form>";*/
	console.log("js:url==="+posturl);

    //param
//    var account=$('#txt_LoginAccount').val();
//    var pwd = $('#txt_LoginPwd').val();
//    var param='action=action_login&dtype=1&token='+ v_token +'&account='+account+'&pwd='+pwd+'&_t='+parseInt(Math.random()*100000+1);
	var param='action=action_login&dtype=2&token='+ v_token +'&account='
	 + json[0][actionData.HRMPlugin.Login_SubmitAndRead.LoginUser] + '&pwd='
	 + json[0][actionData.HRMPlugin.Login_SubmitAndRead.LoginPwd] + '&goback_url='
	 +v_HomePage+'&_t='+parseInt(Math.random()*100000+1);


	if(v_XGURL!=null&&v_XGURL!=""){
		param='action=action_login&dtype=2&token='+ v_token +'&account='
		+ json[0][actionData.HRMPlugin.Login_SubmitAndRead.LoginUser] + '&pwd='
		+ json[0][actionData.HRMPlugin.Login_SubmitAndRead.LoginPwd] + '&goback_url='
		+ v_XGURL+'&_t='+parseInt(Math.random()*100000+1);
	}
    console.log("js:param==="+param);
	$.ajax({ //一个Ajax过程
        type: "post", //以post方式与后台沟通
        url: posturl, //与此ashx页面沟通
        contentType:"application/x-www-form-urlencoded; charset=UTF-8",
        dataType: 'json', //从ashx返回的值以 JSON方式 解释
         data: param,
        success: function (result) {
            console.log(result);
            if(result.status=="success"){
                doTip("登录成功！",300);
                //AutoLoginOut("set","1");
                if(v_XGURL=="")
                {
                    window.location.u_eid = result.u_name;
                    //location.href页面跳转，并把需要的参数传入到window.location.href中。B页面可以取出
                    //登录成功，跳转到home.html页面
//           alert(_url+ "/RuvarHRM/mobile/home.html?name="
//                 +result.u_name                      //名字
//                 +"&u_eid="+result.u_eid             //档案id
//                 +"&u_id="+result.u_id               //员工id
//                 +"&u_bind="+result.u_bind           //是否已绑定员工自助账号
//                 +"&u_position="+result.u_position   //职位
//                 +"&u_split=1");
                    location.href = _url+ "/RuvarHRM/mobile/home.html?name="
                    +result.u_name                      //名字
                    +"&u_eid="+result.u_eid             //档案id
                    +"&u_id="+result.u_id               //员工id
                    +"&u_bind="+result.u_bind           //是否已绑定员工自助账号
                    +"&u_position="+result.u_position   //职位
                    +"&u_split=1";
                    console.log(location.href);
                }
                else
                {
                    console.log("登陆不成");
//                    location.href=result.url;
                }
                //location.href=homeurl+result.url;
            }
            else
            {
                //homeurl+result.url.replace(/^\//i,'')
                doTip(result.msg,3000);
                $("#txt_serverUrl").prop("disabled","");    //登录页面：地址栏
                $("#txt_LoginAccount").prop("disabled",""); //登录页面：账户
                $("#txt_LoginPwd").prop("disabled","");     //登录页面：密码
                $("#chk_savePwd").prop("disabled","");      //登录页面：记住密码
                $("#chk_autoLogin").prop("disabled","");    //登录页面：自动登录
                $("#login").prop("disabled","");            //登录按钮
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            doTip("服务器地址或网络错误！",5000);
            console.log("parma:"+param);
            $("#txt_serverUrl").prop("disabled","");   //登录页面：地址栏
            $("#txt_LoginAccount").prop("disabled","");//登录页面：账户
            $("#txt_LoginPwd").prop("disabled","");    //登录页面：密码
            $("#chk_savePwd").prop("disabled","");     //登录页面：记住密码
            $("#chk_autoLogin").prop("disabled","");   //登录页面：自动登录
            $("#login").prop("disabled","");           //登录按钮
            }
        });
	//alert(postform);
	//alert($("body").html());
	/*$("body").append(postform);
	$("#btnsubmit").click();*/
};




//未被是使用
var RSALogin=function(){

    $.ajax({
          type: "POST",
          url: "RSALogin.ashx",
          data: "action=action_getkey",
          contentType:"application/x-www-form-urlencoded; charset=UTF-8",
          dataType: 'json',
          success: function (response) {
                setMaxDigits(131);
                //打印服务器返回的json
                console.log(response);
                //取到需要的数据
                var key = new RSAKeyPair(response.list[0].strPublicKeyExponent, "", response.list[0].strPublicKeyModulus);
                console.log(key);
                $.ajax({
                      data: {'action':'action_login', 'username': username, 'password': encryptedString(key, "123456"), 'rememberpassword': $('#rememberpassword').is(':checked'), '__RequestVerificationToken': token },
                      type: "POST",
                      url: "RSALogin.ashx",
                      dataType: 'json',
                      success: function (response, textStatus, jqXHR) {
                            console.log(response);
                      },
                      error: function (xhr, textStatus, errorThrown) {
                            console.log("error");
                      }
                });
          },
          error: function (xhr, textStatus, errorThrown) {
                console.log("error");
          }
    });
};
