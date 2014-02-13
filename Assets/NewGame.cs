using UnityEngine;
using System.Collections;

public class NewGame : MonoBehaviour {
	
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetMouseButtonDown(0) && guiTexture.HitTest(Input.mousePosition) )
		{
			PlayerPrefs.DeleteAll();
			Application.LoadLevel("Level0");
		}
		for (int i = 0; i < Input.touchCount; i++)
		{
			
			if (this.guiTexture.HitTest(Input.GetTouch(i).position))
			{
				if (Input.GetTouch(i).phase == TouchPhase.Began)
				{
					PlayerPrefs.DeleteAll();
					Application.LoadLevel("Level0");
				}
			}
		}
	}
}
