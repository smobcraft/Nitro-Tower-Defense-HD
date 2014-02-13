using UnityEngine;
using System.Collections;

public class ScaleGUITexture : MonoBehaviour {

	public float nativeY;
	public float nativeX;

	float up2InsetY;
	float up2InsetX;
	float screenRatio;
	float screenRatioX;


	// Use this for initialization
	void Start () {
		up2InsetX = this.guiTexture.pixelInset.width;
		up2InsetY = this.guiTexture.pixelInset.height;
		screenRatio = Screen.height * (1 / nativeY);
		screenRatioX = Screen.width * (1 / nativeX);
		resizeButton (this.guiTexture, up2InsetX, up2InsetY, screenRatio);
	}
	
	void resizeButton( GUITexture text, float width, float height, float ratio)
	{
		text.pixelInset = new Rect (0, 0, width * ratio, height * ratio);
	}
}
