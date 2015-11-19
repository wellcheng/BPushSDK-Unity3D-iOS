using System.Runtime.InteropServices;
using UnityEngine;

public class BPushSDKConector : MonoBehaviour
{
	// interface for unity invoke
	[DllImport("__Internal")]
	private static extern void bindChannel();
	[DllImport("__Internal")]
	private static extern void unbindChannel();
	[DllImport("__Internal")]
	private static extern void getChannelId();
	[DllImport("__Internal")]
	private static extern void getAppId();
	[DllImport("__Internal")]
	private static extern void listTags();
	[DllImport("__Internal")]
	private static extern void setTags(string tagsJsonString);
	[DllImport("__Internal")]
	private static extern void delTags(string tagsJsonString);
	// end
	

	public static void baiduBindChannel()
	{
		if (Application.platform == RuntimePlatform.IPhonePlayer)
		{
			bindChannel();
		}
	}

	public static void baiduUnBindChannel()
	{
		if (Application.platform == RuntimePlatform.IPhonePlayer)
		{
			unbindChannel();
		}
	}

	public static void baiduGetChannelId()
	{
		if (Application.platform == RuntimePlatform.IPhonePlayer)
		{
			getChannelId();
		}
	}

	public static void baiduGetAppId()
	{
		if (Application.platform == RuntimePlatform.IPhonePlayer)
		{
			getAppId();
		}
	}

	public static void baiduListTags()
	{
		if (Application.platform == RuntimePlatform.IPhonePlayer)
		{
			listTags();
		}
	}

	public static void baiduSetTags(string tagsJsonString)
	{
		if (Application.platform == RuntimePlatform.IPhonePlayer)
		{
			setTags(tagsJsonString);
		}
	}

	public static void baiduDelTags(string tagsJsonString)
	{
		if (Application.platform == RuntimePlatform.IPhonePlayer)
		{
			delTags(tagsJsonString);
		}
	}

}
