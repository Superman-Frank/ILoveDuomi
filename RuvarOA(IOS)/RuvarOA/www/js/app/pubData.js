/*base by OA_APP*/
// 事件接口列表
var action = {
	OAPlugin : {/* 第一个接口 */
		Name : "OAPlugin",
		Action_GetToken : "XG_GetToken",// 获取XGToken
		Action_Login_Submit : "RV_Login_Submit",// 保存登录信息
		Action_Login_Read : "RV_Login_Read",// 读取记录的登录信息
		Action_XGUrl : "RV_XGUrl",// 读取集合推送的URL
		Action_AutoLoginOut : "RV_Login_Out",
		Action_Exit:"RV_Exit",
		Action_SysUrl : "RV_SysUrl",
		Action_GoHome:"RV_SysHome",
		Action_GoLogin:"RV_Login",
		Action_ClearCathe:"RV_ClearCathe",
		Action_ClearLocalStorage:"RV_ClearLocalStorage"
		
	}
	/* 其它的方法 */
};

// 返回主页插件=================
var goHome=function(){
	try{
	cordova.exec(
			null,
			null,
			action.OAPlugin.Name,
			action.OAPlugin.Action_GoHome,
			[]
		);
	}
	catch(e){}
};


var goLogin=function(backurl){
	var jsonData="[{";
	jsonData+=actionData.OAPlugin.GoLogin+":\""+backurl+"\"";
	jsonData+="}]";
	var json=eval(jsonData);
	try{
	    var param='action=action_logout';

        //退出登录
        $.ajax({ //一个Ajax过程
                type: "post", //以post方式与后台沟通
                url: SysUrl+'/mobile/include/appservice.ashx',  //与此ashx页面沟通
                contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                dataType: 'json', //从ashx返回的值以 JSON方式 解释
                data:param,
                success: function (result) {
                    if(result.ret_code=="0"){
                        J.showToast('退出成功', 'success');
                        cordova.exec(null,null,action.OAPlugin.Name,action.OAPlugin.Action_GoLogin,json);
                    }else{
                        J.showToast(result.ret_code, 'error');
              	    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    J.showToast('错误', 'error');
                }
        });

	}
	catch(e){}
};


// app返回的相关数据名称
var actionData = {
	OAPlugin : {/* 第一个接口 */
		GetToken : {
			tokenName : "token"// token json名
		},
		Login_SubmitAndRead : {
			SysUrl : "SysUrl",// 服务器地址
			AutoLogin : "AutoLogin",// 是否自动登录，1为自动登录
			SavePwd : "SavePwd",// 记住密码
			LoginUser : "LoginUser",// 用户名
			LoginPwd : "LoginPwd"// 用户密码
		},
		XGURL : "XGUrl",
		AutoLOut : {
			actName : "act",
			actMethod : {// 调用的事件子方法
				read : "get",
				write : "set"
			},
			actstatus : "status"// 当为get时，1为退出了自动登录，一次有效，当为set时，设置成功

		},
		
		GoLogin:"backurl",
		SysUrl : "SysUrl"
	}
};
var serviceurl="/RuvarOA/mobile/basehandle.ashx";

//提示框		
var doTip=function(message,t){
	if($("#div_toast").text()==null||$("#div_toast").text()==""){
		$("body").append("<div id=\"div_toast\" class=\"div_Tip\">ttt</div>");
	}
	$('#div_toast').html(message);
	$('#div_toast').show();
	if (t == 'hide')
	{
		$('#div_toast').hide();
		return;
	}
	if (t == 0)
	{
		return;
	}
	
	toast_timer = setTimeout(function(){ $('#div_toast').hide(); }, t);
};

// 退出确认弹窗 和 退出插件=================
var doExit=function(){
	navigator.notification.confirm(
    '确定退出？', // message
     function(bindex){            // callback to invoke with index of button pressed
     	if(bindex==1){
     		cordova.exec(function(){},function(){},action.OAPlugin.Name,action.OAPlugin.Action_Exit,[]);
     	}
     },
    '退出',           // title
    ['确定','取消']     // buttonLabels
);
	/*if(confirm("确定退出？")){
		cordova.exec(function(){},function(){},action.OAPlugin.Name,action.OAPlugin.Action_Exit,[]);
	}*/
};


// 清理缓存插件=================
var ClearCache=function(){
     	cordova.exec(function(){},function(){},action.OAPlugin.Name,action.OAPlugin.Action_ClearCathe,[]);
        J.showToast('清理成功！');
	/*if(confirm("确定退出？")){
		cordova.exec(function(){},function(){},action.OAPlugin.Name,action.OAPlugin.Action_Exit,[]);
	}*/
};
// 清理本地存储插件=================
var ClearLocalStorage=function(){
     	cordova.exec(function(){},function(){},action.OAPlugin.Name,action.OAPlugin.Action_ClearLocalStorage,[]);
        J.showToast('清理LS成功！');
	/*if(confirm("确定退出？")){
		cordova.exec(function(){},function(){},action.OAPlugin.Name,action.OAPlugin.Action_Exit,[]);
	}*/
};


// alert插件的使用
window.alert=function(title){
	navigator.notification.alert(
    title,  // message
    function(){},        // callback
    '系统提示',            // title
    '确定'                // buttonName
);
};

