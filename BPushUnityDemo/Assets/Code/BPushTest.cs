using UnityEngine;
using System.Collections;

public class BPushTest : MonoBehaviour {

	// Use this for initialization
	void Start () {
		Debug.Log("Unity main object start");
		Debug.Log("bind channel");
		BPushSDKConector.baiduBindChannel();

		Debug.Log ("set tags");
		BPushSDKConector.baiduSetTags ("[\"well\",\"cheng\",\"ios\"]");

		Debug.Log("unbind channel");
		BPushSDKConector.baiduUnBindChannel();
		

	}
	
	// Update is called once per frame
	void Update () {
	
	}

	// recieve baidu push call back
	// 
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
