using UnityEngine;
using System.Collections;

public class BPushTest : MonoBehaviour {
	
	// 在脚本的初始化方法中，发起绑定请求
	void Start () {
		Debug.Log("Unity main object start");
		Debug.Log("bind channel");
		BPushSDKConector.baiduBindChannel();
		
		// 给当前设备添加一些 tags ，之后可以使用这些 tag 中的一个进行组播推送
		Debug.Log ("set tags");
		BPushSDKConector.baiduSetTags ("[\"well\",\"cheng\",\"ios\"]");
		
		// 发起解绑请求，之后将无法接收百度云推送的推送消息
		Debug.Log("unbind channel");
		BPushSDKConector.baiduUnBindChannel();
	}
	
	// Update is called once per frame
	void Update () {
		
	}
	
	// recieve baidu push call back
	// 对于 SDK 的调用的结果都通过这些回调方法返回
	// 可以根据返回结果，经过判断后做一些业务相关的操作
	// 需要注意的是，这些回调方法都是通过 UnitySendMessage 方法回调，因此当前脚本绑定的 Game Object 必须名为 BPushBind
	void bindChannel(string jsonString) {
		Debug.Log ("bind: " + jsonString);
	}
	
	void unbindChannel(string jsonString) {
		Debug.Log ("unbindChannel: " + jsonString);
	}
	
	void getChannelId(string jsonString) {
		Debug.Log ("getChannelId: " + jsonString);
	}
	
	void listTags(string jsonString) {
		Debug.Log ("listTags: " + jsonString);
	}
	
	void setTags(string jsonString) {
		Debug.Log ("setTags: " + jsonString);
	}
	
	void delTags(string jsonString) {
		Debug.Log ("delTags: " + jsonString);
	}
}