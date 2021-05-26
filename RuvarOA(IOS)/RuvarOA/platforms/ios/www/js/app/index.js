//首先使用document.addEventListener(),加载cordova 'deviceready'事件
$(function () {
  document.addEventListener("deviceready", onDeviceReady, false);
  });


var v_token="";
var v_HomePage="";
var v_XGURL="";
var wifiJson="";




// ************************************程序启动后 **************************************
var onDeviceReady = function () {
//        getWifi();
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
    //登录点击事件
    $("#login").click(doLogin); // doLogin是函数名称
};


//返回键
function eventBackButton(){
    //confirm("再点击一次退出!");
    //window.plugins.TOAstPlugin.show_short('再点击一次退出!');
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



//2. 调用插件获取信鸽的url==================插件4 =================
var getXGUrl=function(){
    cordova.exec(                       //调用java中的插件代码
                 function (data) {                  //成功的回调
                     v_XGURL=data[actionData.OAPlugin.XGURL];
                 },
                 function (data) {                   //失败的回调
                    document.write(data.toString());
                 },
                 action.OAPlugin.Name,              //插件的name
                 action.OAPlugin.Action_XGUrl,      //插件连接的url
                 []                                  //参数（不用携带）
                 );
};//1. 调用插件获取信鸽的token===============插件1 =================
var getToken = function () {
    cordova.exec(                        //调用java中的插件代码
                 function (data) {                    //成功的回调
                 v_token=data[actionData.OAPlugin.GetToken.tokenName];
                 },
                 function (data) {                    //失败的回调
                 document.write(data.toString());
                 },
                 action.OAPlugin.Name,               //插件的name （action.config中插件的name）
                 action.OAPlugin.Action_GetToken,    //插件连接的url（action.类名.字符串）
                 []                                   //参数（不用携带）
                 );
};

  var getWifi = function () {
      cordova.exec(                        //调用java中的插件代码
      function (data) {                    //成功的回调
          wifiJson=data[actionData.OAPlugin.GetWifi.wifiJson];
      },
      function (data) {                    //失败的回调
          document.write(data.toString());
      },
      action.OAPlugin.Name,               //插件的name （action.config中插件的name）
      action.OAPlugin.Action_WifiInfo,    //插件连接的url（action.类名.字符串）
      []                                   //参数（不用携带）
      );
  };


//获取自动登录及保存密码相关信息===============插件3 =================已应用
var GetAutoLoginInfo=function(){
    cordova.exec(
        function (data) {
                 var url=data[actionData.OAPlugin.Login_SubmitAndRead.SysUrl];
                 if(url!=""){
                 url=url.replace(/^http:\/\//i,'');
                 }
                   $("#txt_serverUrl").val(url);
                   $("#txt_LoginAccount").val(data[actionData.OAPlugin.Login_SubmitAndRead.LoginUser]);
                   //保存密码
                   if(data[actionData.OAPlugin.Login_SubmitAndRead.SavePwd]=="1"){
                       $("#chk_savePwd").prop("checked",true);
                       $("#txt_LoginPwd").val(data[actionData.OAPlugin.Login_SubmitAndRead.LoginPwd]);
                   }
                   //自动登录
                   if(data[actionData.OAPlugin.Login_SubmitAndRead.AutoLogin]=="1"){
                       $("#chk_autoLogin").prop("checked",true);
                       $("#chk_savePwd").prop("checked",true);
                       $("#txt_LoginAccount").val(data[actionData.OAPlugin.Login_SubmitAndRead.LoginUser]);
                       $("#txt_LoginPwd").val(data[actionData.OAPlugin.Login_SubmitAndRead.LoginPwd]);
                       var datas=AutoLoginOut(actionData.OAPlugin.AutoLOut.actMethod.read,"1");
                       if(datas[actionData.OAPlugin.AutoLOut.actstatus]=="0"){
                            $("#login").click();
                       }
                   }
               },
               function (data) {
                    document.write(data.toString());
               }
               ,
               action.OAPlugin.Name,
               action.OAPlugin.Action_Login_Read,
               []
               );
 };
                 
                 
                 //保存登录的相关参数===============插件3 =================
                 var SetAutoLoginInfo=function(json){
                 cordova.exec(
                              function(data){},
                              function(data){},
                              action.OAPlugin.Name,
                              action.OAPlugin.Action_Login_Submit,
                              json
                              );
                 };
                 
                 //获取或者设备自动登录退出状态===============插件5 =================
                 var AutoLoginOut=function(act,status){
                 //读取
                 var data;
                 //调用自定义插件OAPlugin.java
                 if(act=actionData.OAPlugin.AutoLOut.actMethod.read){
                 //执行
                 cordova.exec(
                              function(cdata){
                              alert(data[actionData.OAPlugin.AutoLOut]);
                              data=cdata;
                              },
                              function(cdata){
                              alert(data[actionData.OAPlugin.AutoLOut]);
                              data=cdata;
                              },
                              action.OAPlugin.Name,
                              action.OAPlugin.Action_AutoLoginOut,
                              [{"act":"get"}]
                              );
                 }else{
                 cordova.exec(
                              function(cdata){
                              alert(data[actionData.OAPlugin.AutoLOut]);
                              data=cdata;
                              },
                              function(){
                              alert(data[actionData.OAPlugin.AutoLOut]);
                              data=cdata;
                              },
                              action.OAPlugin.Name,
                              action.OAPlugin.Action_AutoLoginOut,
                              [{"act":"set"}]
                              );
                 }
                 return data;
                 };
                 
             
//app获取访问java的跳转路径，部署在.net项目中根目录的config下面
//登录事件
var doLogin=function(){
     if($("#txt_serverUrl").val()==""){
         doTip("服务器地址不能为空!", 3000);
         return false;
     }
     
            //获取登录相关
            // var _url="http://"+$("#txt_serverUrl").val().replace(/^http:\/\//i,'');
       var jsonData="[{"+actionData.OAPlugin.Login_SubmitAndRead.SysUrl+":\""+$("#txt_serverUrl").val().replace(/^http:\/\//i,'')+"\""
         +","+actionData.OAPlugin.Login_SubmitAndRead.LoginUser+":\""+$("#txt_LoginAccount").val()+"\"";
    
    if($('#chk_savePwd').is(':checked')) {
       jsonData+=","+actionData.OAPlugin.Login_SubmitAndRead.AutoLogin+":0"+
        ","+actionData.OAPlugin.Login_SubmitAndRead.SavePwd+":\"1\""+
        ","+actionData.OAPlugin.Login_SubmitAndRead.LoginPwd+":\""+$("#txt_LoginPwd").val()+"\"";
    }else{
       jsonData+=","+actionData.OAPlugin.Login_SubmitAndRead.AutoLogin+":0"+
        ","+actionData.OAPlugin.Login_SubmitAndRead.SavePwd+":\"0\""+
        ","+actionData.OAPlugin.Login_SubmitAndRead.LoginPwd+":\""+$("#txt_LoginPwd").val()+"\"";
    }


         jsonData+="}]";
         var json=eval(jsonData);
     if(json[0][actionData.OAPlugin.Login_SubmitAndRead.SysUrl]==null||json[0][actionData.OAPlugin.Login_SubmitAndRead.SysUrl]==""){
             doTip("服务器地址不能为空!", 3000);
             return false;
         }
     if(json[0][actionData.OAPlugin.Login_SubmitAndRead.LoginUser]==null||json[0][actionData.OAPlugin.Login_SubmitAndRead.LoginUser]==""
        ||json[0][actionData.OAPlugin.Login_SubmitAndRead.LoginPwd]==null||json[0][actionData.OAPlugin.Login_SubmitAndRead.LoginPwd]==""
        ){
         doTip("账号或者密码不能为空!", 3000);
         return false;
        }
         //保存设置的相关自动登录信息
         SetAutoLoginInfo(json);
         //提示，并禁用可操作的控件
         doTip("正在登录...",0);
         $("#txt_serverUrl").attr("disabled","disabled");
         $("#txt_LoginAccount").attr("disabled","disabled");
         $("#txt_LoginPwd").attr("disabled","disabled");
         $("#chk_savePwd").attr("disabled","disabled");
         $("#login").attr("disabled","disabled");

         /* 网络访问*/
         //url
         var posturl="http://"+json[0][actionData.OAPlugin.Login_SubmitAndRead.SysUrl].replace(/^http:\/\//i,'');
         subLogin(json[0][actionData.OAPlugin.Login_SubmitAndRead.LoginUser],
                  json[0][actionData.OAPlugin.Login_SubmitAndRead.LoginPwd],v_token,posturl);
         
       };
                 
           function subLogin(LoginUser,LoginPwd,v_token,posturl){
           var param={"account":LoginUser,"pwd":LoginPwd,"dtype":2,"deviceId":v_token};
           $.ajax({ //一个Ajax过程
                  type: "post", //以post方式与后台沟通
                  url: posturl+serviceurl+"?action=action_login", //与此ashx页面沟通
                  contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                  dataType: 'json', //从ashx返回的值以 JSON方式 解释
                  data: param,
                  success: function (result) {
                  //console.log(json.tostringify(result));
                      if(result.status=="success"){
                        doTip("登录成功，跳转中！",300);
                        location.href=posturl+result.url;
                      }else{
                          //提示，并移除禁用属性
                          doTip(result.msg,3000);
                          $("#txt_serverUrl").removeAttr("disabled");  //登录页面：地址栏
                          $("#txt_LoginAccount").removeAttr("disabled");//登录页面：账户
                          $("#txt_LoginPwd").removeAttr("disabled");//登录页面：密码
                          $("#chk_savePwd").removeAttr("disabled"); //登录页面：记住密码
                          $("#login").removeAttr("disabled"); //登录按钮
                      }
                  },
                  error: function (XMLHttpRequest, textStatus, errorThrown) {
                      //提示，并移除禁用属性
                      doTip("网络错误或服务器地址！",5000);
                      $("#txt_serverUrl").removeAttr("disabled");  //登录页面：地址栏
                      $("#txt_LoginAccount").removeAttr("disabled");//登录页面：账户
                      $("#txt_LoginPwd").removeAttr("disabled");//登录页面：密码
                      $("#chk_savePwd").removeAttr("disabled"); //登录页面：记住密码
                      $("#login").removeAttr("disabled"); //登录按钮
                  }
                  });
           };
                                                                               
                                                                               //// 登录事件
                                                                               //var doLogin=function(){
                                                                               //    //获取登录相关
                                                                               //    var _url="http://"+$("#txt_serverUrl").val().replace(/^http:\/\//i,'');
                                                                               //    console.log(_url);
                                                                               //    var jsonData="[{"+actionData.OAPlugin.Login_SubmitAndRead.SysUrl+":\""+_url+"\""
                                                                               //    +","+actionData.OAPlugin.Login_SubmitAndRead.LoginUser+":\""+$("#txt_LoginAccount").val()+"\"";
                                                                               //
                                                                               //    jsonData+=","+actionData.OAPlugin.Login_SubmitAndRead.AutoLogin+":0"+
                                                                               //    ","+actionData.OAPlugin.Login_SubmitAndRead.SavePwd+":\"1\""+
                                                                               //    ","+actionData.OAPlugin.Login_SubmitAndRead.LoginPwd+":\""+$("#txt_LoginPwd").val()+"\"";
                                                                               //
                                                                               //    jsonData+="}]";
                                                                               //    var json=eval(jsonData);
                                                                               //    if(json[0][actionData.OAPlugin.Login_SubmitAndRead.SysUrl]==null||json[0][actionData.OAPlugin.Login_SubmitAndRead.SysUrl]==""){
                                                                               //        doTip('服务器地址不能为空!', 3000);
                                                                               //        return false;
                                                                               //    }
                                                                               //    if(json[0][actionData.OAPlugin.Login_SubmitAndRead.LoginUser]==null||json[0][actionData.OAPlugin.Login_SubmitAndRead.LoginUser]==""
                                                                               //        ||json[0][actionData.OAPlugin.Login_SubmitAndRead.LoginPwd]==null||json[0][actionData.OAPlugin.Login_SubmitAndRead.LoginPwd]==""
                                                                               //            ){
                                                                               //        doTip('账号或者密码不能为空!', 3000);
                                                                               //        return false;
                                                                               //    }
                                                                               //    //保存设置的相关自动登录信息
                                                                               //    SetAutoLoginInfo(json);
                                                                               //    //提示，并禁用可操作的控件
                                                                               //    doTip("正在登录...",0);
                                                                               //    $("#txt_serverUrl").attr("disabled","disabled");
                                                                               //    $("#txt_LoginAccount").attr("disabled","disabled");
                                                                               //    $("#txt_LoginPwd").attr("disabled","disabled");
                                                                               //    $("#chk_savePwd").attr("disabled","disabled");
                                                                               //    $("#login").attr("disabled","disabled");
                                                                               //
                                                                               //    /* 网络访问*/
                                                                               //    //url
                                                                               //    var posturl=json[0][actionData.OAPlugin.Login_SubmitAndRead.SysUrl].replace(/\/$/i,'')+serviceurl;
                                                                               //    var param={"username":json[0][actionData.OAPlugin.Login_SubmitAndRead.LoginUser]
                                                                               //    ,"password":json[0][actionData.OAPlugin.Login_SubmitAndRead.LoginPwd],"deviceId":v_token};
                                                                               //    $.ajax({ //一个Ajax过程
                                                                               //        type: "post", //以post方式与后台沟通
                                                                               //        url: posturl, //与此ashx页面沟通
                                                                               //        contentType:"application/x-www-form-urlencoded; charset=UTF-8",
                                                                               //        dataType: 'json', //从ashx返回的值以 JSON方式 解释
                                                                               //         data: param,
                                                                               //        success: function (result) {
                                                                               //            if(result.flag=="1"){
                                                                               //                doTip("登录成功！",300);
                                                                               //                location.href=result.url;
                                                                               //            }else{
                                                                               //                //提示，并移除禁用属性
                                                                               //                doTip(result.msg,3000);
                                                                               //                $("#txt_serverUrl").removeAttr("disabled");  //登录页面：地址栏
                                                                               //                $("#txt_LoginAccount").removeAttr("disabled");//登录页面：账户
                                                                               //                $("#txt_LoginPwd").removeAttr("disabled");//登录页面：密码
                                                                               //                $("#chk_savePwd").removeAttr("disabled"); //登录页面：记住密码
                                                                               //                $("#login").removeAttr("disabled"); //登录按钮
                                                                               //            }
                                                                               //        },
                                                                               //        error: function (XMLHttpRequest, textStatus, errorThrown) {
                                                                               //                //提示，并移除禁用属性
                                                                               //                doTip("服务器地址或网络错误！",5000);
                                                                               //                $("#txt_serverUrl").removeAttr("disabled");  //登录页面：地址栏
                                                                               //                $("#txt_LoginAccount").removeAttr("disabled");//登录页面：账户
                                                                               //                $("#txt_LoginPwd").removeAttr("disabled");//登录页面：密码
                                                                               //                $("#chk_savePwd").removeAttr("disabled"); //登录页面：记住密码
                                                                               //                $("#login").removeAttr("disabled"); //登录按钮
                                                                               //            }
                                                                               //        });
                                                                               //};
                                                                               
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
                                                                               
                                                                               // 获取服务器地址=================插件6 ==================此部分属于插件js部分，应用部分在app.js
                                                                               //var getSysUrl = function() {
                                                                               //    cordova.exec(function(data) {
                                                                               //        //当启动index页面时，使用并没有访问服务器，因此获取不到服务器的地址
                                                                               //        SysUrl = data[actionData.OAPlugin.SysUrl];             //预加载时，获取服务器地址到 SysUrl全局变量中
                                                                               //        console.log(SysUrl);
                                                                               //
                                                                               //    }, function(data) {
                                                                               //    }, action.OAPlugin.Name, action.OAPlugin.Action_SysUrl, [{}]);
                                                                               //};
